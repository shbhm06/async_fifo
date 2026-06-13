`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.06.2026 22:50:44
// Design Name: 
// Module Name: fifo_mem
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


module fifo_mem #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
    )(
    input wire wr_clk,
    input wire wr_en,
    input wire [ADDR_WIDTH-1:0] wr_addr,
    input wire [DATA_WIDTH-1:0] wdata,
    
    input wire rd_clk,
    input wire rd_en,
    input wire [ADDR_WIDTH-1:0] rd_addr,
    output reg [DATA_WIDTH-1:0] rdata
    );
    
    // Memory array
    reg [DATA_WIDTH-1:0] mem [0:2**ADDR_WIDTH - 1];
    
    always @(posedge wr_clk) begin
        if (wr_en)
            mem[wr_addr] <= wdata;
    end
    
    always @(posedge rd_clk) begin
        if(rd_en)
            rdata <= mem[rd_addr];
    end
    
endmodule
