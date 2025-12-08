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
    input clk,
    input rst_n,
    input start,

    output valid,
    output [15:0] ch1,
    output [15:0] ch2,
    output [15:0] ch3,
    output [15:0] ch4,
    
    // LTC2324 Interface
    input CLKOUT,
    input SDO1,
    input SDO2,
    input SDO3,
    input SDO4,
    output nCNV,
    output SCK

    );

//internal counters for timing control
logic [1:0] tcnvh_clk_cnt;
localparam logic [1:0] TCNVH_CLK_MAX = 3;

logic [4:0] tconv_clk_cnt;
localparam logic [4:0] TCONV_CLK_MAX = 24;

logic [3:0] tsck_clk_cnt;
localparam logic [3:0] TSCK_CLK_MAX = 16 - 1;

logic [3:0] tdsckhcnvh_clk_cnt;
localparam logic [3:0] TDSCKHCNVH_CLK_MAX = 10;


typedef enum logic [2:0] {
    IDLE,
    START,
    CONVERT,
    ACQUIRE, // Fire sck
    DSCKHCNVH,
} state_t;

state_t state, next_state;

// State Transition
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end


always_comb begin
    next_state = state;
    unique case (state)
        IDLE: begin
            if (start) begin
                next_state = START;
            end
        end
        START: begin
            next_state = CONVERT;
        end
        CONVERT: begin
            next_state = ACQUIRE;
        end
        ACQUIRE: begin
            next_state = DELAY;
        end
        DSCKHCNVH: begin
            next_state = IDLE;
        end
    endcase


endmodule
