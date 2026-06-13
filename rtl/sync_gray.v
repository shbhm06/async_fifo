`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.06.2026 22:50:44
// Design Name: 
// Module Name: sync_gray
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


module sync_gray #(
    parameter WIDTH = 4
    )(
    input wire clk,
    input wire rst_n,
    input wire [WIDTH:0] gray_in,
    output reg [WIDTH:0] gray_out
    );
    
    reg [WIDTH:0] sync1;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync1 <= 0;
            gray_out <= 0;
        end else begin
            sync1 <= gray_in;
            gray_out <= sync1;
        end
    end
endmodule
