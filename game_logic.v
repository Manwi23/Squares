module game_logic(
	output wire [6:0] address_write_om,
	output wire [10:0] data_write_om,
	output wire wren,
	output reg [6:0] address_read_om,
	input [10:0] data_read_om,
	input next_screen,
	output reg new_state,
	input [3:0] keys,
	input clk,
	output wire [9:0] leds,
	output wire [41:0] hexa
);
	
	localparam [6:0] row = 10;
	
	reg game_begin;
	reg wait_for_read;
	reg game_begin_read_row;
	reg game_begin_read_col;
	reg cowboy_leaving_field_first_pass;
	reg processing_next_screen;
	reg processing_click;
	reg cowboy_moving_to_box;
	reg cowboy_checked;
	reg cowboy_read;
	reg box_read;
	reg started_end;
	reg moving_units;
	reg only_moving_cowboy;
	reg process_move;
	reg wren_gl;

	reg [6:0] cowboy_row;
	reg [6:0] cowboy_col;
	reg [6:0] other_row;
	reg [6:0] other_col;
	reg [10:0] pos_other_for_calc;
	reg [10:0] pos_cowboy_for_calc;
	reg [2:0] field_type_after;
	reg [3:0] click_to_process;
	reg [6:0] star_counter;
	reg [5:0] cooldown;
	reg [3:0] kd_mem;
	reg [9:0] counter_of_what;
	reg [6:0] address_write_om_gl;
	reg [10:0] data_write_om_gl;
	
	wire game_end;
	wire wren_ent_mv;
	wire new_state_ready;
	wire move_done;

	wire [6:0] cowboy_row_click;
	wire [6:0] cowboy_col_click;
	wire [6:0] other_row_click;
	wire [6:0] other_col_click;
	wire [3:0] kd;
	wire [3:0] kd_one;		
	wire [6:0] cowboy_row_out;
	wire [6:0] cowboy_col_out;
	wire [6:0] address_write_om_ent_mv;
	wire [10:0] data_write_om_ent_mv;
							
	assign cowboy_row_click = click_to_process[0] ? cowboy_row - 1 : (click_to_process[1] ? cowboy_row + 1 : cowboy_row);
	assign cowboy_col_click = click_to_process[3] ? cowboy_col -1 : (click_to_process[2] ? cowboy_col + 1 : cowboy_col);
	assign other_row_click = click_to_process[0] ? other_row -1 : (click_to_process[1] ? other_row + 1 : other_row);
	assign other_col_click = click_to_process[3] ? other_col -1 : (click_to_process[2] ? other_col + 1 : other_col);	

	assign game_end = (star_counter == 0);

	assign address_write_om = (process_move ? address_write_om_ent_mv : address_write_om_gl);
	assign data_write_om = (process_move ? data_write_om_ent_mv : data_write_om_gl);
	assign wren = (process_move ? wren_ent_mv : wren_gl);

	initial begin
		game_begin <= 1'b1;
		wait_for_read <= 1'b1;
		game_begin_read_row <= 1'b1;
		game_begin_read_col <= 1'b1;
		address_write_om_gl <= 120;
		kd_mem <= 4'b0;
		star_counter <= 6'b1;
		started_end <= 1'b0;
		process_move <= 1'b0;
	end

	hextoseg h0(hexa[6:0], star_counter[3:0]);
	hextoseg h1(hexa[13:7], star_counter[6:4]);
	hextoseg h2(hexa[20:14], cowboy_col[3:0]);
	hextoseg h3(hexa[27:21], cowboy_row[3:0]);
	hextoseg h4(hexa[34:28], pos_cowboy_for_calc[10:8]);
	hextoseg h5(hexa[41:35], pos_other_for_calc[10:8]);

	posedge_detector p0(clk, keys[0], kd[0]);
	posedge_detector p1(clk, keys[1], kd[1]);
	posedge_detector p2(clk, keys[2], kd[2]);
	posedge_detector p3(clk, keys[3], kd[3]);

	first_lit fl(kd, kd_one);

	entities_mover ent_mover(address_write_om_ent_mv,
							data_write_om_ent_mv,
							wren_ent_mv,
							cowboy_row_out,
							cowboy_col_out,
    						new_state_ready,
							move_done,
							cowboy_row,
							cowboy_col,
    						pos_cowboy_for_calc,
							other_row,
							other_col,
							pos_other_for_calc,
							only_moving_cowboy,
							process_move,
							field_type_after,
							clk,
							leds);
	
	always @(posedge clk) begin
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
					end else if (game_begin_read_col) begin 
						cowboy_col <= data_read_om;
						address_read_om <= address_read_om + 1;
						wait_for_read <= 1'b1;
						game_begin_read_col <= 1'b0;
					end else begin
						game_begin <= 1'b0;
						new_state <= 1'b1;
						processing_click <= 1'b0;
						star_counter <= data_read_om;
						processing_next_screen <= 1'b0;
					end
				end
			end
		end else if (~game_end | (game_end & moving_units)) begin
			if (next_screen) processing_next_screen <= 1'b1;

			if (moving_units & processing_next_screen) begin
				process_move <= 1'b1;
				if (new_state_ready) begin
					process_move <= 1'b0;
					new_state <= 1'b1;
					processing_next_screen <= 1'b0;
					if (move_done) begin
						moving_units <= 1'b0;
						cowboy_row <= cowboy_row_out;
						cowboy_col <= cowboy_col_out;
					end
				end
			end else begin
				if (processing_click) begin
					// leds[0] <= 1'b1;
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
							if (data_read_om[10:8] == 2) begin // wall
								processing_click <= 1'b0;
								new_state <= 1'b1;
								processing_next_screen <= 1'b0;
							end else if ((data_read_om[10:8] == 0) | (data_read_om[10:8] == 1)) begin // empty field
								moving_units <= 1'b1;
								pos_other_for_calc[10:8] <= data_read_om[10:8];
								pos_cowboy_for_calc[7:0] <= {6'b0, 
																click_to_process[0] | click_to_process[1],
																click_to_process[1] | click_to_process[2]};
								processing_click <= 1'b0;
								only_moving_cowboy <= 1'b1;
								processing_next_screen <= 1'b0;
								new_state <= 1'b1;
							end else begin // box
								address_read_om <= other_row_click * row + other_col_click;
								wait_for_read <= 1'b1;
								box_read <= 1'b0;
								pos_other_for_calc[10:8] <= data_read_om[10:8];
								cowboy_read <= 1'b1;
							end
						end else if (~box_read) begin
							if ((data_read_om[10:8] == 0) | (data_read_om[10:8] == 1)) begin // box moving to an empty field
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
								case({pos_other_for_calc[10:8], data_read_om[10:8]})
									{3'd5, 3'd1}: star_counter <= star_counter - 1;
									{3'd6, 3'd0}: star_counter <= star_counter + 1;
									default: star_counter <= star_counter;
								endcase

							end else begin // box can't move
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
		end else begin // game_end
			started_end <= 1'b1;
			address_write_om_gl <= 0;
			data_write_om_gl <= 0;
			wren_gl <= 1'b1;
			if (started_end) begin
				if (address_write_om_gl < 99) begin
					address_write_om_gl <= address_write_om_gl + 7'b1;
				end else begin
					wren_gl <= 1'b0;
					new_state <= 1'b1;
				end

				if (address_write_om_gl == 43) begin
					data_write_om_gl <= {3'b011, 8'b0};
				end else begin
					data_write_om_gl <= 0;
				end
			end
		end
		
		if (started_end & (address_write_om_gl == 99) & next_screen) new_state <= 1'b1;

		if (new_state) new_state <= 1'b0;
		if (wait_for_read) wait_for_read <= 1'b0;

		if (kd_one != 0) begin
			kd_mem <= kd_one;
		end else if (new_state) begin
			kd_mem <= 0;
		end

	end

endmodule