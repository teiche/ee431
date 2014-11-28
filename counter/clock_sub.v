`timescale 1ns / 1ps


module clock_sub(
    input clk_in,
    input ext_in,
    input sel,
    output wire clk_out
    );
    // Do we even need reset here?  I don't think so.  It is just a MUX
    assign clk_out = (sel) ? clk_in : ext_in;
    
endmodule
