`timescale 1ns / 1ps

module jumpEXT(
    input [25:0] index,
    input [31:0] pc,
    output [31:0] ext32
    );
		
	 assign ext32 = ({6'b0,index} << 2) | ({pc[31:28],28'b0});

endmodule
