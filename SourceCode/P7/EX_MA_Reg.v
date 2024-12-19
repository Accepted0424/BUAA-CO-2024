`timescale 1ns / 1ps

module EX_MA_Reg(
		input clk,
		input clr,
		input reset,
		input req,
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
		input [4:0] RD,
		input cmp_check,
		input [5:0] bOp,
		input BD,
		input [3:0] IF_EXCCode,
		input [3:0] ID_EXCCode,
		input [3:0] EX_EXCCode,
		input CP0_write,
		input is_eret,
		
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
		output reg [4:0] RD_out,
		output reg cmp_check_out,
		output reg [5:0] bOp_out,
		output reg BD_out,
		output reg [3:0] IF_EXCCode_out,
		output reg [3:0] ID_EXCCode_out,
		output reg [3:0] EX_EXCCode_out,
		output reg CP0_write_out,
		output reg is_eret_out
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
			RD_out <= 0;
			cmp_check_out <= 0;
			bOp_out <= 0;
			BD_out <= 0;
			IF_EXCCode_out <= 0;
			ID_EXCCode_out <= 0;
			EX_EXCCode_out <= 0;
			CP0_write_out <= 0;
			is_eret_out <= 0;
	 end
	 
	 always @(posedge clk) begin
			if (reset || clr || req) begin
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
				pc_add4_out <= reset? 32'h00003004:
									req? 32'h00004184: 
									0;
				RT_out <= 0;
				RD_out <= 0;
				cmp_check_out <= 0;
				bOp_out <= 0;
				BD_out <= 0;
				IF_EXCCode_out <= 0;
				ID_EXCCode_out <= 0;
				EX_EXCCode_out <= 0;
				CP0_write_out <= 0;
				is_eret_out <= 0;
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
					RD_out <= RD;
					cmp_check_out <= cmp_check;
					bOp_out <= bOp;
					BD_out <= BD;
					IF_EXCCode_out <= IF_EXCCode;
					ID_EXCCode_out <= ID_EXCCode;
					EX_EXCCode_out <= EX_EXCCode;
					CP0_write_out <= CP0_write;
					is_eret_out <= is_eret;
				end
			end
	 end


endmodule
