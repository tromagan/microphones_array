`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2026 10:23:38 AM
// Design Name: 
// Module Name: ics52000_matrix_wrapper
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


module ics52000_matrix_wrapper
(
    input   wire                CLK,
    input   wire                SRST,

    input   wire                TEST_MODE,

    output  wire   [ 31 : 0 ]   DOUT_0,
    output  wire   [ 31 : 0 ]   DOUT_1,
    output  wire   [ 31 : 0 ]   DOUT_2,
    output  wire   [ 31 : 0 ]   DOUT_3,
    output  wire   [ 31 : 0 ]   DOUT_4,
    output  wire   [ 31 : 0 ]   DOUT_5,
    output  wire   [ 31 : 0 ]   DOUT_6,
    output  wire   [ 31 : 0 ]   DOUT_7,
    output  wire   [255 : 0 ]   DOUT_WIDE,
    output  wire                DOUT_DV,

    output  wire                WS,
    output  wire                SCK,
    input   wire   [  7 : 0 ]   SD

);

localparam ILAS = 8'b0000_1110;

wire                w_ws, w_sck;
wire    [ 31 : 0 ]  w_dout  [ 7 : 0];
wire    [  7 : 0 ]  w_dout_dv;
wire                w_frame_start;
//wire    [ 63 : 0 ]  w_line_id = {8'd7, 8'd6, 8'd5, 8'd4, 8'd3, 8'd2, 8'd1, 8'd0};
//wire    [ 63 : 0 ]  w_line_id = {8'hA7, 8'h56, 8'hA5, 8'h54, 8'hA3, 8'h52, 8'hA1, 8'h50};
wire    [ 63 : 0 ]  w_line_id = 64'd0;
genvar              g;


ics52000_line_clk_gen ics52000_line_clk_gen
(
    .CLK            (   CLK             ),
    .SRST           (   SRST            ),
    .FRAME_START    (   w_frame_start   ),
    .WS             (   w_ws            ),
    .SCK            (   w_sck           )
);

generate
for(g = 0; g < 8; g = g + 1)
begin : gloop_line_ctrl
    ics52000_line_controller 
    #(
        .ILA            (ILAS       [g]         )
    )
    ics52000_line_controller
    (
        .CLK            (   CLK                 ),
        .SRST           (   SRST                ),
        .FRAME_START    (   w_frame_start       ),
        .TEST_MODE      (   TEST_MODE           ),
        .LINE_ID        (   w_line_id[g*8+ : 8] ),
        .SD             (   SD       [g]        ),
        .DOUT           (   w_dout   [g]        ),
        .DOUT_DV        (   w_dout_dv[g]        )
    );
end
endgenerate

//swap bytes in 32 bits
function [31 : 0 ] swpb(input [ 31 : 0 ] data);
begin
    swpb = {data[7:0],data[15:8],data[23:16],data[31:24]};
end
endfunction

assign DOUT_0 = w_dout[0];
assign DOUT_1 = w_dout[1];
assign DOUT_2 = w_dout[2];
assign DOUT_3 = w_dout[3];
assign DOUT_4 = w_dout[4];
assign DOUT_5 = w_dout[5];
assign DOUT_6 = w_dout[6];
assign DOUT_7 = w_dout[7];
assign DOUT_DV = w_dout_dv[0];

assign DOUT_WIDE = {swpb(w_dout[7]),swpb(w_dout[6]),swpb(w_dout[5]),swpb(w_dout[4]),swpb(w_dout[3]),swpb(w_dout[2]),swpb(w_dout[1]),swpb(w_dout[0])};

assign WS = w_ws;
assign SCK = w_sck;

endmodule
`resetall