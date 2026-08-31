`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/28/2019 04:40:31 PM
// Design Name: 
// Module Name: raw_data_to_axis
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module raw_data_to_axis
#(
    parameter       DWIDTH = 160,
    parameter       UWIDTH = 20         //1 bit per 1 byte of TDATA
)
(


    input   wire    [ DWIDTH - 1 : 0 ]  DIN,
    input   wire    [ UWIDTH - 1 : 0 ]  USER,
    input   wire                        DIN_DV,


    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK CLK" *)
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK,ASSOCIATED_BUSIF DIN:M_AXIS" *)
    input   wire                        CLK,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TDATA" *)  
    output  wire    [ DWIDTH - 1 : 0 ]  M_AXIS_DATA,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TUSER" *)  
    output  wire    [ UWIDTH - 1 : 0 ]  M_AXIS_TUSER,
    (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 M_AXIS TVALID" *) 
    output  wire                        M_AXIS_TVALID

);

assign M_AXIS_DATA      = DIN;
assign M_AXIS_TUSER     = USER;
assign M_AXIS_TVALID    = DIN_DV;

endmodule
