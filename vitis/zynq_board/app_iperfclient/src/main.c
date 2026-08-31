/*
 * Copyright (C) 2017 - 2021 Xilinx, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
 * SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
 * OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
 * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
 * OF SUCH DAMAGE.
 *
 */

#include <stdio.h>
#include "xparameters.h"
#include "netif/xadapter.h"
#include "platform.h"
#include "platform_config.h"
#include "lwipopts.h"
#include "xil_printf.h"
#include "sleep.h"
#include "lwip/priv/tcp_priv.h"
#include "lwip/init.h"
#include "lwip/inet.h"
#include "xil_cache.h"

#include "xil_types.h"
#include "xil_cache.h"
#include "gpio_ps.h"
#include "axi_dma.h"
#include "sysparams.h"

#if LWIP_DHCP==1
#include "lwip/dhcp.h"
extern volatile int dhcp_timoutcntr;
#endif

extern volatile int TcpFastTmrFlag;
extern volatile int TcpSlowTmrFlag;

#define DEFAULT_IP_ADDRESS	"192.168.1.10"
#define DEFAULT_IP_MASK		"255.255.255.0"
#define DEFAULT_GW_ADDRESS	"192.168.1.1"

void platform_enable_interrupts(void);
void start_application(void);
void transfer_data(u8 *dma_data);
void print_app_header(void);

#if defined (__arm__) && !defined (ARMR5)
#if XPAR_GIGE_PCS_PMA_SGMII_CORE_PRESENT == 1 || \
		 XPAR_GIGE_PCS_PMA_1000BASEX_CORE_PRESENT == 1
int ProgramSi5324(void);
int ProgramSfpPhy(void);
#endif
#endif

#ifdef XPS_BOARD_ZCU102
#ifdef XPAR_XIICPS_0_DEVICE_ID
int IicPhyReset(void);
#endif
#endif

struct netif server_netif;
ip_addr_t dhcp_server_ip_addr = IPADDR4_INIT(0x00000000);

//u8 __attribute__ ((aligned(32))) rx_buf[DMA_PKT_SIZE*DMA_PKT_CNT+DMA_PKT_HDR_SIZE+DMA_PKT_PADS];

struct __attribute__((packed)) {
    u8 hdr[32]; 	//used bytes 24-31 for header. Extra bytes needed for 32-bytes align and contiguous memory placement with "data" array
    u8 __attribute__ ((aligned(32))) data[DMA_PKT_SIZE*DMA_PKT_CNT];

}dma_buf;

u8 *rx_buf = &dma_buf.hdr[24];

void dma_store_buff(u32 dma_pkt_cnt)
{
	u32 i = 0;
	XStatus status;

	while(i < dma_pkt_cnt)
	{
		//status = dma_s2mm(&rx_buf[i*DMA_PKT_SIZE+DMA_PKT_HDR_SIZE]);
		status = dma_s2mm(&dma_buf.data[i*DMA_PKT_SIZE]);
		if(status == XST_SUCCESS)
			i++;
	}
}

static void print_ip(char *msg, ip_addr_t *ip)
{
	print(msg);
	xil_printf("%d.%d.%d.%d\r\n", ip4_addr1(ip), ip4_addr2(ip),
			ip4_addr3(ip), ip4_addr4(ip));
}

static void print_ip_settings(ip_addr_t *ip, ip_addr_t *mask, ip_addr_t *gw)
{
	print_ip("Board IP:       ", ip);
	print_ip("Netmask :       ", mask);
	print_ip("Gateway :       ", gw);
}

static void assign_default_ip(ip_addr_t *ip, ip_addr_t *mask, ip_addr_t *gw)
{
	int err;

	xil_printf("Configuring default IP %s \r\n", DEFAULT_IP_ADDRESS);

	err = inet_aton(DEFAULT_IP_ADDRESS, ip);
	if (!err)
		xil_printf("Invalid default IP address: %d\r\n", err);

	err = inet_aton(DEFAULT_IP_MASK, mask);
	if (!err)
		xil_printf("Invalid default IP MASK: %d\r\n", err);

	err = inet_aton(DEFAULT_GW_ADDRESS, gw);
	if (!err)
		xil_printf("Invalid default gateway address: %d\r\n", err);
}

