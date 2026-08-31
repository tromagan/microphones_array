#include <stdio.h>
#include "xparameters.h"
#include "xgpiops.h"
#include "xstatus.h"
#include "xplatform_info.h"
#include "sleep.h"
#include "gpio_ps.h"






XGpioPs Gpio;

u32 init_gpio_ps()
{
	u32 Status;

	XGpioPs_Config *ConfigPtr;

	ConfigPtr = XGpioPs_LookupConfig(XPAR_XGPIOPS_0_DEVICE_ID);


	Status = XGpioPs_CfgInitialize(&Gpio, ConfigPtr, ConfigPtr->BaseAddr);
	if (Status != XST_SUCCESS)
		return XST_FAILURE;

	for(int i = 0; i < 8; i++)
	{
		XGpioPs_SetDirectionPin(&Gpio, i+54, 1);
		XGpioPs_SetOutputEnablePin(&Gpio, i+54, 1);
	}

//	XGpioPs_SetDirectionPin(&Gpio, LED1_PIN, 1);
//	XGpioPs_SetOutputEnablePin(&Gpio, LED1_PIN, 1);
//
//	XGpioPs_SetDirectionPin(&Gpio, LED2_PIN, 1);
//	XGpioPs_SetOutputEnablePin(&Gpio, LED2_PIN, 1);



	return XST_SUCCESS;
}

//void set_led1(u8 val)
//{
//	XGpioPs_WritePin(&Gpio, LED1_PIN, val);
//}
//
//void set_led2(u8 val)
//{
//	XGpioPs_WritePin(&Gpio, LED2_PIN, val);
//}

void set_gpio_pin(u32 pin, u32 val)
{
	XGpioPs_WritePin(&Gpio, pin + 54, val);
}
