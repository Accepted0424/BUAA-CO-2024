`timescale 1ns / 1ps

module GRF(
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD,
    input clk,
    input reset,
    input WE,
	 input [31:0] pc,
    output [31:0] RD1,
    output [31:0] RD2
    );
	 
	reg [31:0] regs [0:31];
	 
	assign RD1 = ((A1 == A3) && (A3 != 5'b0) && WE)?WD:regs[A1];
	assign RD2 = ((A2 == A3) && (A3 != 5'b0) && WE)?WD:regs[A2];
	 
	integer i;

	initial begin
		for (i = 0;i < 32; i = i + 1) begin
			regs[i] = 0;
		end
	end
	
	always @(posedge clk) begin
		if (reset) begin
			for (i = 0; i < 32; i = i + 1) begin
				regs[i] <= 32'b0;
			end 
		end
		else begin
			if (WE && (A3 != 5'b0)) begin
				regs[A3] <= WD;
				$display("%d@%h: $%d <= %h", $time, pc-4, A3, WD);
			end
		end
	end

endmodule
