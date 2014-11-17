`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2014 09:41:08 PM
// Design Name: 
// Module Name: prescalar_sub
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


module prescalar_sub(
    input reset,
    input clk_in,
    input [31:0] scaling,
    output wire clk_out
    );
    
    reg [31:0] counter;
    reg scaled_out;
    
    assign clk_out = (scaling == 31'b0) ? clk_in : scaled_out;
    
    // Usual counter
    always @(posedge clk_in)
        if (!reset) begin
            counter = 32'b0;
            scaled_out = 'b0;
        end else if (counter == scaling) begin
            scaled_out <= ~scaled_out;
            counter <= 32'b0;
        end else begin
            counter <= counter + 1;
        end
endmodule
