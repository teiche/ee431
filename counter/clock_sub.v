`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2014 09:41:08 PM
// Design Name: 
// Module Name: clock_sub
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


module clock_sub(
    input clk_in,
    input ext_in,
    input sel,
    output wire clk_out
    );
    // Do we even need reset here?  I don't think so.
    assign clk_out = (sel) ? clk_in : ext_in;
    
endmodule
