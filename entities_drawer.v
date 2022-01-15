module entities_drawer(
	output reg [7:0] address_write_ent,
	output reg [20:0] data_write_ent,
	output reg 	wren,
	output reg [7:0] entities_number,
	output [6:0] address_read_om,
	input [10:0] data_read_om,
	input new_state,
	input next_screen,
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
	wire [2:0] ent_type;
	wire [8:0] place_in_row;
	wire [8:0] place_in_col;

	reg waiting;
	reg drawing;
	reg first_pass;
	reg wait_for_read;
	reg next_end;
	
	initial begin
		entities_number <= 8'b0;
		wren <= 1'b0;
		waiting <= 1'b0;
		drawing <= 1'b0;
		wait_for_read <= 1'b0;
	end
	
	assign ent_type = data_read_om[10:8];
	assign address_read_om = row_address * row_dir + col_address;
	assign shift_up = (data_read_om[1] & ~data_read_om[0]) ? data_read_om[7:2] : 0;
	assign shift_down = (data_read_om[1] & data_read_om[0]) ? data_read_om[7:2] : 0;
	assign shift_right = (~data_read_om[1] & data_read_om[0]) ? data_read_om[7:2] : 0;
	assign shift_left = (~data_read_om[1] & ~data_read_om[0]) ? data_read_om[7:2] : 0;
	assign place_in_row = row_address * one_entity_dir;
	assign place_in_col = col_address * one_entity_dir;
	assign new_pos_updown = place_in_row - shift_up + shift_down;
	assign new_pos_rightleft = place_in_col - shift_left + shift_right;
	
	
	always @(posedge clk) begin
		if (next_screen) waiting <= 1'b1;
		else if (waiting & new_state) begin
			drawing <= 1'b1;
			waiting <= 1'b0;
			entities_number <= 8'd100;
			first_pass <= 1'b1;
			wait_for_read <= 1'b1;
			next_end <= 1'b0;
		end else if (drawing & ~next_end) begin
			if (~wait_for_read) begin
				wren <= 1'b1;
				if ((ent_type > 3) & first_pass) begin // tło
					if (ent_type > 5) begin 
						data_write_ent <= {3'b100, place_in_row, place_in_col};
					end else begin
						data_write_ent <= {3'b000, place_in_row, place_in_col};
					end
					address_write_ent <= address_read_om;
				end else if ((ent_type > 3) & ~first_pass) begin
					if ((ent_type == 4) | (ent_type == 7)) begin
						data_write_ent <= {3'b010, new_pos_updown, new_pos_rightleft};
					end else begin
						data_write_ent <= {3'b001, new_pos_updown, new_pos_rightleft};
					end
					address_write_ent <= entities_number;
					entities_number <= entities_number + 1;
				end else begin
					case (ent_type) 
						3'b000: data_write_ent <= {3'b000, new_pos_updown, new_pos_rightleft};
						3'b001: data_write_ent <= {3'b100, new_pos_updown, new_pos_rightleft};
						3'b010: data_write_ent <= {3'b011, new_pos_updown, new_pos_rightleft};
						default: data_write_ent <= {3'b001, new_pos_updown, new_pos_rightleft}; // for test
					endcase
					address_write_ent <= address_read_om;
				end
				
				if ((address_read_om == board_size - 1) & (((ent_type > 3) & ~first_pass) | (ent_type < 4))) begin
					next_end <= 1'b1;
				end else begin
					if ((ent_type < 4) | ((ent_type > 3) & ~first_pass)) begin
						if (col_address < 9) begin
							col_address <= col_address + 1;
						end else begin
							col_address <= 0;
							row_address <= row_address + 1;
						end
						wait_for_read <= 1'b1;
						first_pass <= 1'b1;
					end
				end
				
				if (first_pass & (ent_type > 3)) first_pass <= 1'b0;
				
			end else begin
				wait_for_read <= 1'b0;
				wren <= 1'b0;
			end
		end else if (next_end) begin
			drawing <= 1'b0;
			wren <= 1'b0;
			col_address <= 0;
			row_address <= 0;
		end
		
	end



endmodule