`timescale 1ns / 1ps
`define ADD 4'b0000
`define SUB 4'b0001
`define OR 4'b0010
`define SL16 4'b0011 

module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] F,
    output reg [31:0] C
    );

    always @(*) begin
        case(F)
            `ADD:    C = A + B;
            `SUB:    C = A - B;
            `OR:     C = A | B;
            `SL16:   C = B << 16;
            default:C = 0;
        endcase
    end
    
endmodule