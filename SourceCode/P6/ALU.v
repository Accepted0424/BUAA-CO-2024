`timescale 1ns / 1ps
`define ADD 4'b0000
`define SUB 4'b0001
`define OR 4'b0010
`define SL16 4'b0011 
`define AND 4'b0100
`define SLT 4'b0101
`define SLTU 4'b0110
`define ADDI 4'b0111

module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] F,
    output reg [31:0] C
    );
	 
	 wire [32:0] A_ext = {A[31],A};
	 wire [32:0] B_ext = {B[31],B};
	 wire [32:0] temp = A_ext + B_ext;

    always @(*) begin
        case(F)
            `ADD:    C = A + B;
				`ADDI:	C = (temp[32] == temp[31])?temp[31:0]:32'd0;
            `SUB:    C = A - B;
            `OR:     C = A | B;
            `SL16:   C = B << 16;
				`AND:		C = A & B; 
				`SLT:  	C = ($signed(A) < $signed(B))? 32'b1: 32'b0;
				`SLTU: 	C = (A < B)? 32'b1: 32'b0;
            default:C = 0;
        endcase
    end
    
endmodule