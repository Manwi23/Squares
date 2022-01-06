module row_drawer(
	output reg [7:0] address_read_ent,
	input [20:0] data_read_ent,
	input [7:0] entities_number,
	output reg [8:0] address_write_row,
	output reg [23:0] data_write_row,
	output reg wren,
	input swap,
	input swap_screen,
	input clk
);
	
	localparam [5:0] one_entity_dir = 48;
	localparam [9:0] one_entity_size = one_entity_dir * one_entity_dir;
	integer row_number;
	
	reg ready;
	reg [14:0] address_read_rom;
	wire [23:0] data_read_rom;
	reg [5:0] entity_pixel_counter;
	
	rom rommemory(address_read_rom, clk, data_read_rom);
	
	initial begin
		address_read_rom <= 15'b0;
		row_number <= -1;
		entity_pixel_counter <= 6'b0;
	end
	
	always @(posedge clk) begin
		if (swap | swap_screen) begin
			address_read_ent <= 0;
			ready <= 1'b0;
			entity_pixel_counter <= 6'b0;
			wren <= 1'b0;
			if (swap_screen) row_number <= 0;
			else row_number <= row_number + 1;
		end else if (address_read_ent < entities_number) begin
			if (ready) begin
				data_write_row <= data_read_rom;
				address_write_row <= data_read_ent[11:3] + entity_pixel_counter;
				address_read_rom <= address_read_rom + 1;
				if (entity_pixel_counter == one_entity_dir - 1) begin
					entity_pixel_counter <= 6'b0;
					ready <= 1'b0;
					wren <= 1'b0;
					address_read_ent <= address_read_ent + 1;
				end else begin
					entity_pixel_counter <= entity_pixel_counter + 1;
					wren <= 1'b1;
				end
			end else begin
				if (row_number >= data_read_ent[20:12] & row_number < data_read_ent[20:12] + one_entity_dir) begin
					address_read_rom <= data_read_ent[2:0] * one_entity_size 
											+ (row_number - data_read_ent[20:12]) * one_entity_dir;
					ready <= 1'b1;
				end else address_read_ent <= address_read_ent + 1;
			end
		end
	end
	
	



endmodule