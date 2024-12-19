`timescale 1ns / 1ps

module MulDivBlock(
		input clk,
		input [31:0] A,
		input [31:0] B,
		input [3:0] op,
		input req,
		output busy,
		output start,
		output reg [31:0] HI,
		output reg [31:0] LO
    );
	 
assign busy = (mult_cnt || div_cnt);
assign start = (mult_start || div_start);

reg [3:0] mult_cnt;
reg [3:0] div_cnt;
reg mult_start;
reg div_start;

initial begin
	mult_cnt <= 0;
	div_cnt <= 0;
	mult_start <= 0;
	div_start <= 0;
	HI <= 0;
	LO <= 0;
end

always @(*) begin
	if (op == 4'b0001 || op == 4'b0010) begin
		if ((mult_cnt == 4'b0) && !req) begin
			mult_start = 1'b1;
		end
	end
	else if (op == 4'b0011 || op == 4'b0100) begin
		if ((div_cnt == 4'b0) && !req) begin
			div_start = 1'b1;
		end
	end
end

always @(posedge clk) begin
	if (mult_start) begin
		mult_start <= 0;
		mult_cnt <= mult_cnt + 1;
	end
	else if (div_start) begin
		div_start <= 0;
		div_cnt <= div_cnt + 1;
	end
	
	if (mult_cnt) begin
		if (mult_cnt == 4'd5) begin
			mult_cnt <= 0;
			HI = prod_HI;
			LO = prod_LO;
		end
		else begin
			mult_cnt <= mult_cnt + 1;
		end
	end
	else if (div_cnt) begin
		if (div_cnt == 4'd10) begin
			div_cnt <= 0;
			HI = prod_HI;
			LO = prod_LO;
		end
		else begin
			div_cnt <= div_cnt + 1;
		end
	end
end

reg [31:0] prod_HI;
reg [31:0] prod_LO;

always @(*) begin
	case (op)
		4'b0001: {prod_HI, prod_LO} = ($signed(A) * $signed(B));//mult
		4'b0010: {prod_HI, prod_LO} = $unsigned(A) * $unsigned(B);//multu
		4'b0011: {prod_HI, prod_LO} = {$signed(A) % $signed(B), $signed(A) / $signed(B)};//div
		4'b0100: {prod_HI, prod_LO} = {A % B, A / B};//divu
	endcase
	if ((B == 0) && (op == 4'b0011 || op == 4'b0100)) begin
		{prod_HI, prod_LO} = {HI, LO};
	end
end

always @(posedge clk) begin
	if ((op == 4'b0101) && !req) begin
		HI = A;
	end
	else if ((op == 4'b0110) && !req) begin
		LO = A;
	end
end

endmodule
