`timescale 1ns / 1ps
`define BEQ 6'b100000
`define BGEZ 6'b010000
`define BGTZ 6'b001000
`define BLEZ 6'b000100
`define BLTZ 6'b000010
`define BNE 6'b000001

module bCheck(
    input [31:0] Grs,
    input [31:0] Grt,
    input [5:0] bOp,
    input branch,
    output reg check
    );
	
	always @(*) begin
		check = 0;
		
		if (branch) begin
			case (bOp)
				`BEQ: check = (Grs == Grt);         		// beq
				`BGEZ: check = (Grs >= 0);           	// bgez
				`BGTZ: check = (Grs > 0);            	// bgtz
				`BLEZ: check = (Grs <= 0);           	// blez
				`BLTZ: check = ($signed(Grs) < 0);   	// bltz
				`BNE: check = (Grs != Grt);         	// bne
				default: check = 0;                   
			endcase
		end
	end
endmodule
