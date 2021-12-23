
module squares (
	clk_clk,
	lights_leds,
	lights_hex,
	pll_0_locked_export,
	ps2_ps2_clk,
	ps2_ps2_data,
	reset_reset_n,
	vga_CLK,
	vga_HS,
	vga_VS,
	vga_BLANK,
	vga_SYNC,
	vga_R,
	vga_G,
	vga_B);	

	input		clk_clk;
	output	[9:0]	lights_leds;
	output	[41:0]	lights_hex;
	output		pll_0_locked_export;
	input		ps2_ps2_clk;
	input		ps2_ps2_data;
	input		reset_reset_n;
	output		vga_CLK;
	output		vga_HS;
	output		vga_VS;
	output		vga_BLANK;
	output		vga_SYNC;
	output	[7:0]	vga_R;
	output	[7:0]	vga_G;
	output	[7:0]	vga_B;
endmodule
