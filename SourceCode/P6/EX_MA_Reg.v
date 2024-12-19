`timescale 1ns / 1ps

module EX_MA_Reg(
		input clk,
		input clr,
		input reset,
		input en,
		input [1:0] Mem2Reg,
		input RegWrite,
      input MemWrite,
      input [2:0] store_type,
		input [2:0] load_type,
		input [3:0] mdOp,
		
		input [31:0] Instr,
      input [31:0] ALU_C,
      input [31:0] Grt_EX_valid,
      input [4:0] A3,
		input [31:0] pc_add4,
		input [4:0] RT,
		input cmp_check,
		input [5:0] bOp,
		
		output reg [1:0] Mem2Reg_out,
		output reg RegWrite_out,
      output reg MemWrite_out,
      output reg [2:0] store_type_out,
		output reg [2:0] load_type_out,
		output reg [3:0] mdOp_out,
		output reg [31:0] Instr_out,
      output reg [31:0] ALU_C_out,
      output reg [31:0] Grt_EX_valid_out,
      output reg [4:0] A3_out,
		output reg [31:0] pc_add4_out,
		output reg [4:0] RT_out,
		output reg cmp_check_out,
		output reg [5:0] bOp_out
    );
	 
	 initial begin
			Mem2Reg_out <= 0;
			RegWrite_out <= 0;
			MemWrite_out <= 0;
			store_type_out <= 0;
			load_type_out <= 0;
			mdOp_out <= 0;
			Instr_out <= 0;
			ALU_C_out <= 0;
			Grt_EX_valid_out <= 0;
			A3_out <= 0;
			pc_add4_out <= 0;
			RT_out <= 0;
			cmp_check_out <= 0;
			bOp_out <= 0;
	 end
	 
	 always @(posedge clk) begin
			if (reset || clr) begin
				Mem2Reg_out <= 0;
				RegWrite_out <= 0;
				MemWrite_out <= 0;
				store_type_out <= 0;
				load_type_out <= 0;
				mdOp_out <= 0;
				Instr_out <= 0;
				ALU_C_out <= 0;
				Grt_EX_valid_out <= 0;
				A3_out <= 0;
				pc_add4_out <= 0;
				RT_out <= 0;
				cmp_check_out <= 0;
				bOp_out <= 0;
			end else begin
				if (en) begin
					Mem2Reg_out <= Mem2Reg;
					RegWrite_out <= RegWrite;
					MemWrite_out <= MemWrite;
					store_type_out <= store_type;
					load_type_out <= load_type;
					mdOp_out <= mdOp;
					Instr_out <= Instr;
					ALU_C_out <= ALU_C;
					Grt_EX_valid_out <= Grt_EX_valid;
					A3_out <= A3;
					pc_add4_out <= pc_add4;
					RT_out <= RT;
					cmp_check_out <= cmp_check;
					bOp_out <= bOp;
				end
			end
	 end


endmodule
