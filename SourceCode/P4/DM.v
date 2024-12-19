`timescale 1ns / 1ps
`define WORD 2'b00
`define BYTE 2'b01
`define BYTEU 2'b10
`define HALFWORD 2'b11

module DM(
    input [31:0] A,
    input [31:0] D_input,
    input [31:0] Grt,
    input str,
    input clr,
    input clk,
    input [1:0] type,
	 input [31:0] pc,    
    output [31:0] D_output
    );
		
	reg [31:0] RAM [0:8191];
	wire [31:0] valid_addr;	
	wire [31:0] word;
	assign word = RAM[valid_addr];
	wire byte;
	assign byte = A[1:0];
	wire hw_byte;
	assign hw_byte = A[1];
	reg [7:0] memByte;
	reg [15:0] memHalfWord;
	reg [31:0] newMemory_byte;
	reg [31:0] newMemory_hw;

	assign valid_addr = (type == `BYTE || type == `BYTEU || type == `HALFWORD) ? (A - (A % 4))>>2 : A>>2;

	always @(*) begin
		case(byte)
			2'b00: begin 
					memByte = word[7:0];
					newMemory_byte = {word[31:8], Grt[7:0]};
				   end	
			2'b01: begin 
					memByte = word[15:8];
					newMemory_byte = {word[31:16], Grt[7:0], word[7:0]};
				   end
			2'b10: begin
					memByte = word[23:16];
					newMemory_byte = {word[31:24], Grt[7:0], word[15:0]};
				   end	
			2'b11: begin 
					memByte = word[31:24];
					newMemory_byte = {Grt[7:0], word[23:0]};
				   end	
			default: begin 
						memByte = 8'b0;
						newMemory_byte = 32'b0;
					 end	 
		endcase
		case (hw_byte)
			1'b0: begin 
					memHalfWord = word[15:0];
					newMemory_hw = {word[31:16], Grt[15:0]}; 
				  end
			1'b1: begin
					memHalfWord = word[31:16];
					newMemory_hw = {Grt[15:0], word[15:0]};
				  end
			default: memHalfWord = 15'b0;
		endcase
	end

	assign D_output = (type == `WORD)? word:
	 				   	(type == `BYTE)? {{24{memByte[7]}}, memByte}:
	 				   	(type == `BYTEU)? {24'b0, memByte}:
	 				   	(type == `HALFWORD)?{{16{memHalfWord[15]}}, memHalfWord}:32'b0;

	integer i; 
	initial begin
		for (i = 0; i < 8191; i = i+1) begin
			RAM[i] = 0;
		end
	end
	 
    always @(posedge clk) begin
    	if (clr) begin
    		for (i = 0; i < 8191; i = i+1) begin
				RAM[i] = 0;
			end
    	end else begin
			if (str) begin
				if (type == `WORD) begin
					RAM[valid_addr] <= D_input;
					$display("@%h: *%h <= %h", pc, valid_addr<<2, D_input);
				end
				else if (type == `BYTE) begin
					RAM[valid_addr] <= newMemory_byte;
					$display("@%h: *%h <= %h", pc, valid_addr<<2, newMemory_byte);
				end
				else if (type == `HALFWORD) begin
					RAM[valid_addr] <= newMemory_hw;
					$display("@%h: *%h <= %h", pc, valid_addr<<2, newMemory_hw);
				end
			end
		end
	 end

endmodule
