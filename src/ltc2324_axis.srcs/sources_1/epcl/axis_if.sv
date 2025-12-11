`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: EPCL
// Engineer: 
// 
// Create Date: 2025-12-02
// 
//////////////////////////////////////////////////////////////////////////////////

interface axis_if #(
    parameter DATA_WIDTH = 16
);
    logic [DATA_WIDTH-1:0] tdata;
    logic                  tvalid;
    logic                  tready;
    
    modport master (
        output tdata,
        output tvalid,
        input  tready
    );
    
    modport slave (
        input  tdata,
        input  tvalid,
        output tready
    );

endinterface : axis_if
