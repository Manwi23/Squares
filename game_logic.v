module game_logic(
	output reg [6:0] address_write_om,
	output reg [10:0] data_write_om,
	output reg wren,
	output reg [6:0] address_read_om,
	input [10:0] data_read_om,
	input next_screen,
	output reg new_state,
	input [3:0] keys,
	input clk,
	output reg [9:0] leds,
	output wire [41:0] hexa
);
	
	localparam [6:0] row = 10;
	
	reg game_begin;
	reg [6:0] ticks_left;
	reg [6:0] cowboy_row;
	reg [6:0] cowboy_col;
	reg [6:0] other_row;
	reg [6:0] other_col;
	reg wait_for_read;
	reg game_begin_read_row;
	reg [1:0] moved_cowboy_and_other;
	reg [10:0] pos_other_for_calc;
	reg [10:0] pos_cowboy_for_calc;
	reg [2:0] field_type_after;
	reg cowboy_leaving_field_first_pass;
	reg processing_next_screen;
	reg processing_click;
	reg [3:0] click_to_process;
	reg cowboy_moving_to_box;
	reg cowboy_checked;
	reg cowboy_read;
	reg box_read;

	reg [5:0] cooldown;
	wire [3:0] kd;
	wire [3:0] kd_one;
	reg [3:0] kd_mem;
	reg moving_units;
	reg only_moving_cowboy;
	
	wire [10:0] next_cowboy_pos_normal;
	wire [10:0] next_other_pos_normal;
	wire [6:0] cowboy_row_new;
	wire [6:0] cowboy_col_new;
	wire [6:0] other_row_new;
	wire [6:0] other_col_new;
	wire [6:0] cowboy_row_click;
	wire [6:0] cowboy_col_click;
	wire [6:0] other_row_click;
	wire [6:0] other_col_click;
	
	assign next_cowboy_pos_normal = {pos_cowboy_for_calc[10:8], 
												pos_cowboy_for_calc[7:2] + 6'b1,
												pos_cowboy_for_calc[1:0]};					
	assign next_other_pos_normal =  {pos_other_for_calc[10:8], 
												pos_other_for_calc[7:2] + 6'b1,
												pos_other_for_calc[1:0]};										
	
	assign cowboy_row_new = pos_cowboy_for_calc[1] ? (pos_cowboy_for_calc[0] ? (cowboy_row + 1) : (cowboy_row - 1)) : cowboy_row;
	assign cowboy_col_new = ~(pos_cowboy_for_calc[1]) ? (pos_cowboy_for_calc[0] ? (cowboy_col + 1) : (cowboy_col - 1)) : cowboy_col;
	assign other_row_new = pos_other_for_calc[1] ? (pos_other_for_calc[0] ? (other_row + 1) : (other_row - 1)) : other_row;
	assign other_col_new = ~(pos_other_for_calc[1]) ? (pos_other_for_calc[0] ? (other_col + 1) : (other_col - 1)) : other_col;
	
	// up down right left 0123
	assign cowboy_row_click = click_to_process[0] ? cowboy_row - 1 : (click_to_process[1] ? cowboy_row + 1 : cowboy_row);
	assign cowboy_col_click = click_to_process[3] ? cowboy_col -1 : (click_to_process[2] ? cowboy_col + 1 : cowboy_col);
	assign other_row_click = click_to_process[0] ? other_row -1 : (click_to_process[1] ? other_row + 1 : other_row);
	assign other_col_click = click_to_process[3] ? other_col -1 : (click_to_process[2] ? other_col + 1 : other_col);
	
	initial begin
		game_begin <= 1'b1;
		wait_for_read <= 1'b1;
		game_begin_read_row <= 1'b1;
		moved_cowboy_and_other <= 2'b0;
		address_write_om <= 120;
		kd_mem <= 4'b0;
	end

	// dopisac gdzies jeszcze counter gwiazdek

	// hextoseg h1(hexa[13:7], cowboy_row);
	hextoseg h0(hexa[6:0], other_col[3:0]);
	hextoseg h1(hexa[13:7], other_row[3:0]);
	hextoseg h2(hexa[20:14], cowboy_col[3:0]);
	hextoseg h3(hexa[27:21], cowboy_row[3:0]);
	hextoseg h4(hexa[34:28], pos_cowboy_for_calc[10:8]);
	hextoseg h5(hexa[41:35], pos_other_for_calc[10:8]);

	posedge_detector p0(clk, keys[0], kd[0]);
	posedge_detector p1(clk, keys[1], kd[1]);
	posedge_detector p2(clk, keys[2], kd[2]);
	posedge_detector p3(clk, keys[3], kd[3]);

	first_lit fl(kd, kd_one);

	reg [9:0] counter_of_what;
	
	always @(posedge clk) begin
		leds[9:0] <= counter_of_what;
		if (game_begin) begin
			if (next_screen) begin
				cooldown <= {cooldown[4:0], 1'b1};
				if (cooldown[5]) begin
					processing_next_screen <= 1'b1;
					address_read_om <= 7'd100;
					wait_for_read <= 1'b1;
				end else new_state <= 1'b1;
			end
			if (processing_next_screen) begin
				if (~wait_for_read) begin
					if (game_begin_read_row) begin
						cowboy_row <= data_read_om;
						game_begin_read_row <= 1'b0;
						address_read_om <= address_read_om + 1;
						wait_for_read <= 1'b1;
					end else begin 
						cowboy_col <= data_read_om;
						game_begin <= 1'b0;
						new_state <= 1'b1;
						processing_next_screen <= 1'b0;
						processing_click <= 1'b0;
					end
				end
			end
		end else begin
			if (next_screen) processing_next_screen <= 1'b1;

			if (moving_units & processing_next_screen) begin
				if (~(moved_cowboy_and_other[1])) begin
					if (pos_cowboy_for_calc[7:2] < 47) begin
						data_write_om <= next_cowboy_pos_normal;
						pos_cowboy_for_calc[7:0] <= next_cowboy_pos_normal[7:0];
						address_write_om <= cowboy_row * row + cowboy_col;
						wren <= 1'b1;
						cowboy_leaving_field_first_pass <= 1'b1;
						moved_cowboy_and_other[1] <= 1'b1;
					end else begin
						if (cowboy_leaving_field_first_pass) begin
							data_write_om <= {(pos_cowboy_for_calc[10:8] == 3'd4) ? 3'b0 : 3'b1, 6'b0, 1'b0, 1'b0};
							address_write_om <= cowboy_row * row + cowboy_col;
							wren <= 1'b1;
							cowboy_leaving_field_first_pass <= 1'b0;
							pos_cowboy_for_calc[7:0] <= next_cowboy_pos_normal[7:0];
						end else begin
							data_write_om <= {((pos_other_for_calc[10:8] == 3'd5) | (pos_other_for_calc[10:8] == 3'd0)) ? 3'd4 : 3'd7, 6'b0, 1'b0, 1'b0};
							address_write_om <= cowboy_row_new * row + cowboy_col_new;
							cowboy_row <= cowboy_row_new;
							cowboy_col <= cowboy_col_new;
							counter_of_what <= counter_of_what + 1;
							wren <= 1'b1;
							moved_cowboy_and_other[1] <= 1'b1;
						end
					end
				end else if (~moved_cowboy_and_other[0]) begin
					if (pos_other_for_calc[7:2] < 47) begin
						data_write_om <= next_other_pos_normal;
						pos_other_for_calc[7:0] <= next_other_pos_normal[7:0];
						address_write_om <= other_row * row + other_col;
						wren <= 1'b1;
						moved_cowboy_and_other[0] <= 1'b1;
					end else begin
						data_write_om <= {(field_type_after == 3'b0) ? 3'd5 : 3'd6, 6'b0, 1'b0, 1'b0};
						address_write_om <= other_row_new * row + other_col_new;
						other_row <= other_row_new;
						other_col <= other_col_new;
						pos_other_for_calc[7:0] <= next_other_pos_normal[7:0];
						wren <= 1'b1;
						moved_cowboy_and_other[0] <= 1'b1;
					end
				end else begin
					wren <= 1'b0;
					address_write_om <= 120;
					moving_units <= (only_moving_cowboy ? (pos_cowboy_for_calc[7:2] < 48) : (pos_other_for_calc[7:2] < 48));
					moved_cowboy_and_other <= {~(pos_cowboy_for_calc[7:2] < 48), 
												only_moving_cowboy | (~only_moving_cowboy & ~(pos_other_for_calc[7:2] < 48))}; // ???
					processing_next_screen <= 1'b0;
					new_state <= 1'b1;
				end

			end else begin
				if (processing_click) begin // up down right left 0123
					if (~wait_for_read) begin
						if (~cowboy_checked) begin
							pos_cowboy_for_calc[10:8] <= data_read_om[10:8];
							pos_cowboy_for_calc[7:0] <= {6'b0, 1'b0, 1'b0};
							pos_other_for_calc[7:0] <= {6'b0, 1'b0, 1'b0};
							address_read_om <= cowboy_row_click * row + cowboy_col_click;
							other_row <= cowboy_row_click;
							other_col <= cowboy_col_click;
							cowboy_checked <= 1'b1;
							cowboy_read <= 1'b0;
							wait_for_read <= 1'b1;
						end else if (~cowboy_read) begin
							if (data_read_om[10:8] == 2) begin // sciana
								processing_click <= 1'b0;
								new_state <= 1'b1;
								processing_next_screen <= 1'b0;
							end else if ((data_read_om[10:8] == 0) | (data_read_om[10:8] == 1)) begin // puste
								moved_cowboy_and_other[0] <= 1'b1;
								moving_units <= 1'b1;
								pos_other_for_calc[10:8] <= data_read_om[10:8];
								pos_cowboy_for_calc[7:0] <= {6'b0, 
																click_to_process[0] | click_to_process[1],
																click_to_process[1] | click_to_process[2]};
								processing_click <= 1'b0;
								only_moving_cowboy <= 1'b1;
								processing_next_screen <= 1'b0;
								new_state <= 1'b1;
							end else begin // skrzynka
								address_read_om <= other_row_click * row + other_col_click;
								wait_for_read <= 1'b1;
								box_read <= 1'b0;
								pos_other_for_calc[10:8] <= data_read_om[10:8];
								cowboy_read <= 1'b1;
							end
						end else if (~box_read) begin
							if ((data_read_om[10:8] == 0) | (data_read_om[10:8] == 1)) begin // skrzynka jedzie na puste
								field_type_after <= data_read_om[10:8];
								processing_click <= 1'b0;
								moving_units <= 1'b1;
								only_moving_cowboy <= 1'b0;
								pos_cowboy_for_calc[7:0] <= {6'b0, 
																click_to_process[0] | click_to_process[1],
																click_to_process[1] | click_to_process[2]};
								pos_other_for_calc[7:0] <= {6'b0, 
																click_to_process[0] | click_to_process[1],
																click_to_process[1] | click_to_process[2]};
								processing_next_screen <= 1'b0;
								new_state <= 1'b1;
							end else begin
								processing_click <= 1'b0;
								new_state <= 1'b1;
								processing_next_screen <= 1'b0;
							end
						end
					end
				end else if (processing_next_screen) begin
					if (kd_mem != 0) begin
						processing_click <= 1'b1;
						click_to_process <= kd_mem;
						cowboy_checked <= 1'b0;
						address_read_om <= cowboy_row * row + cowboy_col;
						wait_for_read <= 1'b1;
					end else begin
						processing_next_screen <= 1'b0;
						new_state <= 1'b1;
						address_read_om <= cowboy_row * row + cowboy_col;
					end
				end
			end
		end
		
		if (new_state) new_state <= 1'b0;
		if (wait_for_read) wait_for_read <= 1'b0;

		if (kd_one != 0) begin
			kd_mem <= kd_one;
		end else if (new_state) begin
			kd_mem <= 0;
		end

	end
	

endmodule