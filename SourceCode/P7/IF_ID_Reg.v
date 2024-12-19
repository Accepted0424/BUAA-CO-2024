`timescale 1ns / 1ps

module IF_ID_Reg(
		input clk,
		input reset,
		input req,
		input clear_bd,
		input [31:0] EPC,
		input en,
		input clr,
		input [31:0] Instr,
		input [31:0] pc_add4,
		input [3:0] IF_EXCCode_pip,
		input BD,
		output reg [31:0] Instr_out,
		output reg [31:0] pc_add4_out,
		output reg [3:0] IF_EXCCode_pip_out,
		output reg BD_out
    );
	 
	 initial begin
			Instr_out <= 0;
			pc_add4_out <= 0;
			IF_EXCCode_pip_out <= 0;
			BD_out <= 0;
	 end
	 
	 always @(posedge clk) begin
		if (reset || clr || req || clear_bd) begin
			Instr_out <= 0;
			pc_add4_out <= (reset)? 32'h00003004:
								(req)? 32'h00004184:
								(clear_bd)? EPC:
								0;
			IF_EXCCode_pip_out <= 0;
			BD_out <= (clear_bd)? BD: 0;
		end else begin
			if (en) begin
				Instr_out <= Instr;
				pc_add4_out <= pc_add4;
				IF_EXCCode_pip_out <= IF_EXCCode_pip;
				BD_out <= BD;
			end
		end
	 end


endmodule
