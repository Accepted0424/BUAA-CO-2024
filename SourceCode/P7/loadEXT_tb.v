`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:42:05 12/04/2024
// Design Name:   loadEXT
// Module Name:   D:/iseProject/P6/loadEXT_tb.v
// Project Name:  P6
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: loadEXT
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module loadEXT_tb;

	// Inputs
	reg [1:0] byte_addr;
	reg [31:0] data_input;
	reg [2:0] load_type;

	// Outputs
	wire [31:0] data_out;

	// Instantiate the Unit Under Test (UUT)
	loadEXT uut (
		.byte_addr(byte_addr), 
		.data_input(data_input), 
		.load_type(load_type), 
		.data_out(data_out)
	);

	initial begin
		// Initialize Inputs
		byte_addr = 0;
		data_input = 0;
		load_type = 0;

		// Wait 100 ns for global reset to finish
		#100;
      byte_addr = 2'b01;
		load_type = 3'b010;
		data_input = 32'h0123fdec;
		// Add stimulus here

	end
      
endmodule

