`timescale 1ns / 1ps

module PC(
    input clk,
    input reset,
    input en,
    input [31:0] next_pc,
    output [31:0] current_pc
    );
    
    reg [31:0] pc;
    assign current_pc = pc;

    initial begin
        pc = 32'h3000;
    end

    always @(posedge clk) begin
        if (reset) begin
            pc <= 32'h3000;
        end
        else begin
            if (en) begin
               pc <= next_pc;
            end
        end
    end

endmodule
