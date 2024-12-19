`timescale 1ns / 1ps

module mips(
    input clk,                    // 时钟信号
    input reset,                  // 同步复位信号
    input interrupt,              // 外部中断信号
    output [31:0] macroscopic_pc, // 宏观 PC

    output [31:0] i_inst_addr,    // IM 读取地址（取指 PC）
    input  [31:0] i_inst_rdata,   // IM 读取数据

    output [31:0] m_data_addr,    // DM 读写地址
    input  [31:0] m_data_rdata,   // DM 读取数据
    output [31:0] m_data_wdata,   // DM 待写入数据
    output [3 :0] m_data_byteen,  // DM 字节使能信号

    output [31:0] m_int_addr,     // 中断发生器待写入地址
    output [3 :0] m_int_byteen,   // 中断发生器字节使能信号

    output [31:0] m_inst_addr,    // M 级 PC

    output w_grf_we,              // GRF 写使能信号
    output [4 :0] w_grf_addr,     // GRF 待写入寄存器编号
    output [31:0] w_grf_wdata,    // GRF 待写入数据

    output [31:0] w_inst_addr     // W 级 PC
    );

	 wire [31:0] m_data_addr_CPU;
    wire [31:0] m_data_wdata_CPU;
    wire [3:0] m_data_byteen_CPU;
	 wire [31:0] m_data_rdata_bridge;
	 wire IRQ_TC0;
	 wire IRQ_TC1;
	 wire IRQ = (IRQ_TC0 | IRQ_TC1);
	 wire [5:0] HWInt = {3'b000, interrupt, IRQ_TC1, IRQ_TC0};
	
	 CPU cpu (
		.clk(clk), 								//in
		.reset(reset), 						//in
		.HWInt(HWInt),
		.MacroPC(macroscopic_pc),

		.i_inst_rdata(i_inst_rdata), 		//in
		.i_inst_addr(i_inst_addr), 		//out

		.w_grf_we(w_grf_we), 				//out
		.w_grf_addr(w_grf_addr), 			//out
		.w_grf_wdata(w_grf_wdata), 		//out
		.w_inst_addr(w_inst_addr), 		//out

		.m_data_rdata(m_data_rdata), 		//in
		.m_data_addr(m_data_addr_CPU), 	//out
		.m_data_wdata(m_data_wdata_CPU), //out 
		.m_data_byteen(m_data_byteen_CPU),//out
		.m_inst_addr(m_inst_addr) 			//out
	 );
	 
	 wire [31:0] TC0_Addr_bridge;
	 wire TC0_WE_bridge;
	 wire [31:0] TC0_Din_bridge;
	 wire [31:0] TC0_Dout;
	 
	 wire [31:0] TC1_Addr_bridge;
	 wire TC1_WE_bridge;
	 wire [31:0] TC1_Din_bridge;
	 wire [31:0] TC1_Dout;
	 
	 Bridge bridge (
		.tmp_m_data_addr(m_data_addr_CPU), 		//in
		.tmp_m_data_wdata(m_data_wdata_CPU), 	//in
		.tmp_m_data_byteen(m_data_byteen_CPU), //in
		.tmp_m_data_rdata(m_data_rdata_bridge),//out
		
		.m_data_addr(m_data_addr), 				//out
		.m_data_wdata(m_data_wdata), 				//out
		.m_data_byteen(m_data_byteen), 			//out
		.m_data_rdata(m_data_rdata), 				//in
		
		.TC0_Addr(TC0_Addr_bridge), 				//out
		.TC0_WE(TC0_WE_bridge), 					//out
		.TC0_Din(TC0_Din_bridge), 					//out
		.TC0_Dout(TC0_Dout), 						//in
		
		.TC1_Addr(TC1_Addr_bridge), 				//out
		.TC1_WE(TC1_WE_bridge), 					//out
		.TC1_Din(TC1_Din_bridge), 					//out
		.TC1_Dout(TC1_Dout), 						//in
		
		.m_int_addr(m_int_addr),
		.m_int_byteen(m_int_byteen)
	 );
	 
	 TC tc0 (
		.clk(clk),
		.reset(reset),
		.Addr(TC0_Addr_bridge[31:2]),
		.WE(TC0_WE_bridge),
		.Din(TC0_Din_bridge),
		.Dout(TC0_Dout),
		.IRQ(IRQ_TC0)
	 );
	 
	 TC tc1 (
		.clk(clk),
		.reset(reset),
		.Addr(TC1_Addr_bridge[31:2]),
		.WE(TC1_WE_bridge),
		.Din(TC1_Din_bridge),
		.Dout(TC1_Dout),
		.IRQ(IRQ_TC1)
	 );
	 
	 


endmodule
