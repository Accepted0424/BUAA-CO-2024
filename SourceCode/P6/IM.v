`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:55:30 11/06/2024 
// Design Name: 
// Module Name:    IM 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module IM(
    input [31:0] A,
    output [31:0] Instr
    );

    reg [31:0] rom [0:4095];
        
    initial begin
        $readmemh("code.txt", rom);
    end

    assign Instr = rom[(A-32'h3000) >> 2];

endmodule
