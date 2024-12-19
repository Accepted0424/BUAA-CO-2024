`timescale 1ns / 1ps

module Bridge(
		input [31:0] tmp_m_data_addr,
		input [31:0] tmp_m_data_wdata,
		input [3:0] tmp_m_data_byteen,
		output [31:0] tmp_m_data_rdata,
		
		output [31:0] m_data_addr,
		output [31:0] m_data_wdata,
		output [3:0] m_data_byteen,
		input [31:0] m_data_rdata,
		
		output [31:0] TC0_Addr,
		output TC0_WE,
		output [31:0] TC0_Din,
		input [31:0] TC0_Dout,
		
		output [31:0] TC1_Addr,
		output TC1_WE,
		output [31:0] TC1_Din,
		input [31:0] TC1_Dout,
		
		output [31:0] m_int_addr,
		output [3:0] m_int_byteen
    );
	 
	 wire DM_sel = ((tmp_m_data_addr >= 32'h0) && (tmp_m_data_addr <= 32'h2fff));
	 wire IM_sel = ((tmp_m_data_addr >= 32'h3000) && (tmp_m_data_addr <= 32'h6fff));
	 wire TC0_sel = ((tmp_m_data_addr >= 32'h7f00) && (tmp_m_data_addr <= 32'h7f0b));
	 wire TC1_sel = ((tmp_m_data_addr >= 32'h7f10) && (tmp_m_data_addr <= 32'h7f1b));
	 wire IG_sel = ((tmp_m_data_addr >= 32'h7f20) && (tmp_m_data_addr <= 32'h7f23));
	 
	 assign m_data_addr = tmp_m_data_addr;
	 assign m_data_wdata = tmp_m_data_wdata;
	 assign m_data_byteen = (DM_sel)? tmp_m_data_byteen: 4'b0;
	 
	 assign TC0_Addr = tmp_m_data_addr;
	 assign TC0_WE = (TC0_sel & (tmp_m_data_byteen == 4'b1111));
	 assign TC0_Din = tmp_m_data_wdata;
	 
	 assign TC1_Addr = tmp_m_data_addr;
	 assign TC1_WE = (TC1_sel & ((tmp_m_data_byteen == 4'b1111)));
	 assign TC1_Din = tmp_m_data_wdata;
	 
	 assign m_int_addr = tmp_m_data_addr;
	 assign m_int_byteen = (IG_sel)? tmp_m_data_byteen: 4'b0;
	 
	 assign tmp_m_data_rdata = (DM_sel)? m_data_rdata:
										(TC0_sel)? TC0_Dout:
										(TC1_sel)? TC1_Dout:
										32'b0;

endmodule
