module operational_memory(
	input [6:0] address_write,
	input [10:0] data_write,
	input wren,
	input [6:0] address_read_gl,
	input [6:0] address_read_ed,
	output reg [10:0] data_read_gl,
	output reg [10:0] data_read_ed,
	input next_screen,
	input new_state,
	input clk
);

	reg [15:0] operational_memory [128] /* synthesis ram_init_file = "op_memory.mif" */;

	reg gl_reading;
	
	always @(posedge clk) begin
		if (wren) begin
			operational_memory[address_write] <= data_write;
		end

		if (next_screen) gl_reading <= 1'b1;

		if (new_state) gl_reading <= 1'b0;

		if (gl_reading) data_read_gl <= operational_memory[address_read_gl][10:0];
		else data_read_ed <= operational_memory[address_read_ed][10:0];

	end

endmodule