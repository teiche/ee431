`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2014 06:34:00 PM
// Design Name: 
// Module Name: timer_top
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


module timer_top(
    input clk,
    input [31:0] d_in,
    input [2:0] addr,
    input ld,
    input oe,
    input ext_in,
    output [31:0] d_out,
    //output pwm_a,
    //output pwm_b,
    //output pwm_c,
    //output pwd_d,
    output overflow_interrupt,
    output top_interrupt,
    input rst
    );
    
    wire [31:0] counter_out;
    wire [31:0] control_compare;
    wire [31:0] control_scale;
        
    interp_sub interp_sub0 (
           .reset (rst),
           .clk_in (clk),
           .d_in (d_in[31:0]),
           .current_count (counter_out[31:0]),
           .ld (ld),
           .oe (oe),
           .addr (addr[2:0]),
           .d_out (d_out[31:0]),
           .set_clock (control_clock),
           .set_comp (control_compare[31:0]),
           .set_scale (control_scale[31:0]),
           .rst_scale (prescalar_rst),
           .rst_cntr (counter_rst),
           .rst_comp (compare_rst),
           .enable_overflow (control_en_overflow),
           .enable_compare (control_en_compare),
           .int_clear_overflow (control_clear_overflow),
           .int_clear_compare (control_clear_compare)
        );
            
    counter_sub count_sub0 (
            .reset (counter_rst),
            .clk_in (clk_scaled),
            .enable (control_en_overflow),
            .count (counter_out[31:0]),
            .overflow  (overflow_interrupt),
            .clear_overflow (control_clear_overflow)
        );
        
        
    clock_sub clock_sub0 (
           .clk_in (clk),
           .ext_in (ext_in),
           .sel (control_clock),
           .clk_out (clk_raw)
        );
        
    prescalar_sub pre_sub0 (
           .reset (prescalar_rst),
           .clk_in (clk_raw),
           .scaling (control_scale[31:0]),
           .clk_out (clk_scaled)
        );
    
    compare_sub compare_sub0 (
           .reset (compare_rst),
           .clk_in (clk_scaled),
           .enable (control_en_compare),
           .value (control_compare[31:0]),
           .counter (counter_out[31:0]),
           .clear (control_clear_compare),
           .match (top_interrupt)
        );

endmodule



