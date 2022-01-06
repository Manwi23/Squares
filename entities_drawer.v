module entities_drawer(
	output reg [7:0] address_write_ent,
	output reg [20:0] data_write_ent,
	output reg 	wren,
	output reg [7:0] entities_number,
	output reg [6:0] address_read_om,
	input [10:0] data_read_om,
	input new_state,
	input next_screen,
	output reg ready_to_swap_ents_memory,
	input clk
);

	localparam [6:0] board_size = 100;
	localparam [8:0] one_entity_dir = 48;
	localparam [5:0] row_dir = 10;
	
	reg [8:0] row_address;
	reg [8:0] col_address;
	wire [8:0] shift_up;
	wire [8:0] shift_down;
	wire [8:0] shift_left;
	wire [8:0] shift_right;
	wire [8:0] new_pos_updown;
	wire [8:0] new_pos_rightleft;

	reg waiting;
	reg drawing;
	wire [2:0] ent_type;
	reg first_pass;

	initial begin
		entities_number <= 8'b0;
		wren <= 1'b0;
		waiting <= 1'b1;
		drawing <= 1'b0;
		ready_to_swap_ents_memory <= 1'b0;
	end
	
	assign ent_type = data_read_om[10:8];
	assign address_read_om = row_address * row_dir + col_address;
	assign shift_up = (data_read_om[1] & ~data_read_om[0]) ? data_read_om[8:2] : 0;
	assign shift_down = (data_read_om[1] & data_read_om[0]) ? data_read_om[8:2] : 0;
	assign shift_right = (~data_read_om[1] & data_read_om[0]) ? data_read_om[8:2] : 0;
	assign shift_left = (~data_read_om[1] & ~data_read_om[0]) ? data_read_om[8:2] : 0;
	assign new_pos_updown = row_address * one_entity_dir - shift_up + shift_down;
	assign new_pos_rightleft = col_address * one_entity_dir - shift_left + shift_right;
	
	always @(posedge clk) begin
		if (next_screen) waiting <= 1'b1;
		else if (waiting & new_state) begin
			drawing <= 1'b1;
			waiting <= 1'b0;
			address_write_ent <= -1;
			entities_number <= 8'b0;
			first_pass <= 1'b1;
		end else if (drawing) begin
			address_write_ent <= address_write_ent + 1;
			if (ent_type > 3 & first_pass) begin // tło, rysyjemy jak góra trochę odjechała
				first_pass <= 1'b0;
				if (data_read_om[8:2] != 0) begin
					if (ent_type > 5) begin 
						data_write_ent <= {3'b100, row_address * one_entity_dir, col_address * one_entity_dir};
					end else begin
						data_write_ent <= {3'b000, row_address * one_entity_dir, col_address * one_entity_dir};
					end
				end
			end else if (ent_type > 3 & ~first_pass) begin
				if (ent_type == 4 | ent_type == 7) begin
					data_write_ent <= {3'b010, new_pos_updown, new_pos_rightleft};
				end else begin
					data_write_ent <= {3'b001, new_pos_updown, new_pos_rightleft};
				end
			end else begin
				case (ent_type) 
					3'b000: data_write_ent <= {3'b000, new_pos_updown, new_pos_rightleft};
					3'b001: data_write_ent <= {3'b100, new_pos_updown, new_pos_rightleft};
					3'b010: data_write_ent <= {3'b011, new_pos_updown, new_pos_rightleft};
					default: data_write_ent <= 0;
				endcase
			end
			
			if (address_read_om == 99) begin
				drawing <= 1'b0;
				wren <= 1'b0;
			end else begin 
				wren <= 1'b1;
				if (ent_type < 4 | ((ent_type > 3) & ~first_pass)) begin
					if (col_address < 9) begin
						col_address <= col_address + 1;
					end else begin
						col_address <= 0;
						row_address <= row_address + 1;
					end
				end
			end
		end
	end



endmodule