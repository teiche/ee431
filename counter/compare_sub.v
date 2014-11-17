`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2014 06:28:00 PM
// Design Name: 
// Module Name: compare_sub
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


module compare_sub(
    input reset,
    input clk_in,
    input enable,
    input [31:0] value,
    input [31:0] counter,
    input clear,
    output reg match
    );
    
    // Usual counter
    always @(posedge clk_in)
            if (enable && (value[31:0] == counter[31:0])) begin
               match <= 1'b1;
            end else if (clear || !reset) begin
               match <= 1'b0;
            end
    
endmodule
