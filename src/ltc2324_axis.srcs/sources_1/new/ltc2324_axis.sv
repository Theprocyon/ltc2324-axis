`timescale 1ns / 1ps

`include "axis_if.sv"
`include "epcl_fifo.sv"
//////////////////////////////////////////////////////////////////////////////////
// Company: EPCL
// Engineer: theprocyon
// 
// Create Date: 2025/12/10
// Design Name: 
// Module Name: ltc2324_axis
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Wrapper 
// 
// Dependencies: ltc2324_core.sv, axis_if.sv
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module ltc2324_axis(
    input clk,
    input rst_n,
    input start,
    
    axis_if.master ch1_axis,
    axis_if.master ch2_axis,
    axis_if.master ch3_axis,
    axis_if.master ch4_axis,
    
    input CLKOUT,
    input SDO1,
    input SDO2,
    input SDO3,
    input SDO4,
    output nCNV,
    output SCK
);

    logic core_valid;
    logic [15:0] core_ch1;
    logic [15:0] core_ch2;
    logic [15:0] core_ch3;
    logic [15:0] core_ch4;

    ltc2324_core u_ltc2324_core (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .valid(core_valid),
        .ch1(core_ch1),
        .ch2(core_ch2),
        .ch3(core_ch3),
        .ch4(core_ch4),
        .CLKOUT(CLKOUT),
        .SDO1(SDO1),
        .SDO2(SDO2),
        .SDO3(SDO3),
        .SDO4(SDO4),
        .nCNV(nCNV),
        .SCK(SCK)
    );

    // ====== 4-depth FIFOs for each channel ======
    
    axis_fifo #(
        .DATA_WIDTH(16),
        .DEPTH(4)
    ) u_fifo_ch1 (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(core_valid),
        .wr_data(core_ch1),
        .rd_en(ch1_axis.tready & ch1_axis.tvalid),
        .rd_data(ch1_axis.tdata),
        .valid(ch1_axis.tvalid),
        .full(),
        .empty()
    );

    axis_fifo #(
        .DATA_WIDTH(16),
        .DEPTH(4)
    ) u_fifo_ch2 (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(core_valid),
        .wr_data(core_ch2),
        .rd_en(ch2_axis.tready & ch2_axis.tvalid),
        .rd_data(ch2_axis.tdata),
        .valid(ch2_axis.tvalid),
        .full(),
        .empty()
    );

    axis_fifo #(
        .DATA_WIDTH(16),
        .DEPTH(4)
    ) u_fifo_ch3 (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(core_valid),
        .wr_data(core_ch3),
        .rd_en(ch3_axis.tready & ch3_axis.tvalid),
        .rd_data(ch3_axis.tdata),
        .valid(ch3_axis.tvalid),
        .full(),
        .empty()
    );

    axis_fifo #(
        .DATA_WIDTH(16),
        .DEPTH(4)
    ) u_fifo_ch4 (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(core_valid),
        .wr_data(core_ch4),
        .rd_en(ch4_axis.tready & ch4_axis.tvalid),
        .rd_data(ch4_axis.tdata),
        .valid(ch4_axis.tvalid),
        .full(),
        .empty()
    );

endmodule