// /media/denc/Storage/Projects/FPGA/Microphone_Zynq/smart_zynqsl_vitis/app_iperfclient_system/_ide/bootimage
#define ETHERNET 0
int main(void)
{
	struct netif *netif;

	struct dhcp *dhcp;

#ifdef ETHERNET
	/* the mac address of the board. this should be unique per board */
	unsigned char mac_ethernet_address[] = {
		0x00, 0x0a, 0x35, 0x00, 0x01, 0x02 };

	netif = &server_netif;


	init_platform();

	xil_printf("\r\n\r\n");
	xil_printf("-----Zynq microphones array application-----\r\n");

	/* initialize lwIP */
	lwip_init();

	/* Add network interface to the netif_list, and set it as default */
	if (!xemac_add(netif, NULL, NULL, NULL, mac_ethernet_address,
				PLATFORM_EMAC_BASEADDR)) {
		xil_printf("Error adding N/W interface\r\n");
		return -1;
	}
	netif_set_default(netif);

	/* now enable interrupts */
	platform_enable_interrupts();

	/* specify that the network if is up */
	netif_set_up(netif);

	print_ip("Initial DHCP server IP:       ", &dhcp_server_ip_addr);

#if (LWIP_DHCP==1)
	/* Create a new DHCP client for this interface.
	 * Note: you must call dhcp_fine_tmr() and dhcp_coarse_tmr() at
	 * the predefined regular intervals after starting the client.
	 */
	dhcp_start(netif);
	dhcp_timoutcntr = 24;
	while (((netif->ip_addr.addr) == 0) && (dhcp_timoutcntr > 0))
		xemacif_input(netif);

	if (dhcp_timoutcntr <= 0) {
		if ((netif->ip_addr.addr) == 0) {
			xil_printf("ERROR: DHCP request timed out\r\n");
			assign_default_ip(&(netif->ip_addr),
					&(netif->netmask), &(netif->gw));
		}
	}

	dhcp = netif_dhcp_data(netif);
	dhcp_server_ip_addr = dhcp->server_ip_addr;
	print_ip("Got DHCP server IP:       ", &dhcp_server_ip_addr);

	/* print IP address, netmask and gateway */
#else
	assign_default_ip(&(netif->ip_addr), &(netif->netmask), &(netif->gw));
#endif
	print_ip_settings(&(netif->ip_addr), &(netif->netmask), &(netif->gw));

#endif


	xil_printf("\r\n");


	/* start the application*/
	start_application();
	xil_printf("\r\n");

	init_gpio_ps();

	rx_buf[0] = 'Z';
	rx_buf[1] = 'y';
	rx_buf[2] = 'n';
	rx_buf[3] = 'q';
	set_gpio_pin(PIN_LED2, 0);
	//set_led2(1);
	//set_gpio_pin(PIN_TEST_MODE, 1); 		//enable test mode
	set_gpio_pin(PIN_TEST_MODE, 0); 		//disable test mode
	//set_led1(0);		//0 - active reset
	set_gpio_pin(PIN_RSTN, 0);		//0 - active reset

	//for test only
	//set_gpio_pin(PIN_TEST_MODE, 0);
	//set_gpio_pin(PIN_RSTN, 1);
	//for test only
	dma_init();

	while (1) {


		set_gpio_pin(PIN_RSTN, 1);
		dma_store_buff(DMA_PKT_CNT);
		Xil_DCacheFlushRange((UINTPTR)rx_buf, DMA_PKT_SIZE*DMA_PKT_CNT+DMA_PKT_HDR_SIZE);

		if (TcpFastTmrFlag) {
			tcp_fasttmr();
			TcpFastTmrFlag = 0;
		}
		if (TcpSlowTmrFlag) {
			tcp_slowtmr();
			TcpSlowTmrFlag = 0;
		}
		xemacif_input(netif);
		transfer_data(rx_buf);
	}

	/* never reached */
	cleanup_platform();

	return 0;
}
