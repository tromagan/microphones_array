`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2026 04:59:10 PM
// Design Name: 
// Module Name: ics52000_line_clk_gen
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


module ics52000_line_clk_gen
#(
    parameter   Z = 0.1
)
(
    input   wire                CLK,
    input   wire                SRST,
    output  wire                FRAME_START,
    output  wire                WS,
    output  wire                SCK
);


logic   [ 7 : 0 ]   r_clk_div_cnt = 8'd0;

logic               r_frame_start = 1'b0;

logic               w_sck;
(*IOB = "TRUE"*)
logic               r_ws_iob = 1'b0;

(*MARK_DEBUG = "TRUE"*)
logic               r_ws_dbg = 1'b0;

always_ff @(posedge CLK)
if(SRST == 1'b1)
begin
    r_clk_div_cnt <=#Z 8'd0;
end
else
begin
    if(r_clk_div_cnt == 8'd255)
        r_clk_div_cnt <=#Z 8'd0;
    else
        r_clk_div_cnt <=#Z r_clk_div_cnt + 1'b1;
end

always_ff @(negedge CLK)
if(r_clk_div_cnt == 8'd255)
    r_frame_start <=#Z 1'b1;
else
    r_frame_start <=#Z 1'b0;



ODDR 
#(
    .DDR_CLK_EDGE   ("SAME_EDGE"), // "OPPOSITE_EDGE" or "SAME_EDGE"
    .INIT           (1'b0), // Initial value of Q: 1'b0 or 1'b1
    .SRTYPE         ("SYNC") // Set/Reset type: "SYNC" or "ASYNC"
) 
ODDR_inst 
(
    .Q  (   w_sck       ), // 1-bit DDR output
    .C  (   CLK         ), // 1-bit clock input
    .CE (   1'b1        ), // 1-bit clock enable input
    .D1 (   1'b1        ), // 1-bit data input (positive edge)
    .D2 (   1'b0        ), // 1-bit data input (negative edge)
    .R  (   1'b0        ), // 1-bit reset
    .S  (   1'b0        ) // 1-bit set
);

always_ff @(negedge CLK)
if(r_clk_div_cnt == 8'd255)
begin
    r_ws_iob <=#Z 1'b1;
    r_ws_dbg <=#Z 1'b1;
end
else
begin
    r_ws_iob <=#Z 1'b0;
    r_ws_dbg <=#Z 1'b0;
end

assign FRAME_START = r_frame_start;

assign SCK = w_sck;
assign WS = r_ws_iob;

endmodule
`resetall