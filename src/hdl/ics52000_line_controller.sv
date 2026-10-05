`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2026 04:46:59 PM
// Design Name: 
// Module Name: ics52000_line_controller
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


module ics52000_line_controller
#(
    parameter                   Z = 0.1,
    parameter                   ILA = 0
)
(
    input   wire                CLK,
    input   wire                SRST,
    input   wire                TEST_MODE,
    input   wire    [  7 : 0 ]  LINE_ID,
    input   wire                FRAME_START,

    output  wire    [ 31 : 0 ]  DOUT,
    output  wire                DOUT_DV,
    
    input   wire                SD
);


(*IOB = "TRUE"*)
logic   r_sd_iob = 1'b0;

logic   [  7 : 0 ]  r_bit_cnt = 8'd0;
logic               r_bit_cnt_en = 1'b0;
//logic   [  2 : 0 ]  r_mic_id;
(*MARK_DEBUG = "TRUE"*)
logic   [ 31 : 0 ]  r_din_sh;
(*MARK_DEBUG = "TRUE"*)
logic               r_din_sh_dv = 1'b0;
logic   [ 31 : 0 ]  r_test_cnt = 32'd0;
logic   [ 31 : 0 ]  r_dout;
logic               r_dout_dv = 1'b0;

logic   [  2 : 0 ]  r_mic_id = 3'd0;
//(*MARK_DEBUG = "TRUE"*)
logic   [ 23 : 0 ]  r_dbg_mic [ 7 : 0 ];
//(*MARK_DEBUG = "TRUE"*)
logic   [  7 : 0 ]  r_dbg_mic_dv = 8'd0;

always_ff @(negedge CLK)
    r_sd_iob <=#Z SD; 

always_ff @(posedge CLK)
if(SRST == 1'b1)
begin
    r_bit_cnt <=#Z 8'd0;
    r_bit_cnt_en <=#Z 1'b0;
end
else
begin
    if(FRAME_START == 1'b1)
    begin
        r_bit_cnt <=#Z 8'd0;
        r_bit_cnt_en <=#Z 1'b1;
    end
    else
    begin
        if(r_bit_cnt_en == 1'b1)
            r_bit_cnt <=#Z r_bit_cnt + 1'b1;
    end
end

always_ff @(posedge CLK)
begin
    r_din_sh <=#Z {r_din_sh[30:0], r_sd_iob};

    if(r_bit_cnt[4:0] == 5'd31)
        r_din_sh_dv <=#Z 1'b1;
    else
        r_din_sh_dv <=#Z 1'b0;
end

// always_ff @(posedge CLK)
// if(r_bit_cnt[4:0] == 5'd31)
//     r_mic_id <=#Z r_bit_cnt[7:5];

always_ff @(posedge CLK)
if(SRST == 1'b1)
    r_test_cnt <=#Z {LINE_ID, 24'd0};
else
    if(r_din_sh_dv == 1'b1)
        r_test_cnt <=#Z {LINE_ID, r_test_cnt[23:0] + 1'b1};

always_ff @(posedge CLK)
if(r_din_sh_dv == 1'b1)
begin
    if(TEST_MODE == 1'b0)
        r_dout <=#Z {LINE_ID, r_din_sh[31:8]};
    else
        r_dout <=#Z r_test_cnt;
end

always_ff @(posedge CLK)
if(SRST == 1'b1)
    r_dout_dv <=#Z 1'b0;
else
    r_dout_dv <=#Z r_din_sh_dv;


always_ff @(posedge CLK)
if(SRST == 1'b1)
begin
    r_mic_id <= 3'd0;
end
else
begin
    if(r_dout_dv == 1'b1)
    begin
        r_mic_id <= r_mic_id + 1'b1;

        if(r_mic_id == 3'd0)
        begin
            r_dbg_mic   [0] <= r_dout[23:0];
            r_dbg_mic_dv[0] <= 1'b1;
        end
        else
        begin
            r_dbg_mic_dv[0] <= 1'b0;
        end

         if(r_mic_id == 3'd1)
        begin
            r_dbg_mic   [1] <= r_dout[23:0];
            r_dbg_mic_dv[1] <= 1'b1;
        end
        else
        begin
            r_dbg_mic_dv[1] <= 1'b0;
        end

         if(r_mic_id == 3'd2)
        begin
            r_dbg_mic   [2] <= r_dout[23:0];
            r_dbg_mic_dv[2] <= 1'b1;
        end
        else
        begin
            r_dbg_mic_dv[2] <= 1'b0;
        end

         if(r_mic_id == 3'd3)
        begin
            r_dbg_mic   [3] <= r_dout[23:0];
            r_dbg_mic_dv[3] <= 1'b1;
        end
        else
        begin
            r_dbg_mic_dv[3] <= 1'b0;
        end

         if(r_mic_id == 3'd4)
        begin
            r_dbg_mic   [4] <= r_dout[23:0];
            r_dbg_mic_dv[4] <= 1'b1;
        end
        else
        begin
            r_dbg_mic_dv[4] <= 1'b0;
        end

         if(r_mic_id == 3'd5)
        begin
            r_dbg_mic   [5] <= r_dout[23:0];
            r_dbg_mic_dv[5] <= 1'b1;
        end
        else
        begin
            r_dbg_mic_dv[5] <= 1'b0;
        end

         if(r_mic_id == 3'd6)
        begin
            r_dbg_mic   [6] <= r_dout[23:0];
            r_dbg_mic_dv[6] <= 1'b1;
        end
        else
        begin
            r_dbg_mic_dv[6] <= 1'b0;
        end


         if(r_mic_id == 3'd7)
        begin
            r_dbg_mic   [7] <= r_dout[23:0];
            r_dbg_mic_dv[7] <= 1'b1;
        end
        else
        begin
            r_dbg_mic_dv[7] <= 1'b0;
        end


    end
    else
        r_dbg_mic_dv <= 8'd0;
end



assign DOUT = r_dout;
assign DOUT_DV = r_dout_dv;


generate 
    if(ILA == 1)
    begin : gloop_ila
        ila_mic_line ila_mic_line 
        (
            .clk    (CLK), // input wire clk
            .probe0 (r_dbg_mic[0]), // input wire [23:0]  probe0  
            .probe1 (r_dbg_mic[1]), // input wire [23:0]  probe1 
            .probe2 (r_dbg_mic[2]), // input wire [23:0]  probe2 
            .probe3 (r_dbg_mic[3]), // input wire [23:0]  probe3 
            .probe4 (r_dbg_mic[4]), // input wire [23:0]  probe4 
            .probe5 (r_dbg_mic[5]), // input wire [23:0]  probe5 
            .probe6 (r_dbg_mic[6]), // input wire [23:0]  probe6 
            .probe7 (r_dbg_mic[7]), // input wire [23:0]  probe7 
            .probe8 (r_dbg_mic_dv), // input wire [7:0]  probe8 
            .probe9 (r_din_sh_dv) // input wire [0:0]  probe9
        );
    end
endgenerate


endmodule
`resetall