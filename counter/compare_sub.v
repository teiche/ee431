`timescale 1ns / 1ps

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
            // If the clock goes off and our value equals the counter, match interrupt!
            if (clk_in && enable && (value[31:0] == counter[31:0])) begin
               match <= 1'b1;
            end else if (clear || !reset) begin
               match <= 1'b0;
            end
    
endmodule
