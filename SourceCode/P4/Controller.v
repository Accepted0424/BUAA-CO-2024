`timescale 1ns / 1ps
`include "constant.v"

module Controller(
    input [5:0] OpCode,
    input [5:0] Funct,
	 input [4:0] rt,
    
    output reg [5:0] bOp,
    output reg [1:0] RegDst,
    output reg ALUSrc,
    output reg [1:0] Mem2Reg,
    output reg RegWrite,
    output reg MemWrite,
    output reg branch,
	 output reg jump,
	 output reg jr,
    output reg [1:0] ExtOp,
    output reg [3:0] ALUOP,
    output reg [1:0] ls_type
    );
	 
	 always @(*) begin
		RegDst 		= 2'b00;
		ALUSrc 		= 1'b0;
		Mem2Reg 		= 2'b00;
		RegWrite 	= 1'b0;
		MemWrite 	= 1'b0;
		branch 		= 1'b0;
		bOp			= 6'b000000;
		jump 			= 1'b0;
		jr				= 1'b0;
		ExtOp 		= 2'b00;
		ALUOP 		= `ADD;
		
		if (OpCode == 6'b000000) begin
			if (Funct == 6'b100000) begin
				//add
				RegDst 		= 2'b01;
				ALUSrc		= 1'b0;
				Mem2Reg		= 2'b00;
				RegWrite		= 1'b1;
				ALUOP 		= `ADD;
			end

			else if (Funct == 6'b100010) begin
				//sub
				RegDst 		= 2'b01;
				ALUSrc		= 1'b0;
				Mem2Reg		= 2'b00;
				RegWrite 	= 1'b1;
				ALUOP 		= `SUB;	
			end

			else if (Funct == 6'b100101) begin
				//or
				RegDst 		= 2'b01;
				ALUSrc		= 1'b0;
				Mem2Reg		= 2'b00;
				RegWrite 	= 1'b1;
				ALUOP 		= `OR;
			end

			else if (Funct == 6'b0000000) begin
				//SLL
				RegDst 		= 2'b01;
				ALUSrc 		= 1'b0;
				Mem2Reg 		= 2'b00;
				RegWrite 	= 1'b1;
				ALUOP 		= `SLL;
			end

			else if (Funct == 6'b000010) begin
				//SRL
				RegDst 		= 2'b01;
				ALUSrc 		= 1'b0;
				Mem2Reg 		= 2'b00;
				RegWrite 	= 1'b1;
				ALUOP 		= `SRL;
			end

			else if (Funct == 6'b000011) begin
				//SRA
				RegDst 		= 2'b01;
				ALUSrc 		= 1'b0;
				Mem2Reg 		= 2'b00;
				RegWrite 	= 1'b1;
				ALUOP 		= `SRA;
			end
			
			else if (Funct == 6'b001000) begin
				//jr
				jr       	= 1'b1;
			end
		end
		
		else if (OpCode == 6'b001101) begin
				//ori
				RegDst 		= 2'b00;
				ALUSrc 		= 1'b1;
				RegWrite 	= 1'b1;
				Mem2Reg 		= 2'b00;
				ExtOp 		= 2'b01;
				ALUOP			= `OR;
		end
		
		else if (OpCode == 6'b100011) begin
				//lw
				RegDst 		= 2'b00;
				ALUSrc 		= 1'b1;
				Mem2Reg 		= 2'b01;
				RegWrite 	= 1'b1;
				ExtOp 		= 2'b10;
				ALUOP 		= `ADD;
				ls_type		= 2'b00;
		end
		
		else if (OpCode == 6'b101011) begin
				//sw
				ALUSrc 		= 1'b1;
				Mem2Reg 		= 2'b00;
				MemWrite 	= 1'b1;
				ExtOp 		= 2'b10;
				ALUOP 		= `ADD;
				ls_type		= 2'b00;
		end

		else if (OpCode == 6'b100000) begin
				//lb	
				RegDst 		= 2'b00;
				ALUSrc 		= 1'b1;
				Mem2Reg 		= 2'b01;
				RegWrite 	= 1'b1;
				ExtOp 		= 2'b10;
				ALUOP 		= `ADD;
				ls_type 		= 2'b01;
		end

		else if (OpCode == 6'b100100) begin
				//lbu
				RegDst 		= 2'b00;
				ALUSrc 		= 1'b1;
				Mem2Reg 		= 2'b01;
				RegWrite 	= 1'b1;
				ExtOp 		= 2'b10;
				ALUOP 		= `ADD;
				ls_type  	= 2'b10;
		end

		else if (OpCode == 6'b100001) begin
				//lh
				RegDst 		= 2'b00;
				ALUSrc 		= 1'b1;
				Mem2Reg 		= 2'b01;
				RegWrite 	= 1'b1;
				ExtOp 		= 2'b10;
				ALUOP 		= `ADD;
				ls_type		= 2'b11;
		end

		else if (OpCode == 6'b101000) begin
				//sb
				RegDst 		= 2'b00;
				ALUSrc 		= 1'b1;
				MemWrite 	= 1'b1;
				ExtOp 		= 2'b10;
				ALUOP 		= `ADD;
				ls_type		= 2'b01;
		end

		else if (OpCode == 6'b101001) begin
				//sh
				RegDst 		= 2'b00;
				ALUSrc 		= 1'b1;
				MemWrite 	= 1'b1;
				ExtOp 		= 2'b10;
				ALUOP 		= `ADD;
				ls_type 		= 2'b11;
		end
		
		else if (OpCode == 6'b000100) begin
				//beq
				branch 		= 1'b1;
				ExtOp 		= 2'b10;
				bOp			= 6'b100000;
		end
		
		else if (OpCode == 6'b001111) begin
				//lui
				RegDst 		= 2'b00;
				ALUSrc 		= 1'b1;
				Mem2Reg 		= 2'b00;
				RegWrite 	= 1'b1;
				ExtOp 		= 2'b10;
				ALUOP 		= `SL16;
		end
		
		else if (OpCode == 6'b000001) begin
			if (rt == 5'b00001) begin
				//bgez
				branch 		= 1'b1;
				ExtOp 		= 2'b10;
				bOp			= 6'b010000;
			end
			
			else if (rt == 5'b00000) begin
				//bltz
				branch 		= 1'b1;
				ExtOp 		= 2'b10;
				bOp 		= 6'b000010;
			end
		end
		
		else if (OpCode == 6'b000111) begin
				//bgtz
				branch 		= 1'b1;
				ExtOp 		= 2'b10;
				bOp 		= 6'b001000;
		end
		
		else if (OpCode == 6'b000110) begin
				//blez
				branch 		= 1'b1;
				ExtOp 		= 2'b10;
				bOp 		= 6'b000100;
		end
		
		else if (OpCode == 6'b000101) begin
				//bne
				branch 		= 1'b1;
				ExtOp 		= 2'b10;
				bOp			= 6'b000001;
		end
		
		else if (OpCode == 6'b000010) begin
				//jump
				jump  		= 1'b1;
		end
		
		else if (OpCode == 6'b000011) begin
				//jal
				RegDst 		= 2'b11;
				Mem2Reg 		= 2'b10;
				RegWrite 	= 1'b1;
				jump  		= 1'b1;
		end
		
		else begin
			//nop
			RegDst 			= 2'b00;
			ALUSrc 			= 1'b0;
			Mem2Reg 			= 2'b00;
			RegWrite 		= 1'b0;
			MemWrite 		= 1'b0;
			branch 			= 1'b0;
			ExtOp 			= 2'b00;
			ALUOP 			= `ADD;
			jump  			= 1'b0;
		end
	 end	

endmodule
