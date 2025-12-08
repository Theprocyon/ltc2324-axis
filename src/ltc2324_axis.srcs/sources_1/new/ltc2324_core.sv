`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: EPCL
// Engineer: theprocyon
// 
// Create Date: 2025/12/08 21:21:13
// Design Name: 
// Module Name: ltc2324_core
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


module ltc2324_core(
    // system Interface
    input logic clk,
    input logic rst_n,
    input logic start,
    input logic valid,

    // LTC2324 Interface
    output logic CLKOUT,
    output logic SDO1,
    output logic SDO2,
    output logic SDO3,
    output logic SDO4,
    output logic nCNV,

    );
endmodule
