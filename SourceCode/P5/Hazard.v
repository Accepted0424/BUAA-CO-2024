`timescale 1ns / 1ps

module Hazard(
		input [4:0] A3_EX,
		input [4:0] A3_MA,

		input [31:0] Instr_ID,
		input [31:0] Instr_EX,
		input [31:0] Instr_MA,
		
		output Stall
    );
	 
	//get Tuse
	wire add_ID = ((Instr_ID[31:26] === 6'b000000) & (Instr_ID[5:0] === 6'b100000))?1:0;
	wire sub_ID = ((Instr_ID[31:26] === 6'b000000) & (Instr_ID[5:0] === 6'b100010))?1:0;
	wire ori_ID = (Instr_ID[31:26] === 6'b001101)?1:0;
	wire lw_ID = (Instr_ID[31:26] === 6'b100011)?1:0;
	wire sw_ID = (Instr_ID[31:26] === 6'b101011)?1:0;
	wire beq_ID = (Instr_ID[31:26] === 6'b000100)?1:0;
	wire lui_ID = (Instr_ID[31:26] === 6'b001111)?1:0;
	wire jal_ID = (Instr_ID[31:26] === 6'b000011)?1:0;
	wire jr_ID = ((Instr_ID[31:26] === 6'b000000) & (Instr_ID[5:0] === 6'b001000))?1:0;

	wire [1:0] Tuse_rs = (add_ID | sub_ID | ori_ID | lw_ID | sw_ID | lui_ID)?2'b01:
								(beq_ID | jr_ID)? 2'b00:
								2'b11;
								
	wire [1:0] Tuse_rt = (add_ID | sub_ID)? 2'b01:
								(sw_ID)? 2'b10: 
								(beq_ID)? 2'b00:
								2'b11;
	//get Tnew
	wire add_EX = ((Instr_EX[31:26] === 6'b000000) & (Instr_EX[5:0] === 6'b100000))?1:0;
	wire sub_EX = ((Instr_EX[31:26] === 6'b000000) & (Instr_EX[5:0] === 6'b100010))?1:0;
	wire ori_EX = (Instr_EX[31:26] === 6'b001101)?1:0;
	wire lw_EX = (Instr_EX[31:26] === 6'b100011)?1:0;
	wire sw_EX = (Instr_EX[31:26] === 6'b101011)?1:0;
	wire beq_EX = (Instr_EX[31:26] === 6'b000100)?1:0;
	wire lui_EX = (Instr_EX[31:26] === 6'b001111)?1:0;
	wire jal_EX = (Instr_EX[31:26] === 6'b000011)?1:0;
	wire jr_EX = ((Instr_EX[31:26] === 6'b000000) & (Instr_EX[5:0] === 6'b001000))?1:0;

	wire add_MA = ((Instr_MA[31:26] === 6'b000000) & (Instr_MA[5:0] === 6'b100000))?1:0;
	wire sub_MA = ((Instr_MA[31:26] === 6'b000000) & (Instr_MA[5:0] === 6'b100010))?1:0;
	wire ori_MA = (Instr_MA[31:26] === 6'b001101)?1:0;
	wire lw_MA = (Instr_MA[31:26] === 6'b100011)?1:0;
	wire sw_MA = (Instr_MA[31:26] === 6'b101011)?1:0;
	wire beq_MA = (Instr_MA[31:26] === 6'b000100)?1:0;
	wire lui_MA = (Instr_MA[31:26] === 6'b001111)?1:0;
	wire jal_MA = (Instr_MA[31:26] === 6'b000011)?1:0;
	wire jr_MA = ((Instr_MA[31:26] === 6'b000000) & (Instr_MA[5:0] === 6'b001000))?1:0;

	wire [1:0] Tnew_EX = (add_EX | sub_EX | ori_EX | lui_EX)? 2'b01:
								(lw_EX)? 2'b10: 2'b00;
	wire [1:0] Tnew_MA = lw_MA?2'b01:2'b00;
	
	wire [4:0] RS_ID = Instr_ID[25:21];
   wire [4:0] RT_ID = Instr_ID[20:16];
	
	wire Stall_RS_EX = (Tuse_rs < Tnew_EX) & (A3_EX == RS_ID & RS_ID != 0);
	wire Stall_RS_MA = (Tuse_rs < Tnew_MA) & (A3_MA == RS_ID & RS_ID != 0);
	wire Stall_RT_EX = (Tuse_rt < Tnew_EX) & (A3_EX == RT_ID & RT_ID != 0);
	wire Stall_RT_MA = (Tuse_rt < Tnew_MA) & (A3_MA == RT_ID & RT_ID != 0);
	
	assign Stall = Stall_RS_EX | Stall_RS_MA | Stall_RT_EX | Stall_RT_MA;

endmodule