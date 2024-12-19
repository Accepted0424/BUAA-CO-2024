`timescale 1ns / 1ps

module loadEXT(
    input [1:0] byte_addr,
    input [31:0] data_input,
    input [2:0] load_type,
    output [31:0] data_out
    );
	 
	 wire [7:0] byte_sel = (byte_addr == 2'b00)? data_input[7:0]:
								  (byte_addr == 2'b01)? data_input[15:8]:
								  (byte_addr == 2'b10)? data_input[23:16]:
								  (byte_addr == 2'b11)? data_input[31:24]:
								  8'd0;
								  
	 wire [15:0] hw_sel = (byte_addr[1] == 1'b0)? data_input[15:0]:
								 (byte_addr[1] == 1'b1)? data_input[31:16]:
								 16'b0;
								  
	 assign data_out = (load_type == 3'b000)? data_input:
							 (load_type == 3'b001)? {24'b0, byte_sel}:
							 (load_type == 3'b010)? {{24{byte_sel[7]}}, byte_sel}:
							 (load_type == 3'b011)? {16'b0, hw_sel}:
							 (load_type == 3'b100)? {{16{hw_sel[15]}}, hw_sel}:
							 32'b0;
 
endmodule
