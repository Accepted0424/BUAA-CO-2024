`timescale 1ns / 1ps

module MulDivBlock_tb;

	// Inputs
	reg clk;
	reg [31:0] A;
	reg [31:0] B;
	reg [3:0] op;

	// Outputs
	wire busy;
	wire start;
	wire [31:0] HI;
	wire [31:0] LO;

	// Instantiate the Unit Under Test (UUT)
	MulDivBlock uut (
		.clk(clk), 
		.A(A), 
		.B(B), 
		.op(op), 
		.busy(busy), 
		.start(start), 
		.HI(HI), 
		.LO(LO)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		A = 0;
		B = 0;
		op = 0;

		// Wait 100 ns for global reset to finish
		#100;
      op = 4'b0001;
		A = 32'd233;
		B = 32'd2;
		#10
		op = 4'b0000;
		// Add stimulus here

	end
	always #5 clk = ~clk;
      
endmodule

