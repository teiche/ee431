`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2014 06:34:00 PM
// Design Name: 
// Module Name: counter_sub
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


module counter_sub(
    input reset,
    input clk_in,
    input enable,
    output reg [31:0] count,
    output reg overflow,
    input clear_overflow
    );
    
    // Usual counter
    always @(posedge clk_in)
        if (enable && clk_in) begin
            if (count == 32'hFFFFFFFF) begin
                overflow = 1'b1;
                count = 32'h0;
            end else begin
                count = count + 1;  
            end
        end else if (clear_overflow) begin
            overflow <= 1'b0;
        end else if (!reset) begin
            overflow <= 1'b0;
            count = 32'b0;
        end

        
endmodule
