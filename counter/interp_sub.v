`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2014 06:34:00 PM
// Design Name: 
// Module Name: interp_sub
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


module interp_sub(
    input reset,
    input clk_in,
    input [31:0] d_in,
    input [31:0] current_count,
    input ld,
    input oe,
    input [2:0] addr,
    output reg [31:0] d_out,
    output set_clock,
    output reg [31:0] set_comp,
    output reg [31:0] set_scale,
    output rst_scale,
    output rst_cntr,
    output rst_comp,
    output enable_overflow,
    output enable_compare,
    output int_clear_overflow,
    output int_clear_compare
    );
    
    wire [31:0] count;
    reg [31:0] control;
    
    assign rst_cntr = reset;
    assign rst_comp = reset;
    assign rst_scale = reset;
    assign int_clear_overflow = control[8];
    assign int_clear_compare = control[9];
    assign enable_overflow = control[10];
    assign enable_compare = control[11];
    assign set_clock = control[12];
    assign count[31:0] = current_count[31:0];
    
    always @(posedge clk_in) begin
    
        if (!reset) begin
            control = 32'b0;
            set_scale = 32'b0;
            set_comp = 32'b0; 
        end else begin
            //clear needed control bits! FIXME
            if (oe) begin
                case (addr)
                    'b000: d_out = control;
                    'b001: d_out = count;
                    'b010: d_out = set_scale;
                    'b011: d_out = set_comp;
                    default: d_out = 32'b0;
                endcase
            end else if (ld) begin
                case (addr)
                    'b000: control = d_in;
                    'b010: set_scale = d_in;
                    'b011: set_comp = d_in;
                    default: d_out = 32'b0;
                endcase
            end
        end
    end
    
//    always @(*)
//        if (!reset) begin
//            control = 32'b0;
//            set_scale = 32'b0;
//            set_comp = 32'b0;
//        end
endmodule
