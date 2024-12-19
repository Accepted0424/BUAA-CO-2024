`timescale 1ns / 1ps

module Controller(
    input [5:0] OpCode,
    input [5:0] Funct,
	 input [4:0] rt,
    output reg jump,
    output reg [1:0] jumpSrc,
    output reg [5:0] bOp,
    output reg [1:0] RegDst,
    output reg ALUSrc,
    output reg [1:0] Mem2Reg,
    output reg RegWrite,
    output reg MemWrite,
    output reg branch,
    output reg [1:0] ExtOp,
    output reg [3:0] ALUOP,
    output reg [2:0] store_type,
	 output reg [2:0] load_type,
	 output reg [3:0] mdOp
    );
	 
	 always @(*) begin
		RegDst 		= 2'b00;
		ALUSrc 		= 1'b0;
		Mem2Reg 		= 2'b00;
		RegWrite		= 1'b0;
		MemWrite 	= 1'b0;
		branch 		= 1'b0;
		ExtOp 		= 2'b00;
		ALUOP 		= 4'b0000;
		jumpSrc 		= 2'b00;
		jump  		= 1'b0;
		bOp 			= 6'b000000;
		store_type	= 3'b000;
		load_type 	= 3'b000;
		mdOp			= 4'b0000;
		
		if (OpCode == 6'b000000) begin
			if (Funct == 6'b100000) begin
				//add
				RegDst 		= 2'b01;
				ALUSrc 		= 1'b0;
				Mem2Reg 		= 2'b00;
				RegWrite		= 1'b1;
				ALUOP 		= 4'b0000;
			end

			else if (Funct == 6'b100010) begin
				//sub
				RegDst 		= 2'b01;
				ALUSrc 		= 1'b0;
				Mem2Reg 		= 2'b00;
				RegWrite 	= 1'b1;
				ALUOP 		= 4'b0001;
			end
			
			else if (Funct == 6'b100100) begin
				//and
				RegDst 		= 2'b01;
				ALUSrc 		= 1'b0;
				Mem2Reg 		= 2'b00;
				RegWrite 	= 1'b1;
				ALUOP 		= 4'b0100;
			end

			else if (Funct == 6'b100101) begin
				//or
				RegDst 		= 2'b01;
				ALUSrc 		= 1'b0;
				Mem2Reg 		= 2'b00;
				RegWrite 	= 1'b1;
				ALUOP 		= 4'b0010;
			end
			
			else if (Funct == 6'b101010) begin
				//slt
				RegDst 		= 2'b01;
				ALUSrc 		= 1'b0;
				Mem2Reg 		= 2'b00;
				RegWrite 	= 1'b1;
				ALUOP 		= 4'b0101;
			end
			
			else if (Funct == 6'b101011) begin
				//sltu
				RegDst 		= 2'b01;
				ALUSrc 		= 1'b0;
				Mem2Reg 		= 2'b00;
				RegWrite 	= 1'b1;
				ALUOP 		= 4'b0110;
			end
			
			else if (Funct == 6'b010000) begin
				//mfhi
				mdOp			= 4'b0111;
				RegDst 		= 2'b01;
				RegWrite 	= 1'b1;
				Mem2Reg		= 2'b00;
			end
			
			else if (Funct == 6'b010010) begin
				//mflo
				mdOp	= 4'b1000;
				RegDst 		= 2'b01;
				RegWrite 	= 1'b1;
				Mem2Reg		= 2'b00;
			end
			
			else if (Funct == 6'b010001) begin
				//mthi
				mdOp	= 4'b0101;
			end
			
			else if (Funct == 6'b010011) begin
				//mtlo
				mdOp	= 4'b0110;
			end
			
			else if (Funct == 6'b011000) begin
				//mult
				mdOp	=  4'b0001;
			end
			
			else if (Funct == 6'b011001) begin
				//multu
				mdOp	= 4'b0010;
			end
			
			else if (Funct == 6'b011010) begin
				//div
				mdOp	= 4'b0011;
			end
			
			else if (Funct == 6'b011011) begin
				//divu
				mdOp	= 4'b0100;
			end
			
			else if (Funct == 6'b001000) begin
				//jr
				jumpSrc 		= 2'b10;
				jump    		= 1'b1;
			end
		end
		
		else if (OpCode == 6'b001101) begin
			//ori
				RegDst 		= 2'b10;
				ALUSrc 		= 1'b1;
				Mem2Reg 		= 2'b00;
				RegWrite 	= 1'b1;
				ExtOp 		= 2'b01;
				ALUOP			= 4'b0010;
		end
		
		else if (OpCode == 6'b001000) begin
			//addi
				RegDst 		= 2'b10;
				ALUSrc 		= 1'b1;
				Mem2Reg 		= 2'b00;
				RegWrite 	= 1'b1;
				ExtOp 		= 2'b10;
				ALUOP			= 4'b0111;
		end
		
		else if (OpCode == 6'b001100) begin
			//andi
				RegDst 		= 2'b10;
				ALUSrc 		= 1'b1;
				Mem2Reg 		= 2'b00;
				RegWrite 	= 1'b1;
				ExtOp 		= 2'b01;
				ALUOP			= 4'b0100;
		end
		
		else if (OpCode == 6'b100011) begin
				//lw
				RegDst 		= 2'b10;
				ALUSrc 		= 1'b1;
				Mem2Reg 		= 2'b01;
				RegWrite 	= 1'b1;
				ExtOp 		= 2'b10;
				ALUOP 		= 4'b0000;
				load_type	= 3'b000;
		end
		
		else if (OpCode == 6'b101011) begin
				//sw
				ALUSrc 		= 1'b1;
				MemWrite 	= 1'b1;
				ExtOp 		= 2'b10;
				ALUOP 		= 4'b0000;
				store_type		= 3'b001;
		end

		else if (OpCode == 6'b100000) begin
				//lb	
				RegDst 		= 2'b10;
				ALUSrc 		= 1'b1;
				Mem2Reg 		= 2'b01;
				RegWrite 	= 1'b1;
				ExtOp 		= 2'b10;
				ALUOP 		= 4'b0000;
				load_type	= 3'b010;
		end

		else if (OpCode == 6'b100100) begin
				//lbu
				RegDst 		= 2'b10;
				ALUSrc 		= 1'b1;
				Mem2Reg 		= 2'b01;
				RegWrite 	= 1'b1;
				ExtOp 		= 2'b10;
				ALUOP 		= 4'b0000;
				load_type	= 3'b001;
		end

		else if (OpCode == 6'b100001) begin
				//lh
				RegDst 		= 2'b10;
				ALUSrc 		= 1'b1;
				Mem2Reg 		= 2'b01;
				RegWrite 	= 1'b1;
				ExtOp 		= 2'b10;
				ALUOP 		= 4'b0000;
				load_type	= 3'b100;
		end

		else if (OpCode == 6'b101000) begin
				//sb
				ALUSrc 		= 1'b1;
				MemWrite 	= 1'b1;
				ExtOp 		= 2'b10;
				ALUOP 		= 4'b0000;
				store_type		= 3'b010;
		end

		else if (OpCode == 6'b101001) begin
				//sh
				ALUSrc 		= 1'b1;
				MemWrite 	= 1'b1;
				ExtOp 		= 2'b10;
				ALUOP 		= 4'b0000;
				store_type 		= 3'b100;
		end
		
		else if (OpCode == 6'b000100) begin
				//beq
				branch 		= 1'b1;
				ExtOp 		= 2'b10;
				bOp			= 6'b100000;
		end
		
		else if (OpCode == 6'b001111) begin
			//lui
				RegDst 		= 2'b10;
				ALUSrc 		= 1'b1;
				Mem2Reg 		= 2'b00;
				RegWrite 	= 1'b1;
				ExtOp 		= 2'b10;
				ALUOP 		= 4'b0011;
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
				bOp 			= 6'b000010;
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
				jumpSrc 		= 2'b01;
				jump  		= 1'b1;
		end
		
		else if (OpCode == 6'b000011) begin
				//jal
				RegDst 		= 2'b11;
				Mem2Reg 		= 2'b10;
				RegWrite 	= 1'b1;
				jumpSrc 		= 2'b01;
				jump  		= 1'b1;
		end
		
		else begin
			//nop
			RegDst 			= 2'b00;
			ALUSrc 			= 1'b0;
			Mem2Reg 			= 2'b10;
			RegWrite 		= 1'b0;
			MemWrite 		= 1'b0;
			branch 			= 1'b0;
			ExtOp 			= 2'b00;
			ALUOP 			= 4'b0000;
			jumpSrc 			= 2'b00;
			jump  			= 1'b0;
			bOp 				= 6'b000000;
			store_type		= 3'b000;
		end
	 end	

endmodule
