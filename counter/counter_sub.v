`timescale 1ns / 1ps

module counter_sub(
    input reset,
    input clk_in,
    input enable,
    output reg [31:0] count,
    output reg overflow,
    input clear_overflow
    );
    
    // Usual counter with async reset
    always @(posedge clk_in or negedge reset)
        if (enable && clk_in) begin
            // Overflow interrupt
            if (count == 32'hFFFFFFFF) begin
                overflow = 1'b1;
                count = 32'h0;
            end else begin
                //otherwise increment
                count = count + 1;  
            end
        end else if (clear_overflow) begin
            overflow <= 1'b0;
        end else if (!reset) begin
            overflow <= 1'b0;
            count = 32'b0;
        end

        
endmodule
