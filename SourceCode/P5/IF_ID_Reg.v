`timescale 1ns / 1ps

module IF_ID_Reg(
		input clk,
		input reset,
		input en,
		input clr,
		input [31:0] Instr,
		input [31:0] pc_add4,
		output reg [31:0] Instr_out,
		output reg [31:0] pc_add4_out
    );
	 
	 initial begin
			Instr_out <= 0;
			pc_add4_out <= 0;
	 end
	 
	 always @(posedge clk) begin
		if (reset || clr) begin
			Instr_out <= 0;
			pc_add4_out <= 0;
		end else begin
			if (en) begin
				Instr_out <= Instr;
				pc_add4_out <= pc_add4;
			end
		end
	 end


endmodule
