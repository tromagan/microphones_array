`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2026 11:43:32 AM
// Design Name: 
// Module Name: debug_cnt
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


module debug_cnt
(
    input   wire                CLK,
    output  wire  [ 31 : 0 ]    DOUT
);

reg     [ 31 : 0 ]  r_cnt = 0;

always @(posedge CLK)
    r_cnt <= r_cnt + 1'b1;

assign DOUT = r_cnt;

endmodule
`resetall