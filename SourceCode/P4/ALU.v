`timescale 1ns / 1ps
`include "constant.v"

module ALU(
    input [31:0] A,
    input [31:0] B,
    input [4:0] shamt,
    input [3:0] F,
    output reg [31:0] C
    );

    always @(*) begin
        case(F)
            `ADD:    C = A + B;
            `SUB:    C = A - B;
            `OR:     C = A | B;
            `SL16:   C = B << 16;
            `SLL:    C = B << shamt;
            `SRL:    C = B >> shamt;
            `SRA:    C = B >>> shamt;
            default:C = 0;
        endcase
    end
    
endmodule