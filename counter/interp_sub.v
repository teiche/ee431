`timescale 1ns / 1ps

module interp_sub(
    // Main input lines, including the usual reset and clock, with routing for the counter as well
    input reset,
    input clk_in,
    input [31:0] d_in,
    input [31:0] current_count,
    input ld,
    input oe,
    input [2:0] addr,
    
    // General output for the CPU
    output reg [31:0] d_out,
    
    // Control lines for the rest of the blocks (some are registers)
    output set_clock,
    output reg [31:0] set_comp,
    output reg [31:0] set_scale,
    output rst_scale,
    output rst_cntr,
    output rst_comp,
    output enable_overflow,
    output enable_compare,
    output int_clear_overflow,
    output int_clear_compare,
    
    // PWM control connections
    output pwm_reset_A,
    output pwm_enable_A,
    output reg [31:0] pwm_set_A,
    input pwm_out_A,
    output pwm_ext_A,
    
    output pwm_reset_B,
    output pwm_enable_B,
    output reg [31:0] pwm_set_B,
    input pwm_out_B,
    output pwm_ext_B,
    
    output pwm_reset_C,
    output pwm_enable_C,
    output reg [31:0] pwm_set_C,
    input pwm_out_C,
    output pwm_ext_C,
    
    output pwm_reset_D,
    output pwm_enable_D,
    output reg [31:0] pwm_set_D,
    input pwm_out_D,
    output pwm_ext_D
    );
    
    wire [31:0] count;
    reg [31:0] control;
    
    // Routing for reset lines, and pwm_output lines
    assign rst_cntr = reset;
    assign rst_comp = reset;
    assign rst_scale = reset;
    assign pwm_reset_A = reset;
    assign pwm_ext_A = pwm_out_A;
    assign pwm_reset_B = reset;
    assign pwm_ext_B = pwm_out_B;
    assign pwm_reset_C = reset;
    assign pwm_ext_C = pwm_out_C;
    assign pwm_reset_D = reset;
    assign pwm_ext_D = pwm_out_D;
    
    // Mapping the control register with bits that will be used by various blocks
    assign int_clear_overflow = control[0];
    assign int_clear_compare = control[1];
    assign enable_overflow = control[2];
    assign enable_compare = control[3];
    assign set_clock = control[4];
    
    assign pwm_enable_A = control[8];
    assign pwm_enable_B = control[9];
    assign pwm_enable_C = control[10];
    assign pwm_enable_D = control[11];
    
    // Linking the count reg to the current_count input lines, this is just because of bad naming
    assign count[31:0] = current_count[31:0];
    
    // Trigger on output enables, loads, or resets
    always @(reset or oe or ld) begin
    
        // Reset catches
        if (!reset) begin
            control = 32'b0;
            set_scale = 32'b0;
            set_comp = 32'b0; 
            pwm_set_A = 32'b0;
        end else begin
            //clear needed control bits! FIXME
            if (oe) begin
                // Routs control...set_comp registers to the d_out if output enable with the corresponding address was queried
                case (addr)
                    'b000: d_out = control;
                    'b001: d_out = count;
                    'b010: d_out = set_scale;
                    'b011: d_out = set_comp;
                    default: d_out = 32'b0;
                endcase
            end else if (ld) begin
                case (addr)
                    // Like OE, LD will route the set_scale ect lines to d_in when the correct register is set in ADDR
                    'b000: control = d_in;
                    'b010: set_scale = d_in;
                    'b011: set_comp = d_in;
                    'b100: pwm_set_A = d_in;
                    'b101: pwm_set_B = d_in;
                    'b110: pwm_set_C = d_in;
                    'b111: pwm_set_D = d_in;
                    default: d_out = 32'b0;
                endcase
            end
        end
    end
endmodule
