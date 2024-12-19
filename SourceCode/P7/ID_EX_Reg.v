`timescale 1ns / 1ps

module ID_EX_Reg(
		input clk,
		input stall,
		input req,
		input reset,
		input en,
		input [31:0] Instr,
		input [1:0] RegDst,
		input ALUSrc,
		input [1:0] Mem2Reg,
		input RegWrite,
		input MemWrite,
		input [3:0] ALUOP,
		input [2:0] store_type,
		input [2:0] load_type,
		input [3:0] mdOp,
		
		input [31:0] RD1,
      input [31:0] RD2,
      input [31:0] ext32,
      input [4:0] RS,
      input [4:0] RT,
      input [4:0] RD,
      input [25:0] Index,
      input [31:0] pc_add4,
		input cmp_check,
		input [5:0] bOp,
		input BD,
		input [3:0] IF_EXCCode,
		input [3:0] ID_EXCCode,
		input CP0_write,
		input is_eret,
		
		output reg [31:0] Instr_out,
		output reg [1:0] RegDst_out,
		output reg ALUSrc_out,
		output reg [1:0] Mem2Reg_out,
		output reg RegWrite_out,
		output reg MemWrite_out,
		output reg [3:0] ALUOP_out,
		output reg [2:0] store_type_out,
		output reg [2:0] load_type_out,
		output reg [3:0] mdOp_out,
		
		output reg [31:0] RD1_out,
      output reg [31:0] RD2_out,
      output reg [31:0] ext32_out,
      output reg [4:0] RS_out,
      output reg [4:0] RT_out,
      output reg [4:0] RD_out,
      output reg [25:0] Index_out,
      output reg [31:0] pc_add4_out,
		output reg cmp_check_out,
		output reg [5:0] bOp_out,
		output reg BD_out,
		output reg [3:0] IF_EXCCode_out,
		output reg [3:0] ID_EXCCode_out,
		output reg CP0_write_out,
		output reg is_eret_out
    );
	 
	 initial begin
		//ctrl signal
			Instr_out <= 0;
			RegDst_out <= 0;
			ALUSrc_out <= 0;
			Mem2Reg_out <= 0;
			RegWrite_out <= 0;
			MemWrite_out <= 0;
			ALUOP_out <= 0;
			store_type_out <= 0;
			load_type_out <= 0;
			mdOp_out <= 0;
			//data
			RD1_out <= 0;
			RD2_out <= 0;
			ext32_out <= 0;
			RS_out <= 0;
			RT_out <= 0;
			RD_out <= 0;
			Index_out <= 0;
			pc_add4_out <= 0;
			cmp_check_out <= 0;
			bOp_out <= 0;
			BD_out <= 0;
			IF_EXCCode_out <= 0;
			ID_EXCCode_out <= 0;
			CP0_write_out <= 0;
			is_eret_out <= 0;
	 end
	 
	 always @(posedge clk) begin
		if (reset || stall || req) begin
			//ctrl signal
			Instr_out <= 0;
			RegDst_out <= 0;
			ALUSrc_out <= 0;
			Mem2Reg_out <= 0;
			RegWrite_out <= 0;
			MemWrite_out <= 0;
			ALUOP_out <= 0;
			store_type_out <= 0;
			load_type_out <= 0;
			mdOp_out <= 0;
			//data
			RD1_out <= 0;
			RD2_out <= 0;
			ext32_out <= 0;
			RS_out <= 0;
			RT_out <= 0;
			RD_out <= 0;
			Index_out <= 0;
			pc_add4_out <= (reset)? 32'h00003004:
								(req)? 32'h00004184: 
								(stall)? pc_add4:
								0;
			cmp_check_out <= 0;
			bOp_out <= 0;
			BD_out <= (stall)? BD: 0;
			IF_EXCCode_out <= 0;
			ID_EXCCode_out <= 0;
			CP0_write_out <= 0;
			is_eret_out <= 0;
		end
		else begin
			if (en) begin
			//ctrl signal
			Instr_out <= Instr;
			RegDst_out <= RegDst;
			ALUSrc_out <= ALUSrc;
			Mem2Reg_out <= Mem2Reg;
			RegWrite_out <= RegWrite;
			MemWrite_out <= MemWrite;
			ALUOP_out <= ALUOP;
			store_type_out <= store_type;
			load_type_out <= load_type; 
			mdOp_out <= mdOp;
			//data
			RD1_out <= RD1;
			RD2_out <= RD2;
			ext32_out <= ext32;
			RS_out <= RS;
			RT_out <= RT;
			RD_out <= RD;
			Index_out <= Index;
			pc_add4_out <= pc_add4;
			cmp_check_out <= cmp_check;
			bOp_out <= bOp; 
			BD_out <= BD;
			IF_EXCCode_out <= IF_EXCCode;
			ID_EXCCode_out <= ID_EXCCode;
			CP0_write_out <= CP0_write;
			is_eret_out <= is_eret;
			end
		end
	 end


endmodule
