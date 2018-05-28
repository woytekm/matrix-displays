// Copyright (C) 2017  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel MegaCore Function License Agreement, or other 
// applicable license agreement, including, without limitation, 
// that your use is for the sole purpose of programming logic 
// devices manufactured by Intel and sold by Intel or its 
// authorized distributors.  Please refer to the applicable 
// agreement for further details.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 17.0.0 Build 595 04/25/2017 SJ Lite Edition"
// CREATED		"Fri May 18 12:32:10 2018"

module Block1(
	SCLK,
	MOSI,
	CS,
	PLL_INCLK,
	MISO,
	m_r1,
	m_g1,
	m_b1,
	m_r2,
	m_latch,
	m_oe,
	m_clk,
	testpin1,
	testpin2,
	testpin3,
	m_g2,
	m_b2,
	m_line_addr
);


input wire	SCLK;
input wire	MOSI;
input wire	CS;
input wire	PLL_INCLK;
output wire	MISO;
output wire	m_r1;
output wire	m_g1;
output wire	m_b1;
output wire	m_r2;
output wire	m_latch;
output wire	m_oe;
output wire	m_clk;
output wire	testpin1;
output wire	testpin2;
output wire	testpin3;
output wire	m_g2;
output wire	m_b2;
output wire	[3:0] m_line_addr;

wire	[3:0] m_line_addr_ALTERA_SYNTHESIZED;
wire	SYNTHESIZED_WIRE_18;
wire	SYNTHESIZED_WIRE_19;
wire	SYNTHESIZED_WIRE_2;
wire	[15:0] SYNTHESIZED_WIRE_20;
wire	[15:0] SYNTHESIZED_WIRE_4;
wire	[7:0] SYNTHESIZED_WIRE_21;
wire	SYNTHESIZED_WIRE_6;
wire	SYNTHESIZED_WIRE_7;
wire	SYNTHESIZED_WIRE_8;
wire	SYNTHESIZED_WIRE_9;
wire	[7:0] SYNTHESIZED_WIRE_10;
wire	SYNTHESIZED_WIRE_15;
wire	SYNTHESIZED_WIRE_16;
wire	SYNTHESIZED_WIRE_17;

assign	m_g1 = SYNTHESIZED_WIRE_15;
assign	m_clk = SYNTHESIZED_WIRE_16;
assign	testpin1 = SYNTHESIZED_WIRE_15;
assign	testpin2 = SYNTHESIZED_WIRE_17;
assign	testpin3 = SYNTHESIZED_WIRE_16;
assign	m_g2 = SYNTHESIZED_WIRE_17;
assign	SYNTHESIZED_WIRE_6 = 0;




true_dpram_dclk	b2v_inst(
	.we_a(SYNTHESIZED_WIRE_18),
	.clk_a(SYNTHESIZED_WIRE_19),
	.clk_b(SYNTHESIZED_WIRE_2),
	.addr_a(SYNTHESIZED_WIRE_20),
	.addr_b(SYNTHESIZED_WIRE_4),
	.input_a(SYNTHESIZED_WIRE_21),
	.output_b(SYNTHESIZED_WIRE_10));


system_PLL	b2v_inst1(
	.inclk0(PLL_INCLK),
	.areset(SYNTHESIZED_WIRE_6),
	.c0(SYNTHESIZED_WIRE_8),
	
	
	.c3(SYNTHESIZED_WIRE_9),
	.c4(SYNTHESIZED_WIRE_7)
	);


spi_recv	b2v_inst2(
	.sclk(SCLK),
	.mosi(MOSI),
	.cs(CS),
	.clk(SYNTHESIZED_WIRE_7),
	.miso(MISO),
	.memclk(SYNTHESIZED_WIRE_19),
	.mem_we(SYNTHESIZED_WIRE_18),
	.mem_addr(SYNTHESIZED_WIRE_20),
	.output_byte_reversed(SYNTHESIZED_WIRE_21));


matrix_driver	b2v_inst3(
	.matrix_refresh_clk(SYNTHESIZED_WIRE_8),
	.display_driver_clk(SYNTHESIZED_WIRE_9),
	
	.input_byte(SYNTHESIZED_WIRE_10),
	.ramclk(SYNTHESIZED_WIRE_2),
	.m_r1(m_r1),
	.m_g1(SYNTHESIZED_WIRE_15),
	.m_b1(m_b1),
	.m_r2(m_r2),
	.m_g2(SYNTHESIZED_WIRE_17),
	.m_b2(m_b2),
	.m_latch(m_latch),
	.m_oe(m_oe),
	.m_clk(SYNTHESIZED_WIRE_16),
	.m_line_addr(m_line_addr_ALTERA_SYNTHESIZED),
	.mem_addr(SYNTHESIZED_WIRE_4));



debug_RAM	b2v_inst9(
	.clock(SYNTHESIZED_WIRE_19),
	.wren(SYNTHESIZED_WIRE_18),
	.address(SYNTHESIZED_WIRE_20),
	.data(SYNTHESIZED_WIRE_21)
	);

assign	m_line_addr = m_line_addr_ALTERA_SYNTHESIZED;

endmodule
