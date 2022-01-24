
module squares (
	clk_clk,
	hex_new_signal,
	ledr_new_signal,
	ps2_conduit_end_clk,
	ps2_conduit_end_data,
	reset_reset_n,
	vga_CLK,
	vga_HS,
	vga_VS,
	vga_BLANK,
	vga_SYNC,
	vga_R,
	vga_G,
	vga_B,
	keys_new_signal,
	switches_new_signal);	

	input		clk_clk;
	output	[41:0]	hex_new_signal;
	output	[9:0]	ledr_new_signal;
	input		ps2_conduit_end_clk;
	input		ps2_conduit_end_data;
	input		reset_reset_n;
	output		vga_CLK;
	output		vga_HS;
	output		vga_VS;
	output		vga_BLANK;
	output		vga_SYNC;
	output	[7:0]	vga_R;
	output	[7:0]	vga_G;
	output	[7:0]	vga_B;
	input	[3:0]	keys_new_signal;
	input	[9:0]	switches_new_signal;
endmodule
