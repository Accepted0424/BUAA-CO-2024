`timescale 1ns / 1ps

module PC(
    input clk,
    input reset,
    input en,
    input [31:0] next_pc,
	 input req,
	 output [3:0] exc,
    output [31:0] current_pc
    );
    
    reg [31:0] pc;
    assign current_pc = pc;
	 assign exc = ((pc < 32'h3000) || (pc > 32'h6ffc))? 4'd4:
					  (pc[1:0] != 2'b0)? 4'd4: 4'd0;

    initial begin
        pc = 32'h3000;
    end

    always @(posedge clk) begin
        if (reset || req) begin
            pc <= req?32'h4180: 32'h3000;
        end
        else begin
            if (en) begin
               pc <= next_pc;
            end
        end
    end

endmodule
