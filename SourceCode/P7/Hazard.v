`timescale 1ns / 1ps

module Hazard(
		input [4:0] A3_EX,
		input [4:0] A3_MA,
		
		input busy,
		input start,
		
		input [31:0] Instr_ID,
		input [31:0] Instr_EX,
		input [31:0] Instr_MA,
		
		output Stall
    );
	 
	//-----------------------------------ID-decode---------------------------------------
	wire add_ID = ((Instr_ID[31:26] === 6'b000000) & (Instr_ID[5:0] === 6'b100000))?1:0;
	wire sub_ID = ((Instr_ID[31:26] === 6'b000000) & (Instr_ID[5:0] === 6'b100010))?1:0;
	wire ori_ID = (Instr_ID[31:26] === 6'b001101)?1:0;
	wire lw_ID = (Instr_ID[31:26] === 6'b100011)?1:0;
	wire sw_ID = (Instr_ID[31:26] === 6'b101011)?1:0;
	wire beq_ID = (Instr_ID[31:26] === 6'b000100)?1:0;
	wire lui_ID = (Instr_ID[31:26] === 6'b001111)?1:0;
	wire jal_ID = (Instr_ID[31:26] === 6'b000011)?1:0;
	wire jr_ID = ((Instr_ID[31:26] === 6'b000000) & (Instr_ID[5:0] === 6'b001000))?1:0;
	wire and_ID = ((Instr_ID[31:26] === 6'b000000) & (Instr_ID[5:0] === 6'b100100))?1:0;
	wire or_ID = ((Instr_ID[31:26] === 6'b000000) & (Instr_ID[5:0] === 6'b100101))?1:0;
	wire slt_ID = ((Instr_ID[31:26] === 6'b000000) & (Instr_ID[5:0] === 6'b101010))?1:0;
	wire sltu_ID = ((Instr_ID[31:26] === 6'b000000) & (Instr_ID[5:0] === 6'b101011))?1:0;
	wire addi_ID = (Instr_ID[31:26] === 6'b001000)?1:0;
	wire andi_ID = (Instr_ID[31:26] === 6'b001100)?1:0;
	wire lb_ID = (Instr_ID[31:26] === 6'b100000)?1:0;
	wire lh_ID = (Instr_ID[31:26] === 6'b100001)?1:0;
	wire sb_ID = (Instr_ID[31:26] === 6'b101000)?1:0;
	wire sh_ID = (Instr_ID[31:26] === 6'b101001)?1:0;
	wire mult_ID = ((Instr_ID[31:26] === 6'b000000) & (Instr_ID[5:0] === 6'b011000))?1:0;
	wire multu_ID = ((Instr_ID[31:26] === 6'b000000) & (Instr_ID[5:0] === 6'b011001))?1:0;
	wire div_ID = ((Instr_ID[31:26] === 6'b000000) & (Instr_ID[5:0] === 6'b011010))?1:0;
	wire divu_ID = ((Instr_ID[31:26] === 6'b000000) & (Instr_ID[5:0] === 6'b011011))?1:0;
	wire mfhi_ID = ((Instr_ID[31:26] === 6'b000000) & (Instr_ID[5:0] === 6'b010000))?1:0;
	wire mflo_ID = ((Instr_ID[31:26] === 6'b000000) & (Instr_ID[5:0] === 6'b010010))?1:0;
	wire mthi_ID = ((Instr_ID[31:26] === 6'b000000) & (Instr_ID[5:0] === 6'b010001))?1:0;
	wire mtlo_ID = ((Instr_ID[31:26] === 6'b000000) & (Instr_ID[5:0] === 6'b010011))?1:0;
	wire bne_ID = (Instr_ID[31:26] === 6'b000101)?1:0;
	wire eret_ID = ((Instr_ID[31:26] === 6'b010000) & (Instr_ID[5:0] === 6'b011000))?1:0;
	wire mtc0_ID = ((Instr_ID[31:26] === 6'b010000) & (Instr_ID[25:21] === 5'b00100))?1:0;
	wire mfc0_ID = ((Instr_ID[31:26] === 6'b010000) & (Instr_ID[25:21] === 5'b00000))?1:0;
	wire syscall_ID = ((Instr_ID[31:26] === 6'b000000) & (Instr_ID[5:0] === 6'b001100))?1:0;
	//-----------------------------------EX-decode---------------------------------------
	wire add_EX = ((Instr_EX[31:26] === 6'b000000) & (Instr_EX[5:0] === 6'b100000))?1:0;
	wire sub_EX = ((Instr_EX[31:26] === 6'b000000) & (Instr_EX[5:0] === 6'b100010))?1:0;
	wire ori_EX = (Instr_EX[31:26] === 6'b001101)?1:0;
	wire lw_EX = (Instr_EX[31:26] === 6'b100011)?1:0;
	wire sw_EX = (Instr_EX[31:26] === 6'b101011)?1:0;
	wire beq_EX = (Instr_EX[31:26] === 6'b000100)?1:0;
	wire lui_EX = (Instr_EX[31:26] === 6'b001111)?1:0;
	wire jal_EX = (Instr_EX[31:26] === 6'b000011)?1:0;
	wire jr_EX = ((Instr_EX[31:26] === 6'b000000) & (Instr_EX[5:0] === 6'b001000))?1:0;
	wire and_EX = ((Instr_EX[31:26] === 6'b000000) & (Instr_EX[5:0] === 6'b100100))?1:0;
	wire or_EX = ((Instr_EX[31:26] === 6'b000000) & (Instr_EX[5:0] === 6'b100101))?1:0;
	wire slt_EX = ((Instr_EX[31:26] === 6'b000000) & (Instr_EX[5:0] === 6'b101010))?1:0;
	wire sltu_EX = ((Instr_EX[31:26] === 6'b000000) & (Instr_EX[5:0] === 6'b101011))?1:0;
	wire addi_EX = (Instr_EX[31:26] === 6'b001000)?1:0;
	wire andi_EX = (Instr_EX[31:26] === 6'b001100)?1:0;
	wire lb_EX = (Instr_EX[31:26] === 6'b100000)?1:0;
	wire lh_EX = (Instr_EX[31:26] === 6'b100001)?1:0;
	wire sb_EX = (Instr_EX[31:26] === 6'b101000)?1:0;
	wire sh_EX = (Instr_EX[31:26] === 6'b101001)?1:0;
	wire mult_EX = ((Instr_EX[31:26] === 6'b000000) & (Instr_EX[5:0] === 6'b011000))?1:0;
	wire multu_EX = ((Instr_EX[31:26] === 6'b000000) & (Instr_EX[5:0] === 6'b011001))?1:0;
	wire div_EX = ((Instr_EX[31:26] === 6'b000000) & (Instr_EX[5:0] === 6'b011010))?1:0;
	wire divu_EX = ((Instr_EX[31:26] === 6'b000000) & (Instr_EX[5:0] === 6'b011011))?1:0;
	wire mfhi_EX = ((Instr_EX[31:26] === 6'b000000) & (Instr_EX[5:0] === 6'b010000))?1:0;
	wire mflo_EX = ((Instr_EX[31:26] === 6'b000000) & (Instr_EX[5:0] === 6'b010010))?1:0;
	wire mthi_EX = ((Instr_EX[31:26] === 6'b000000) & (Instr_EX[5:0] === 6'b010001))?1:0;
	wire mtlo_EX = ((Instr_EX[31:26] === 6'b000000) & (Instr_EX[5:0] === 6'b010011))?1:0;
	wire bne_EX = (Instr_EX[31:26] === 6'b000101)?1:0;
	wire eret_EX = ((Instr_EX[31:26] === 6'b010000) & (Instr_EX[5:0] === 6'b011000))?1:0;
	wire mtc0_EX = ((Instr_EX[31:26] === 6'b010000) & (Instr_EX[25:21] === 5'b00100))?1:0;
	wire mfc0_EX = ((Instr_EX[31:26] === 6'b010000) & (Instr_EX[25:21] === 5'b00000))?1:0;
	wire syscall_EX = ((Instr_EX[31:26] === 6'b000000) & (Instr_EX[5:0] === 6'b001100))?1:0;
	//-----------------------------------MA-decode---------------------------------------
	wire add_MA = ((Instr_MA[31:26] === 6'b000000) & (Instr_MA[5:0] === 6'b100000))?1:0;
	wire sub_MA = ((Instr_MA[31:26] === 6'b000000) & (Instr_MA[5:0] === 6'b100010))?1:0;
	wire ori_MA = (Instr_MA[31:26] === 6'b001101)?1:0;
	wire lw_MA = (Instr_MA[31:26] === 6'b100011)?1:0;
	wire sw_MA = (Instr_MA[31:26] === 6'b101011)?1:0;
	wire beq_MA = (Instr_MA[31:26] === 6'b000100)?1:0;
	wire lui_MA = (Instr_MA[31:26] === 6'b001111)?1:0;
	wire jal_MA = (Instr_MA[31:26] === 6'b000011)?1:0;
	wire jr_MA = ((Instr_MA[31:26] === 6'b000000) & (Instr_MA[5:0] === 6'b001000))?1:0;
	wire and_MA = ((Instr_MA[31:26] === 6'b000000) & (Instr_MA[5:0] === 6'b100100))?1:0;
	wire or_MA = ((Instr_MA[31:26] === 6'b000000) & (Instr_MA[5:0] === 6'b100101))?1:0;
	wire slt_MA = ((Instr_MA[31:26] === 6'b000000) & (Instr_MA[5:0] === 6'b101010))?1:0;
	wire sltu_MA = ((Instr_MA[31:26] === 6'b000000) & (Instr_MA[5:0] === 6'b101011))?1:0;
	wire addi_MA = (Instr_MA[31:26] === 6'b001000)?1:0;
	wire andi_MA = (Instr_MA[31:26] === 6'b001100)?1:0;
	wire lb_MA = (Instr_MA[31:26] === 6'b100000)?1:0;
	wire lh_MA = (Instr_MA[31:26] === 6'b100001)?1:0;
	wire sb_MA = (Instr_MA[31:26] === 6'b101000)?1:0;
	wire sh_MA = (Instr_MA[31:26] === 6'b101001)?1:0;
	wire mult_MA = ((Instr_MA[31:26] === 6'b000000) & (Instr_MA[5:0] === 6'b011000))?1:0;
	wire multu_MA = ((Instr_MA[31:26] === 6'b000000) & (Instr_MA[5:0] === 6'b011001))?1:0;
	wire div_MA = ((Instr_MA[31:26] === 6'b000000) & (Instr_MA[5:0] === 6'b011010))?1:0;
	wire divu_MA = ((Instr_MA[31:26] === 6'b000000) & (Instr_MA[5:0] === 6'b011011))?1:0;
	wire mfhi_MA = ((Instr_MA[31:26] === 6'b000000) & (Instr_MA[5:0] === 6'b010000))?1:0;
	wire mflo_MA = ((Instr_MA[31:26] === 6'b000000) & (Instr_MA[5:0] === 6'b010010))?1:0;
	wire mthi_MA = ((Instr_MA[31:26] === 6'b000000) & (Instr_MA[5:0] === 6'b010001))?1:0;
	wire mtlo_MA = ((Instr_MA[31:26] === 6'b000000) & (Instr_MA[5:0] === 6'b010011))?1:0;
	wire bne_MA = (Instr_MA[31:26] === 6'b000101)?1:0;
	wire eret_MA = ((Instr_MA[31:26] === 6'b010000) & (Instr_MA[5:0] === 6'b011000))?1:0;
	wire mtc0_MA = ((Instr_MA[31:26] === 6'b010000) & (Instr_MA[25:21] === 5'b00100))?1:0;
	wire mfc0_MA = ((Instr_MA[31:26] === 6'b010000) & (Instr_MA[25:21] === 5'b00000))?1:0;
	wire syscall_MA = ((Instr_MA[31:26] === 6'b000000) & (Instr_MA[5:0] === 6'b001100))?1:0;
	
	
	//get Tuse in ID
	wire [1:0] Tuse_rs = (add_ID | sub_ID | ori_ID | lw_ID | sw_ID | lui_ID | and_ID | or_ID | slt_ID | sltu_ID | addi_ID | andi_ID | lb_ID | lh_ID | sb_ID | sh_ID | mthi_ID | mtlo_ID | mult_ID | multu_ID | div_ID | divu_ID)?2'b01:
								(beq_ID | jr_ID | bne_ID)? 2'b00:
								2'b11;
								
	wire [1:0] Tuse_rt = (add_ID | sub_ID | and_ID | or_ID | slt_ID |sltu_ID | mult_ID | multu_ID | div_ID | divu_ID)? 2'b01:
								(sw_ID | sb_ID | sh_ID)? 2'b10: 
								(beq_ID | bne_ID)? 2'b00:
								2'b11;
	//get Tnew
	wire [1:0] Tnew_EX = (add_EX | sub_EX | ori_EX | lui_EX | and_EX | or_EX | slt_EX | sltu_EX | addi_EX | andi_EX | mfhi_EX | mflo_EX)? 2'b01:
								(lw_EX | lb_EX | lh_EX | mfc0_EX)? 2'b10: 2'b00;
	wire [1:0] Tnew_MA = (lw_MA | lb_MA | lh_MA | mfc0_MA)?2'b01:2'b00;
	
	wire [4:0] RS_ID = Instr_ID[25:21];
   wire [4:0] RT_ID = Instr_ID[20:16];
	wire [4:0] RD_EX = Instr_EX[15:11];
   wire [4:0] RD_MA = Instr_MA[15:11];
	
	wire Stall_RS_EX = (Tuse_rs < Tnew_EX) & (A3_EX == RS_ID & RS_ID != 0);
	wire Stall_RS_MA = (Tuse_rs < Tnew_MA) & (A3_MA == RS_ID & RS_ID != 0);
	wire Stall_RT_EX = (Tuse_rt < Tnew_EX) & (A3_EX == RT_ID & RT_ID != 0);
	wire Stall_RT_MA = (Tuse_rt < Tnew_MA) & (A3_MA == RT_ID & RT_ID != 0);
	wire Stall_md = ((busy | start) & (mult_ID | multu_ID | div_ID | divu_ID | mfhi_ID | mflo_ID | mthi_ID | mtlo_ID));
	wire Stall_eret = (eret_ID) && ((mtc0_EX && RD_EX == 5'd14) || (mtc0_MA && RD_MA == 5'd14));

	assign Stall = Stall_RS_EX | Stall_RS_MA | Stall_RT_EX | Stall_RT_MA | Stall_md | Stall_eret;

endmodule