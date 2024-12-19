`timescale 1ns / 1ps

module mips(
    input clk,
    input reset
  );
	
  wire [31:0] pc;
  wire [31:0] instr_out;

  IFU ifu(
        .clk(clk),
        .reset(reset),
		  .next_pc(next_pc),
		  .PC(pc),
        .Instr(instr_out)
      );
		
  wire [5:0] OPCODE = instr_out[31:26];
  wire [5:0] FUNCT = instr_out[5:0];
  wire [4:0] RS = instr_out[25:21];
  wire [4:0] RT = instr_out[20:16];
  wire [4:0] RD = instr_out[15:11];
  wire [4:0] SHAMT = instr_out[10:6];
  wire [15:0] IMM = instr_out[15:0];
  wire [25:0] INDEX = instr_out[25:0];
  
  wire [5:0] bOp_out;
  wire [1:0] RegDst_out;
  wire ALUSrc_out;
  wire [1:0] Mem2Reg_out;
  wire RegWrite_out;
  wire MemWrite_out;
  wire [1:0] ExtOp_out;
  wire [3:0] ALUOP_out;
  wire [1:0] jumpSrc_out;
  wire [1:0] ls_type_out;
  wire is_jump;
  wire is_branch;
  wire is_jr;

  Controller controller(
               .OpCode(OPCODE),
               .Funct(FUNCT),
               .rt(RT),
               .bOp(bOp_out),
               .RegDst(RegDst_out),
               .ALUSrc(ALUSrc_out),
               .Mem2Reg(Mem2Reg_out),
               .RegWrite(RegWrite_out),
               .MemWrite(MemWrite_out),
               .branch(is_branch),
					.jump(is_jump),
					.jr(is_jr),
               .ExtOp(ExtOp_out),
               .ALUOP(ALUOP_out),
               .ls_type(ls_type_out)
             );
	
  wire [4:0] grf_WA = (RegDst_out == 2'b00) ? RT:
							 (RegDst_out == 2'b01) ? RD:
						    (RegDst_out == 2'b11) ? 5'h1f:
							 5'b00000;
							 
  wire [31:0] grf_WD = (Mem2Reg_out == 2'b00) ? alu_C:
							 (Mem2Reg_out == 2'b01) ? dm_data:
							 (Mem2Reg_out == 2'b10) ? pc + 32'd4:
							 32'd0;
  wire [31:0] grf_RD1;
  wire [31:0] grf_RD2;
  
  GRF grf(
        .clk(clk),
        .reset(reset),
        .WE(RegWrite_out),
        .A1(RS),
        .A2(RT),
        .A3(grf_WA),
        .WD(grf_WD),
        .pc(pc),
        .RD1(grf_RD1),
        .RD2(grf_RD2)
      );
		
	bCheck bcheck(
        .Grs(grf_RD1),
		  .Grt(grf_RD2),
        .bOp(bOp_out),
        .branch(is_branch),
        .check(cmp_check)
         );
			
  wire [31:0] jumpext_ext32 = ({6'b0,INDEX} << 2) | ({pc[31:28],28'b0});	
  wire cmp_check;
  wire [31:0] next_pc = (is_branch && cmp_check)? (ext_ext32<<2) + (pc+4):
								(is_jump)? jumpext_ext32:
								(is_jr)? grf_RD1:
								pc+4;
	
  wire [31:0] alu_shamt = SHAMT;
  wire [31:0] alu_B = (ALUSrc_out == 1'b0) ? grf_RD2 :
							 (ALUSrc_out == 1'b1) ? ext_ext32:
							 32'b0;
  wire [31:0] alu_C;
  
  ALU alu(
        .A(grf_RD1),
        .B(alu_B),
        .shamt(alu_shamt),
        .F(ALUOP_out),
        .C(alu_C)
      );
	
  wire [31:0] dm_data;
  DM dm(
       .A(alu_C),
       .D_input(grf_RD2),
       .str(MemWrite_out),
       .type(ls_type_out),
       .clk(clk),
       .Grt(grf_RD2),
       .clr(reset),
       .pc(pc),
       .D_output(dm_data)
     );

  wire [31:0] ext_ext32;
  EXT ext(
        .imm16(IMM),
        .ExtOp(ExtOp_out),
        .ext32(ext_ext32)
      );

endmodule
