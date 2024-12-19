`timescale 1ns / 1ps

module mips(
    input clk,
    input reset
  );

    //IFU wire
    wire [31:0] pc_IF;
    wire [31:0] pc_add4_IF;
    wire [31:0] pc_add4_ID;
    wire [31:0] pc_add4_EX;
    wire [31:0] pc_add4_MA;
    wire [31:0] pc_add4_WB;
    wire [31:0] Instr_IF;

    //Instr wire
    wire [5:0] OPCODE;
    wire [5:0] FUNCT;
    wire [4:0] RS_ID;
    wire [4:0] RS_EX;
    wire [4:0] RT_ID;
    wire [4:0] RT_EX;
	 wire [4:0] RT_MA;
    wire [4:0] RD_ID;
    wire [4:0] RD_EX;
    wire [4:0] SHAMT_ID;
    wire [15:0] IMM_ID;
    wire [25:0] Index_ID;

    //Controller wire
    wire [5:0] bOp_ID;
    wire [1:0] RegDst_ID;
    wire ALUSrc_ID;
    wire [1:0] Mem2Reg_ID;
    wire RegWrite_ID;
    wire MemWrite_ID;
    wire branch_ID;
    wire [1:0] ExtOp_ID;
    wire [3:0] ALUOP_ID;
    wire [1:0] jumpSrc_ID;
    wire [1:0] ls_type_ID;
    wire jump_ID;
	 wire [31:0] Instr_ID;
		
	 wire [5:0] bOp_EX;
    wire [1:0] RegDst_EX;
    wire ALUSrc_EX;
    wire [1:0] Mem2Reg_EX;
    wire RegWrite_EX;
    wire MemWrite_EX;
    wire [3:0] ALUOP_EX;
    wire [1:0] ls_type_EX;
	 wire [25:0] Index_EX;
	 wire [31:0] Instr_EX;
	
	 wire [5:0] bOp_MA;
    wire [1:0] Mem2Reg_MA;
    wire RegWrite_MA;
    wire MemWrite_MA;
    wire [1:0] ls_type_MA;
	 wire [31:0] Instr_MA;
	 
	 wire [5:0] bOp_WB;
	 wire [1:0] Mem2Reg_WB;
    wire RegWrite_WB;

    //DM wire 
    wire [31:0] dm_data_MA;
    wire [31:0] dm_data_WB;

    //EXT wire
    wire [31:0] ext32_ID;
    wire [31:0] ext32_EX;

    //ALU wire
	 wire [31:0] ALU_A_EX;
	 wire [31:0] ALU_B_EX;
	 wire [31:0] ALU_B_MA;
    wire [31:0] ALU_C_EX;
    wire [31:0] ALU_C_MA;
    wire [31:0] ALU_C_WB;

    //GRF wire
    wire [31:0] RD1_ID;
    wire [31:0] RD2_ID;
    wire [31:0] RD1_EX;
    wire [31:0] RD2_EX;
    wire [31:0] RD2_MA;
    wire [31:0] grf_WD;
    wire [4:0] A3_EX;
    wire [4:0] A3_MA;
    wire [4:0] A3_WB;

    //jumpEXT wire
    wire [31:0] jumpExt32_ID;
    wire [31:0] branch_offset_EX;
    wire [31:0] next_pc;
	 wire [31:0] next_pc_ID;
    wire [31:0] next_pc_EX;
    wire [31:0] next_pc_MA;   
	 
	 //Hazard wire
	 wire Stall;
	 wire nStall = ~Stall;
	 wire true = 1;
	 wire false = 0;
	 
	 //bCheck wire
	 wire if_branch_ID;
	 wire if_branch_EX;
	 wire if_branch_MA;
	 wire if_branch_WB;

    PC pc(
        .clk(clk),
        .reset(reset),
        .en(nStall),
        .next_pc(next_pc),
        .current_pc(pc_IF)
    );

    assign pc_add4_IF = pc_IF + 32'd4;
    assign next_pc = (if_branch_ID == 1'b1 || jump_ID == 1'b1)? next_pc_ID: pc_add4_IF;

    IM im(
        .A(pc_IF),
        .Instr(Instr_IF)
    );
	 
	 IF_ID_Reg IF_ID_Regs(
		  .clk(clk),
		  .en(nStall),
		  .reset(reset),
        .clr(false),
		  .Instr(Instr_IF),
		  .Instr_out(Instr_ID),
		  .pc_add4(pc_add4_IF),
		  .pc_add4_out(pc_add4_ID)
	 );

    assign OPCODE = Instr_ID[31:26];
    assign FUNCT = Instr_ID[5:0];
    assign RS_ID = Instr_ID[25:21];
    assign RT_ID = Instr_ID[20:16];
    assign RD_ID = Instr_ID[15:11]; 
    assign SHAMT_ID = Instr_ID[10:6];
    assign IMM_ID = Instr_ID[15:0];
    assign Index_ID = Instr_ID[25:0];

    EXT ext(
        .imm16(IMM_ID),
        .ExtOp(ExtOp_ID),
        .ext32(ext32_ID)
      );

    Controller controller(
        .OpCode(OPCODE),
        .Funct(FUNCT),
        .rt(RT_ID),
        .jump(jump_ID),
        .jumpSrc(jumpSrc_ID),
        .bOp(bOp_ID),
        .RegDst(RegDst_ID),
        .ALUSrc(ALUSrc_ID),
        .Mem2Reg(Mem2Reg_ID),
        .RegWrite(RegWrite_ID),
        .MemWrite(MemWrite_ID),
        .branch(branch_ID),
        .ExtOp(ExtOp_ID),
        .ALUOP(ALUOP_ID),
        .ls_type(ls_type_ID)
    );

    GRF grf(
        .clk(clk),
        .reset(reset),
        .WE(RegWrite_WB),
        .A1(RS_ID),
        .A2(RT_ID),
        .A3(A3_WB),
        .WD(grf_WD),
        .pc(pc_add4_WB),
        .RD1(RD1_ID),
        .RD2(RD2_ID)
      );
											
		wire [31:0] RD1_ID_valid = ((RS_ID == A3_MA) && (A3_MA != 5'b0))? forward_EX_MA:
											((RS_ID == A3_WB) && (A3_WB != 5'b0))? forward_MA_WB:
											RD1_ID;
											
		wire [31:0] RD2_ID_valid = ((RT_ID == A3_MA) && (A3_MA != 5'b0))? forward_EX_MA:
											((RT_ID == A3_WB) && (A3_WB != 5'b0))? forward_MA_WB:
											RD2_ID;
											
		bCheck bcheck(
           .Grs(RD1_ID_valid),
           .Grt(RD2_ID_valid),
           .bOp(bOp_ID),
           .branch(branch_ID),
           .check(if_branch_ID)
         );
			
		jumpEXT jumpext(
            .index(Index_ID),
            .pc(pc_add4_ID),
            .ext32(jumpExt32_ID)
        );
		  
		wire [31:0] branch_offset_ID = (ext32_ID << 2) + pc_add4_ID;
		assign next_pc_ID = (jumpSrc_ID == 2'b00) ? branch_offset_ID:
                          (jumpSrc_ID == 2'b01) ? jumpExt32_ID:
                          (jumpSrc_ID == 2'b10) ? RD1_ID_valid: 32'h404; 

    ID_EX_Reg ID_EX_Regs(
        .clk(clk),
		  .reset(reset),
		  .clr(Stall),
		  .en(true),
        .RegDst(RegDst_ID),
        .ALUSrc(ALUSrc_ID),
        .Mem2Reg(Mem2Reg_ID),
        .RegWrite(RegWrite_ID),
        .MemWrite(MemWrite_ID),
        .ALUOP(ALUOP_ID),
        .ls_type(ls_type_ID),
		  .Instr(Instr_ID),
        .RD1(RD1_ID),
        .RD2(RD2_ID),
        .ext32(ext32_ID),
        .RS(RS_ID),
        .RT(RT_ID),
        .RD(RD_ID),
        .Index(Index_ID),
        .pc_add4(pc_add4_ID),
		  .cmp_check(if_branch_ID),
		  .bOp(bOp_ID),
        //------------------------
        .RegDst_out(RegDst_EX),
        .ALUSrc_out(ALUSrc_EX),
        .Mem2Reg_out(Mem2Reg_EX),
        .RegWrite_out(RegWrite_EX),
        .MemWrite_out(MemWrite_EX),
        .ALUOP_out(ALUOP_EX),
        .ls_type_out(ls_type_EX),
		  .Instr_out(Instr_EX),
        .RD1_out(RD1_EX),
        .RD2_out(RD2_EX),
        .ext32_out(ext32_EX),
        .RS_out(RS_EX),
        .RT_out(RT_EX),
        .RD_out(RD_EX),
        .Index_out(Index_EX),
        .pc_add4_out(pc_add4_EX),
		  .cmp_check_out(if_branch_EX),
		  .bOp_out(bOp_EX)
    );
	
	 //forward--select valid ALU_A and ALU_B
	 wire [31:0] ALU_A_EX_valid = ((RS_EX == A3_MA) && (A3_MA != 5'b0))? forward_EX_MA:
											((RS_EX == A3_WB) && (A3_WB != 5'b0))? forward_MA_WB:
											RD1_EX;
											
	wire [31:0] Grt_EX_valid = ((RT_EX == A3_MA) && (A3_MA != 5'b0))? forward_EX_MA:
										((RT_EX == A3_WB) && (A3_WB != 5'b0))? forward_MA_WB:
										RD2_EX;
											
	 wire [31:0] Grt_MA_valid;
								
    wire [31:0] ALU_B_EX_valid = (ALUSrc_EX == 1'b0) ? Grt_EX_valid:
											(ALUSrc_EX == 1'b1) ? ext32_EX : 32'b0;
						  
    ALU alu(
        .A(ALU_A_EX_valid),
        .B(ALU_B_EX_valid),
        .F(ALUOP_EX),
        .C(ALU_C_EX)
      );
						  
	 assign A3_EX =  (RegDst_EX == 2'b00)? 5'b0: //null
                    (RegDst_EX == 2'b01)? RD_EX:
						  (RegDst_EX == 2'b10)? RT_EX:
                    (RegDst_EX == 2'b11)? 5'h1f:
						  5'b00000;

    EX_MA_Reg EX_MA_Regs(
        .clk(clk),
		  .reset(reset),
		  .clr(false),
		  .en(true),
		  .Mem2Reg(Mem2Reg_EX),
        .RegWrite(RegWrite_EX),
        .MemWrite(MemWrite_EX),
        .ls_type(ls_type_EX),
		  .Instr(Instr_EX),
        .ALU_C(ALU_C_EX),
        .Grt_EX_valid(Grt_EX_valid),
        .A3(A3_EX),
        .pc_add4(pc_add4_EX),
		  .RT(RT_EX),
		  .cmp_check(if_branch_EX),
		  .bOp(bOp_EX),
			
		  .Mem2Reg_out(Mem2Reg_MA),
        .RegWrite_out(RegWrite_MA),
        .MemWrite_out(MemWrite_MA),
        .ls_type_out(ls_type_MA),
		  .Instr_out(Instr_MA),
        .ALU_C_out(ALU_C_MA),
        .Grt_EX_valid_out(Grt_MA_valid),
        .A3_out(A3_MA),
        .pc_add4_out(pc_add4_MA),
		  .RT_out(RT_MA),
		  .cmp_check_out(if_branch_MA),
		  .bOp_out(bOp_MA)
    );
	 
	 wire [31:0] forward_EX_MA = (RegWrite_MA && (Mem2Reg_MA == 2'b00))? ALU_C_MA:  
										  (RegWrite_MA && (Mem2Reg_MA == 2'b10))? pc_add4_MA + 32'd4:
										  32'h404;
	 
	 wire [31:0] Grt_MA_valid_valid = ((RT_MA == A3_WB) && (A3_WB != 5'd0))? forward_MA_WB: Grt_MA_valid;

    DM dm(
       .A(ALU_C_MA),
       .D_input(Grt_MA_valid_valid),
       .str(MemWrite_MA),
       .type(ls_type_MA),
       .clk(clk),
       .clr(reset),
       .pc(pc_add4_MA),
       .D_output(dm_data_MA)
     );

    MA_WB_Reg MA_WB_Regs(
            .clk(clk),
				.en(true),
            .clr(false),
				.reset(reset),
				.Mem2Reg(Mem2Reg_MA),
            .RegWrite(RegWrite_MA),
            .dm_data(dm_data_MA),
            .A3(A3_MA),
            .ALU_C(ALU_C_MA),
            .pc_add4(pc_add4_MA),
				.cmp_check(if_branch_MA),
				.bOp(bOp_MA),
				
				.Mem2Reg_out(Mem2Reg_WB),
            .RegWrite_out(RegWrite_WB),
            .dm_data_out(dm_data_WB),
            .A3_out(A3_WB),
            .ALU_C_out(ALU_C_WB),
            .pc_add4_out(pc_add4_WB),
				.cmp_check_out(if_branch_WB),
				.bOp_out(bOp_WB)
        );
		
		assign grf_WD = (Mem2Reg_WB == 2'b00) ? ALU_C_WB :
							 (Mem2Reg_WB == 2'b01) ? dm_data_WB :
							 (Mem2Reg_WB == 2'b10) ? pc_add4_WB + 32'd4 : 32'd0;
							 
		wire [31:0] forward_MA_WB = RegWrite_WB? grf_WD: 32'h405;
	
		Hazard hazard(
				.A3_EX(A3_EX),
				.A3_MA(A3_MA),
				.Instr_ID(Instr_ID),
				.Instr_EX(Instr_EX),
				.Instr_MA(Instr_MA),
				.Stall(Stall)
		);
		
endmodule