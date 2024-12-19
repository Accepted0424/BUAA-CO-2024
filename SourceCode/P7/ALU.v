`timescale 1ns / 1ps
`define NULL 4'b0000
`define SUB 4'b0001
`define OR 4'b0010
`define SL16 4'b0011 
`define AND 4'b0100
`define SLT 4'b0101
`define SLTU 4'b0110
`define ADDI 4'b0111
`define ADD 4'b1111

module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] F,
	 input [2:0] load_type,
	 input [2:0] store_type,
    output reg [31:0] C,
	 output [3:0] exc
    );
	 
	 wire [32:0] A_ext = {A[31],A};
	 wire [32:0] B_ext = {B[31],B};
	 
	 wire [32:0] addi_temp = A_ext + B_ext;
	 wire addi_overflow = ((F == `ADDI) && (addi_temp[32] != addi_temp[31]));
	 
	 wire [32:0] add_temp = A_ext + B_ext;
	 wire add_overflow = ((F == `ADD) && (add_temp[32] != add_temp[31]));
	 
	 wire [32:0] sub_temp = A_ext - B_ext;
	 wire sub_overflow = ((F == `SUB) && (sub_temp[32] != sub_temp[31]));
	 
	 assign exc = ((load_type != 3'b0) && (add_overflow))? 4'd4:
					  ((store_type != 3'b0)&& (add_overflow))? 4'd5:
					  (addi_overflow | add_overflow | sub_overflow)? 4'd12: 4'd0;

    always @(*) begin
        case(F)
            `ADD:    C = A + B;
				`ADDI:	C = A + B;
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