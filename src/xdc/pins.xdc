set_property PACKAGE_PIN G22 [get_ports MDIO_PHY_0_mdc]
set_property PACKAGE_PIN H22 [get_ports MDIO_PHY_0_mdio_io]
set_property PACKAGE_PIN A19 [get_ports {RGMII_0_rd[0]}]
set_property PACKAGE_PIN A18 [get_ports {RGMII_0_rd[1]}]
set_property PACKAGE_PIN A17 [get_ports {RGMII_0_rd[2]}]
set_property PACKAGE_PIN A16 [get_ports {RGMII_0_rd[3]}]
set_property PACKAGE_PIN B17 [get_ports RGMII_0_rx_ctl]
set_property PACKAGE_PIN D18 [get_ports RGMII_0_rxc]
set_property PACKAGE_PIN D22 [get_ports {RGMII_0_td[0]}]
set_property PACKAGE_PIN C22 [get_ports {RGMII_0_td[1]}]
set_property PACKAGE_PIN E21 [get_ports {RGMII_0_td[2]}]
set_property PACKAGE_PIN D21 [get_ports {RGMII_0_td[3]}]
set_property PACKAGE_PIN A22 [get_ports RGMII_0_tx_ctl]
set_property PACKAGE_PIN A21 [get_ports RGMII_0_txc]

set_property IOSTANDARD LVCMOS25 [get_ports MDIO_PHY_0_mdc]
set_property IOSTANDARD LVCMOS25 [get_ports MDIO_PHY_0_mdio_io]
set_property IOSTANDARD LVCMOS25 [get_ports {RGMII_0_rd[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {RGMII_0_rd[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {RGMII_0_rd[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {RGMII_0_rd[3]}]
set_property IOSTANDARD LVCMOS25 [get_ports RGMII_0_rx_ctl]
set_property IOSTANDARD LVCMOS25 [get_ports RGMII_0_rxc]
set_property IOSTANDARD LVCMOS25 [get_ports {RGMII_0_td[0]}]
set_property IOSTANDARD LVCMOS25 [get_ports {RGMII_0_td[1]}]
set_property IOSTANDARD LVCMOS25 [get_ports {RGMII_0_td[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {RGMII_0_td[3]}]
set_property IOSTANDARD LVCMOS25 [get_ports RGMII_0_tx_ctl]
set_property IOSTANDARD LVCMOS25 [get_ports RGMII_0_txc]

set_property SLEW FAST [get_ports {RGMII_0_td[0]}]
set_property SLEW FAST [get_ports {RGMII_0_td[1]}]
set_property SLEW FAST [get_ports {RGMII_0_td[2]}]
set_property SLEW FAST [get_ports {RGMII_0_td[3]}]
set_property SLEW FAST [get_ports RGMII_0_tx_ctl]
set_property SLEW FAST [get_ports RGMII_0_txc]

set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS25} [get_ports {LEDS[0]}]
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS25} [get_ports {LEDS[1]}]
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS25} [get_ports {LEDS[2]}]
set_property -dict {PACKAGE_PIN L22 IOSTANDARD LVCMOS25} [get_ports {LEDS[3]}]

set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports SCK];      
set_property -dict {PACKAGE_PIN T17 IOSTANDARD LVCMOS25 SLEW FAST DRIVE 16} [get_ports WS];       



set_property -dict {PACKAGE_PIN N15 IOSTANDARD LVCMOS25} [get_ports {SD[0]}];
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS25} [get_ports {SD[1]}];
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25} [get_ports {SD[2]}];
set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS25} [get_ports {SD[3]}];
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS25} [get_ports {SD[4]}];
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS25} [get_ports {SD[5]}];
set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS25} [get_ports {SD[6]}];
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS25} [get_ports {SD[7]}];