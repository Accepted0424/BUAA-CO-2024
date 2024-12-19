`timescale 1ns / 1ps

module jumpEXT(
    input [25:0] index,
    input [31:0] pc,
    output [31:0] ext32
    );
	 
	 wire [31:0] pc_sub4;
	 assign pc_sub4 = pc - 4;
		
	 assign ext32 = ({6'b0,index} << 2) | ({pc_sub4[31:28],28'b0});

endmodule
