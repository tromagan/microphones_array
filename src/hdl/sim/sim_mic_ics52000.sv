`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2026 11:37:46 AM
// Design Name: 
// Module Name: sim_mic_ics52000
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


module sim_mic_ics52000
#(
    parameter   NUM = 8'd0
)
(
    input   wire    SCK,
    input   wire    WS,

    output  wire    WSO,
    output  tri     SDO

);

logic               r_ws = 1'b0;
logic               w_ws_rise;
logic               r_bit_cnt_en = 1'b0;
logic   [ 4 : 0 ]   r_bit_cnt;
logic               r_wso = 1'b0;


logic   [31 : 0 ]   r_dout = 32'd0;
logic   [31 : 0 ]   r_dout_sh;
//logic               r_sdo = 1'b0;
initial
begin
    forever
    begin
        @(posedge SCK);

        if(WS == 1'b1)
        begin
            if(r_ws == 1)
            begin
                $display("WS 2 clocks ERROR!");
                $stop();
            end
        end
    end
end

assign w_ws_rise = WS & ~r_ws;

always_ff @(posedge SCK)
begin
    r_ws <= WS;


    if(WS & ~r_ws)
    begin
        r_bit_cnt <= 5'd0;
        r_bit_cnt_en <= 1'b1;
    end
    else
        if(r_bit_cnt_en == 1'b1)
        begin
            r_bit_cnt <= r_bit_cnt + 1'b1;
            if(r_bit_cnt == 5'd31)
                r_bit_cnt_en <= 1'b0;
        end
end

always_ff @(negedge SCK)
if(r_bit_cnt == 5'd31)
    r_wso <=#0.1 1'b1;
else
    r_wso <=#0.1 1'b0;

always_ff @(posedge SCK)    
begin
    if(WS & ~r_ws)
    begin
        //r_dout_sh <= {NUM,r_dout[23:0]};
        r_dout_sh <= {NUM,r_dout[15:0], 8'bXXXXXXXX};
        r_dout <= r_dout + 1'b1;
    end

    if(r_bit_cnt_en == 1'b1)
    begin
        //if(r_bit_cnt < 5'd23)
            r_dout_sh <= {r_dout_sh[30:0], 1'b0};
        //else
        //    r_dout_sh <= {r_dout_sh[30:0], 1'bX};
    end
end

assign WSO = r_wso;
assign SDO = (r_bit_cnt_en == 1'b1) ? r_dout_sh[31] : 1'bZ;

endmodule
`resetall