`timescale 1ns / 1ps

module EXT(
    input [15:0] imm16,      
    input [1:0] ExtOp,        
    output reg [31:0] ext32   
);

    always @(*) begin
        case (ExtOp)
            2'b01: ext32 = {16'b0, imm16};               
            2'b10: ext32 = {{16{imm16[15]}}, imm16};     
            2'b11: ext32 = {16'hFFFF, imm16};            
            default: ext32 = 32'b0;                      
        endcase
    end

endmodule