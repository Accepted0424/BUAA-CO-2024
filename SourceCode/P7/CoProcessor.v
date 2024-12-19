`timescale 1ns / 1ps
`define IM regs[12][15:10]
`define EXL regs[12][1]
`define IE regs[12][0]
`define BD regs[13][31]
`define IP regs[13][15:10]
`define EXCCode regs[13][6:2]

module CoProcessor(
		input clk,
		input reset,
		input en,
		input [4:0] CP0Addr,
		input [31:0] CP0In,
		output [31:0] CP0Out,
		input [31:0] VPC,
		input BDIn,
		input [3:0] EXCCodeIn,
		input [5:0] HWInt,
		input EXLClr,
		output [31:0] EPCOut,
		output Req
    );
	 
	 // SR-12, Cause-13, EPC-14
	 reg [31:0] regs [0:31];
	 assign CP0Out = regs[CP0Addr];
	 
	 wire IntReq = (|(HWInt & `IM)) & !`EXL & `IE; // 允许当前中断 且 不在中断异常中 且 允许中断发生
	 wire ExcReq = (|EXCCodeIn) & !`EXL; // 存在异常 且 不在中断中
	 assign Req = IntReq | ExcReq;
	 
	 wire [31:0] tempEPC = (Req) ? (BDIn ? VPC-4 : VPC)
                            : regs[14];

	 assign EPCOut = {tempEPC[31:2], 2'b0};
	 
	 integer i;
	 
	 initial begin
		for (i=0;i<32;i=i+1) begin
			regs[i] = 0;
		end
	 end
	 
	 always @(posedge clk) begin
		if (reset) begin
			for (i=0;i<32;i=i+1) begin
				regs[i] <= 0;
			end
		end
		else begin
			`IP <= HWInt;
			if (EXLClr) begin
				`EXL <= 1'b0;
			end
			if (Req) begin // int|exc
				`EXCCode <= IntReq ? 5'b0 : EXCCodeIn;
				`EXL <= 1'b1;
				regs[14] <= tempEPC;
				`BD <= BDIn;
			end else if (en) begin
				regs[CP0Addr] <= CP0In;
			end
		end
	 end


endmodule
