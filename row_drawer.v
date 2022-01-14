module row_drawer(
	output reg [7:0] address_read_ent,
	input [20:0] data_read_ent,
	input [7:0] entities_number,
	output reg [8:0] address_write_row,
	output reg [23:0] data_write_row,
	output reg wren,
	input swap,
	input clk
);
	
	localparam [8:0] one_entity_dir = 48;
	localparam [14:0] one_entity_size = one_entity_dir * one_entity_dir;
	localparam [8:0] max_row = 480;
	
	reg [8:0] row_number;
	
	wire [8:0] start_row;
	wire [8:0] start_col;
	wire [2:0] ent_type;
	
	reg ready;
	reg [14:0] address_read_rom;
	wire [23:0] data_read_rom; // = (ent_type == 0) ? 24'b111111110000000000000000 : ((ent_type == 1) ? 24'b000000001111111100000000 : 24'b000000000000000011111111);
	reg [8:0] entity_pixel_counter;
	reg wait_for_read;
	reg wait_for_rom;
	
	romv2 rommemory(address_read_rom, clk, data_read_rom);
	
	initial begin
		address_read_rom <= 15'b0;
		row_number <= 9'b1;
		entity_pixel_counter <= 9'b0;
		address_read_ent <= 0;
		wait_for_read <= 1'b0;
		wait_for_rom <= 1'b0;
	end
	
	assign start_row = data_read_ent[17:9];
	assign start_col = data_read_ent[8:0];
	assign ent_type = data_read_ent[20:18];
	
	always @(posedge clk) begin
		if (swap) begin
			address_read_ent <= 0;
			ready <= 1'b0;
			entity_pixel_counter <= 9'b0;
			wren <= 1'b0;
			wait_for_read <= 1'b1;
			wait_for_rom <= 1'b0;
			if (row_number < max_row - 1) row_number <= row_number + 9'b1;
			else row_number <= 0;
		end else if (address_read_ent < entities_number) begin
			if (ready & ~wait_for_rom) begin
				data_write_row <= data_read_rom;
//				data_write_row <= (data_read_rom < 10) ? 24'b111111110000000000000000 : data_read_rom;
				address_read_rom <= address_read_rom + 1;
				address_write_row <= start_col + entity_pixel_counter;
				if (entity_pixel_counter == one_entity_dir - 1) begin
					ready <= 1'b0;
					address_read_ent <= address_read_ent + 1;
					wait_for_read <= 1'b1;
				end else begin
					entity_pixel_counter <= entity_pixel_counter + 1;
					wren <= (data_read_rom == 0) ? 1'b0 : 1'b1;
//					wren <= 1'b1;
//					wren <= (ent_type == 3'd4) ? 1'b0 : 1'b1;
//					wren <= 1'b0;
				end
			end else if (~wait_for_rom) begin
				if ( (row_number >= start_row) & (row_number < (start_row + one_entity_dir)) & ~wait_for_read ) begin
					address_read_rom <= (ent_type * one_entity_size) + (row_number - start_row) * one_entity_dir;
					ready <= 1'b1;
					wren <= 1'b0;
					entity_pixel_counter <= 9'b0;
					wait_for_rom <= 1'b1;
				end else if (~wait_for_read) begin
					address_read_ent <= address_read_ent + 1;
					wait_for_read <= 1'b1;
				end
			end else address_read_rom <= address_read_rom + 1;
		end
		if (wait_for_read) wait_for_read <= 1'b0;
		if (wait_for_rom) wait_for_rom <= 1'b0;
	end
	
	



endmodule