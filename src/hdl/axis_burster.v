`timescale 1ns / 1ps
//`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.04.2019 11:40:02
// Design Name: 
// Module Name: source_data
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



/*
axis_burster
#(
    .BURST_SIZE               (   ),     // axis packet data beats count
    .DWIDTH                   (   ),
    .TDEST_WIDTH              (   ),
    .TUSER_WIDTH              (   )
)
axis_burster
(
    .CLK                      (   ),     // in   , u[1],
    .RST_N                    (   ),     // in   , u[1],

    .S_AXIS_TDATA             (   ),     // in   , u[DWIDTH],
    .S_AXIS_TKEEP             (   ),     // in   , u[DWIDTH/8],
    .S_AXIS_TVALID            (   ),     // in   , u[1],
    .S_AXIS_TDEST             (   ),     // in   , u[TDEST_WIDTH],
    .S_AXIS_TUSER             (   ),     // in   , u[TUSER_WIDTH],
    .S_AXIS_TREADY            (   ),     // out  , u[1],


    .M_AXIS_TDATA             (   ),     // out  , u[DWIDTH],
    .M_AXIS_TKEEP             (   ),     // out  , u[DWIDTH/8],
    .M_AXIS_TLAST             (   ),     // out  , u[1],
    .M_AXIS_TVALID            (   ),     // out  , u[1],
    .M_AXIS_TDEST             (   ),     // out  , u[TDEST_WIDTH],
    .M_AXIS_TUSER             (   ),     // out  , u[TUSER_WIDTH],
    .M_AXIS_TREADY            (   )      // in   , u[1],
);
*/



module axis_burster
    #(
        
        parameter   BURST_SIZE = 64,
        parameter   DWIDTH     = 64,
        parameter   TDEST_WIDTH= 4,
        parameter   TUSER_WIDTH= 8

    )
    (
        input       wire                                    CLK,
        input       wire                                    RST_N,

        input       wire    [ DWIDTH-1  : 0 ]               S_AXIS_TDATA,
        input       wire    [ DWIDTH/8-1: 0 ]               S_AXIS_TKEEP,
        input       wire                                    S_AXIS_TVALID,
        input       wire    [ TDEST_WIDTH-1 : 0 ]           S_AXIS_TDEST,
        input       wire    [ TUSER_WIDTH-1 : 0 ]           S_AXIS_TUSER,
        output      wire                                    S_AXIS_TREADY,


        output      wire    [ DWIDTH-1  : 0 ]               M_AXIS_TDATA,
        output      wire    [ DWIDTH/8-1: 0 ]               M_AXIS_TKEEP,
        output      wire                                    M_AXIS_TLAST,
        output      wire                                    M_AXIS_TVALID,
        output      wire    [ TDEST_WIDTH-1 : 0 ]           M_AXIS_TDEST,
        output      wire    [ TUSER_WIDTH-1 : 0 ]           M_AXIS_TUSER,
        input       wire                                    M_AXIS_TREADY
    );


parameter   Z = 0.1;

reg     [ 21 : 0 ]  r_tlast_cnt = 22'd0;
wire                w_tlast;

always @(posedge CLK)
if(RST_N == 1'b0)
begin
    r_tlast_cnt <=#Z 22'd0;
end
else
begin
    if((S_AXIS_TVALID & M_AXIS_TREADY) == 1'b1)
    begin
        if(r_tlast_cnt == BURST_SIZE - 1)
        begin
            r_tlast_cnt <=#Z 22'd0;
        end
        else
        begin
            r_tlast_cnt <=#Z r_tlast_cnt + 1'b1;
        end
    end
end

assign w_tlast = (r_tlast_cnt == BURST_SIZE - 1) ? 1'b1 : 1'b0;

assign M_AXIS_TDATA  = S_AXIS_TDATA;
assign M_AXIS_TKEEP  = S_AXIS_TKEEP;
assign M_AXIS_TVALID = S_AXIS_TVALID;
assign M_AXIS_TDEST  = S_AXIS_TDEST;
assign M_AXIS_TUSER  = S_AXIS_TUSER;
assign S_AXIS_TREADY = M_AXIS_TREADY;
assign M_AXIS_TLAST  = w_tlast;
endmodule

