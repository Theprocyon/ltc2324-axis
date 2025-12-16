`timescale 1ns / 1ps


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
    input wire clk,
    input wire rst_n,
    input wire start,
    
    // Channel 1
    output wire [15:0] ch1_axis_tdata,
    output wire        ch1_axis_tvalid,
    input  wire        ch1_axis_tready,
    
    // Channel 2
    output wire [15:0] ch2_axis_tdata,
    output wire        ch2_axis_tvalid,
    input  wire        ch2_axis_tready,
    
    // Channel 3
    output wire [15:0] ch3_axis_tdata,
    output wire        ch3_axis_tvalid,
    input  wire        ch3_axis_tready,
    
    // Channel 4
    output wire [15:0] ch4_axis_tdata,
    output wire        ch4_axis_tvalid,
    input  wire        ch4_axis_tready,
    
    input wire CLKOUT,
    input wire SDO1,
    input wire SDO2,
    input wire SDO3,
    input wire SDO4,
    output wire nCNV,
    output wire SCK
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
        .rd_en(ch1_axis_tready & ch1_axis_tvalid), 
        .rd_data(ch1_axis_tdata),
        .valid(ch1_axis_tvalid),
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
        .rd_en(ch2_axis_tready & ch2_axis_tvalid),
        .rd_data(ch2_axis_tdata),
        .valid(ch2_axis_tvalid),
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
        .rd_en(ch3_axis_tready & ch3_axis_tvalid),
        .rd_data(ch3_axis_tdata),
        .valid(ch3_axis_tvalid),
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
        .rd_en(ch4_axis_tready & ch4_axis_tvalid),
        .rd_data(ch4_axis_tdata),
        .valid(ch4_axis_tvalid),
        .full(),
        .empty()
    );

endmodule
