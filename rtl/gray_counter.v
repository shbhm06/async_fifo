`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.06.2026 22:50:44
// Design Name: 
// Module Name: gray_counter
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


module gray_counter #(
    parameter WIDTH = 4
    )(
    input wire clk,
    input wire rst_n,
    input wire inc,
    output reg [WIDTH:0] bin,
    output wire [WIDTH:0] gray
    );
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            bin <= 0;
        else if (inc)
            bin <= bin + 1;
    end
    
    assign gray = bin ^ (bin >> 1);
endmodule
