`timescale 1ns / 1ps
// Module: Top level for the whole counter, no logic, all blocks


module timer_top(
    input clk,
    input [31:0] d_in,
    input [2:0] addr,
    input ld,
    input oe,
    input ext_in,
    output [31:0] d_out,
    output pwm_a,
    output pwm_b,
    output pwm_c,
    output pwm_d,
    output overflow_interrupt,
    output top_interrupt,
    input rst
    );
    
    wire [31:0] counter_out;
    wire [31:0] control_compare;
    wire [31:0] control_scale;
    wire [31:0] pwm_set_A;
    wire [31:0] pwm_set_B;
    wire [31:0] pwm_set_C;
    wire [31:0] pwm_set_D;
        
    // INTERPRETER
    // Description: The interpreter takes in all I/O and distributes it accordingly throughout the system
    // Activity: Asynchrnous
    // Clock Domain: external clock    
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
           .int_clear_compare (control_clear_compare),
           .pwm_reset_A (pwm_reset_A),
           .pwm_enable_A (pwm_enable_A),
           .pwm_set_A (pwm_set_A[31:0]),
           .pwm_out_A (pwm_out_A),
           .pwm_ext_A (pwm_a),
           .pwm_reset_B (pwm_reset_B),
           .pwm_enable_B (pwm_enable_B),
           .pwm_set_B (pwm_set_B[31:0]),
           .pwm_out_B (pwm_out_B),
           .pwm_ext_B (pwm_b),
           .pwm_reset_C (pwm_reset_C),
           .pwm_enable_C (pwm_enable_C),
           .pwm_set_C (pwm_set_C[31:0]),
           .pwm_out_C (pwm_out_C),
           .pwm_ext_C (pwm_c),
           .pwm_reset_D (pwm_reset_D),
           .pwm_enable_D (pwm_enable_D),
           .pwm_set_D (pwm_set_D[31:0]),
           .pwm_out_D (pwm_out_D),
           .pwm_ext_D (pwm_d)
        );
           
       
    // COUNTER
    // Description: The counter...counts, triggers an overflow interrupt
    // Activity: Clock stimulus, async reset
    // Clock Domain: scaled clock from prescalar block      
    counter_sub count_sub0 (
            .reset (counter_rst),
            .clk_in (clk_scaled),
            .enable (control_en_overflow),
            .count (counter_out[31:0]),
            .overflow  (overflow_interrupt),
            .clear_overflow (control_clear_overflow)
        );
        
    // CLOCK
    // Description: The clock block selects between using the external clock or an external "in" as the internal clock
    // Activity: Clock stimulus, dumb MUX
    // Clock Domain: external clock OR external in        
    clock_sub clock_sub0 (
           .clk_in (clk),
           .ext_in (ext_in),
           .sel (control_clock),
           .clk_out (clk_raw)
        );

    // PRESCALAR
    // Description: The prescalar scales the signal
    // Activity: clocked, async reset
    // Clock Domain: selected clock (from the CLOCK block), sends out the scaled clock         
    prescalar_sub pre_sub0 (
           .reset (prescalar_rst),
           .clk_in (clk_raw),
           .scaling (control_scale[31:0]),
           .clk_out (clk_scaled)
        );
        
    // COMPARE
    // Description: The compare block waits for a matching value from the counter, can interrupt
    // Activity: Clock stimulus, async reset
    // Clock Domain: scaled clock     
    compare_sub compare_sub0 (
           .reset (compare_rst),
           .clk_in (clk_scaled),
           .enable (control_en_compare),
           .value (control_compare[31:0]),
           .counter (counter_out[31:0]),
           .clear (control_clear_compare),
           .match (top_interrupt)
        );

    // PULSE WIDTH MODULATION
    // Description: The PWM blocks are set using a pwm_set register
    // Activity: Clock stimulus, async reset
    // Clock Domain: scaled clock         
    pwm_sub pwm_sub_A (
            .clk_in (clk_scaled),
            .reset (pwm_reset_A),
            .enable (pwm_enable_A),
            .set (pwm_set_A[31:0]),
            .out (pwm_out_A)
    );
    
    pwm_sub pwm_sub_B (
            .clk_in (clk_scaled),
            .reset (pwm_reset_B),
            .enable (pwm_enable_B),
            .set (pwm_set_B[31:0]),
            .out (pwm_out_B)
    );
    
    pwm_sub pwm_sub_C (
            .clk_in (clk_scaled),
            .reset (pwm_reset_C),
            .enable (pwm_enable_C),
            .set (pwm_set_C[31:0]),
            .out (pwm_out_C)
    );
    
    pwm_sub pwm_sub_D (
            .clk_in (clk_scaled),
            .reset (pwm_reset_D),
            .enable (pwm_enable_D),
            .set (pwm_set_D[31:0]),
            .out (pwm_out_D)
    );

endmodule



