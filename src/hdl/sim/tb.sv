`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2026 04:48:24 PM
// Design Name: 
// Module Name: tb
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


module tb();

bit CLK;

logic               r_rst = 1'b1;
logic   [ 7 : 0 ]   w_sck, w_ws;
tri     [ 7 : 0 ]   w_sd;
logic   [ 8 : 0 ]   w_wso [7 : 0];

logic   [ 31 : 0 ]  w_dout   [ 7 : 0 ];
logic               w_dout_dv;
logic   [255 : 0 ]  w_dout_wide;

genvar g;

//61.44
//initial forever CLK =#8.138 ~CLK;

//12.288
initial forever CLK =#40.69 ~CLK;

ics52000_matrix_wrapper ics52000_matrix_wrapper
(
    .CLK        ( CLK       ),
    .SRST       ( r_rst     ),
    .TEST_MODE  ( 0         ),

    .DOUT_0     ( w_dout[0] ),
    .DOUT_1     ( w_dout[1] ),
    .DOUT_2     ( w_dout[2] ),
    .DOUT_3     ( w_dout[3] ),
    .DOUT_4     ( w_dout[4] ),
    .DOUT_5     ( w_dout[5] ),
    .DOUT_6     ( w_dout[6] ),
    .DOUT_7     ( w_dout[7] ),
    .DOUT_DV    ( w_dout_dv ),
    .DOUT_WIDE  ( w_dout_wide),

    .WS         ( w_ws      ),
    .SCK        ( w_sck     ),
    .SD         ( w_sd      )
);

assign w_wso[0][0] = w_ws[0];
assign w_wso[1][0] = w_ws[1];
assign w_wso[2][0] = w_ws[2];
assign w_wso[3][0] = w_ws[3];
assign w_wso[4][0] = w_ws[4];
assign w_wso[5][0] = w_ws[5];
assign w_wso[6][0] = w_ws[6];
assign w_wso[7][0] = w_ws[7];

// parameter line0_nums = {8'h07, 8'h06, 8'h05, 8'h04, 8'h03, 8'h02, 8'h55, 8'hAA};
// parameter line1_nums = {8'h0F, 8'h0E, 8'h0D, 8'h0C, 8'h0B, 8'h0A, 8'h55, 8'hAA};
// parameter line2_nums = {8'h17, 8'h16, 8'h15, 8'h14, 8'h13, 8'h12, 8'h11, 8'h10};
// parameter line3_nums = {8'h1F, 8'h1E, 8'h1D, 8'h1C, 8'h1B, 8'h1A, 8'h19, 8'h18};
// parameter line4_nums = {8'h27, 8'h26, 8'h25, 8'h24, 8'h23, 8'h22, 8'h21, 8'h20};
// parameter line5_nums = {8'h2F, 8'h2E, 8'h2D, 8'h2C, 8'h2B, 8'h2A, 8'h29, 8'h28};
// parameter line6_nums = {8'h37, 8'h36, 8'h35, 8'h34, 8'h33, 8'h32, 8'h31, 8'h30};
// parameter line7_nums = {8'h3F, 8'h3E, 8'h3D, 8'h3C, 8'h3B, 8'h3A, 8'h39, 8'h38};

parameter line0_nums = {8'h07, 8'h06, 8'h05, 8'h04, 8'h03, 8'h02, 8'h01, 8'h00};
parameter line1_nums = {8'h0F, 8'h0E, 8'h0D, 8'h0C, 8'h0B, 8'h0A, 8'h09, 8'h08};
parameter line2_nums = {8'h17, 8'h16, 8'h15, 8'h14, 8'h13, 8'h12, 8'h11, 8'h10};
parameter line3_nums = {8'h1F, 8'h1E, 8'h1D, 8'h1C, 8'h1B, 8'h1A, 8'h19, 8'h18};
parameter line4_nums = {8'h27, 8'h26, 8'h25, 8'h24, 8'h23, 8'h22, 8'h21, 8'h20};
parameter line5_nums = {8'h2F, 8'h2E, 8'h2D, 8'h2C, 8'h2B, 8'h2A, 8'h29, 8'h28};
parameter line6_nums = {8'h37, 8'h36, 8'h35, 8'h34, 8'h33, 8'h32, 8'h31, 8'h30};
parameter line7_nums = {8'h3F, 8'h3E, 8'h3D, 8'h3C, 8'h3B, 8'h3A, 8'h39, 8'h38};

generate 
for(g = 0; g < 8; g = g + 1)    
begin : gloop_sim_mic

    sim_mic_ics52000 
    #(
        .NUM    ( line0_nums [g*8+: 8]  )
    )
    sim_mic_ics52000_line0
    (
        .SCK    ( w_sck[0]              ),
        .WS     ( w_wso[0][g]           ),
        .WSO    ( w_wso[0][g+1]         ),
        .SDO    ( w_sd [0]              )
    );

    sim_mic_ics52000 
    #(
        .NUM    ( line1_nums [g*8+: 8]  )
    )
    sim_mic_ics52000_line1
    (
        .SCK    ( w_sck[1]              ),
        .WS     ( w_wso[1][g]           ),
        .WSO    ( w_wso[1][g+1]         ),
        .SDO    ( w_sd [1]              )
    );

    sim_mic_ics52000 
    #(
        .NUM    ( line2_nums [g*8+: 8]  )
    )
    sim_mic_ics52000_line2
    (
        .SCK    ( w_sck[2]              ),
        .WS     ( w_wso[2][g]           ),
        .WSO    ( w_wso[2][g+1]         ),
        .SDO    ( w_sd [2]              )
    );

    sim_mic_ics52000 
    #(
        .NUM    ( line3_nums [g*8+: 8]  )
    )
    sim_mic_ics52000_line3
    (
        .SCK    ( w_sck[3]              ),
        .WS     ( w_wso[3][g]           ),
        .WSO    ( w_wso[3][g+1]         ),
        .SDO    ( w_sd [3]              )
    );

    sim_mic_ics52000 
    #(
        .NUM    ( line4_nums [g*8+: 8]  )
    )
    sim_mic_ics52000_line4
    (
        .SCK    ( w_sck[4]              ),
        .WS     ( w_wso[4][g]           ),
        .WSO    ( w_wso[4][g+1]         ),
        .SDO    ( w_sd [4]              )
    );

    sim_mic_ics52000 
    #(
        .NUM    ( line5_nums [g*8+: 8]  )
    )
    sim_mic_ics52000_line5
    (
        .SCK    ( w_sck[5]              ),
        .WS     ( w_wso[5][g]           ),
        .WSO    ( w_wso[5][g+1]         ),
        .SDO    ( w_sd [5]              )
    );

    sim_mic_ics52000 
    #(
        .NUM    ( line6_nums [g*8+: 8]  )
    )
    sim_mic_ics52000_line6
    (
        .SCK    ( w_sck[6]              ),
        .WS     ( w_wso[6][g]           ),
        .WSO    ( w_wso[6][g+1]         ),
        .SDO    ( w_sd [6]              )
    );

    sim_mic_ics52000 
    #(
        .NUM    ( line7_nums [g*8+: 8]  )
    )
    sim_mic_ics52000_line7
    (
        .SCK    ( w_sck[7]              ),
        .WS     ( w_wso[7][g]           ),
        .WSO    ( w_wso[7][g+1]         ),
        .SDO    ( w_sd [7]              )
    );

end
endgenerate




initial
begin

    repeat(20)  @(posedge CLK);
    r_rst <= 1'b0;
    
    forever
    begin
        @(posedge CLK);
    end

end

endmodule
`resetall