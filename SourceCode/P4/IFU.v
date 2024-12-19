`timescale 1ns / 1ps

module IFU(
    input clk,
    input reset,
	 input [31:0] next_pc,
    output [31:0] PC,
    output [31:0] Instr
    );
	 
	 reg [31:0] pc;
    reg [31:0] rom [0:4095];
	 assign PC = pc;
	 
	 initial begin
		pc = 32'h00003000;
		$readmemh("code.txt", rom);
	 end
	 
	 always @(posedge clk) begin
		if (reset) begin
			pc <= 32'h00003000;
		end else begin
			pc <= next_pc;
		end
	 end

     assign Instr = rom[((pc-32'h3000) >> 2)];


endmodule
