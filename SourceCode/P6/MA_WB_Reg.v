`timescale 1ns / 1ps

module MA_WB_Reg(
		input clk,
		input clr,
		input reset,
		input en,
		input [1:0] Mem2Reg,
      input RegWrite,
		input [3:0] mdOp,
      input [31:0] dm_data,
      input [4:0] A3,
      input [31:0] ALU_C,
      input [31:0] pc_add4,
		input cmp_check,
		input [5:0] bOp,
		
		output reg [1:0] Mem2Reg_out,
      output reg RegWrite_out,
		output reg [3:0] mdOp_out,
      output reg [31:0] dm_data_out,
      output reg [4:0] A3_out,
      output reg [31:0] ALU_C_out,
      output reg [31:0] pc_add4_out,
		output reg cmp_check_out,
		output reg [5:0] bOp_out
    );
	 
	 initial begin
			Mem2Reg_out <= 0;
			RegWrite_out <= 0;
			mdOp_out <= 0;
			dm_data_out <= 0;
			A3_out <= 0;
			ALU_C_out <= 0;
			pc_add4_out <= 0;
			cmp_check_out <= 0;
			bOp_out <= 0;
	 end
	 
	always @(posedge clk) begin
		if (clr || reset) begin
			Mem2Reg_out <= 0;
			RegWrite_out <= 0;
			mdOp_out <= 0;
			dm_data_out <= 0;
			A3_out <= 0;
			ALU_C_out <= 0;
			pc_add4_out <= 0;
			cmp_check_out <= 0;
			bOp_out <= 0;
		end else begin
			if (en) begin
				Mem2Reg_out <= Mem2Reg;
				RegWrite_out <= RegWrite;
				mdOp_out <= mdOp; 
				dm_data_out <= dm_data;
				A3_out <= A3;
				ALU_C_out <= ALU_C;
				pc_add4_out <= pc_add4;
				cmp_check_out <= cmp_check;
				bOp_out <= bOp;
			end
		end
end

endmodule
