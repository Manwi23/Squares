module raw_drawer(
	output reg [7:0] address_read_ent,
	input [20:0] data_read_ent,
	output reg [9:0] address_write_row,
	output reg [23:0] data_write_row,
	input swap,
	input clk
);
	
	reg [14:0] address_read_rom,
	wire [23:0] data_read_rom,

	rom rommemory(address_read_rom, clk, data_read_rom);



endmodule