`timescale 1ns / 1ps

module prescalar_sub(
    input reset,
    input clk_in,
    input [31:0] scaling,
    output wire clk_out
    );
    
    reg [31:0] counter;
    reg scaled_out;
    
    // Mux for scaling check, if its all zeros directly rout clk_in to clk_out
    assign clk_out = (scaling == 31'b0) ? clk_in : scaled_out;
    
    // Usual counter
    always @(posedge clk_in or negedge reset)
        if (!reset) begin
            counter = 32'b0;
            scaled_out = 'b0;
        end else if (clk_in && counter == scaling) begin
            // if our internal counter matches the scaling reg set, invert scaled clock output
            scaled_out <= ~scaled_out;
            counter <= 32'b0;
        end else begin
            // if no condition established, keep counting
            counter <= counter + 1;
        end
endmodule