module game_logic(
	output wire [6:0] address_write_om,
	output wire [10:0] data_write_om,
	output wire wren,
	output reg [6:0] address_read_om,
	input [10:0] data_read_om,
	input next_screen,
	output reg new_state,
	input [3:0] keyboard_keys,
	input clk,
	input  wire [3:0] keys,
    input  wire [9:0] switches
);
	
	localparam [6:0] row = 10;
	
	reg wait_for_read;
	reg started_end;
	reg only_moving_cowboy;
	reg process_move;
	reg wren_gl;
	reg new_game_in_progress;
	reg new_game_waiting;

	reg [6:0] cowboy_row;
	reg [6:0] cowboy_col;
	reg [6:0] other_row;
	reg [6:0] other_col;
	reg [10:0] pos_other_for_calc;
	reg [10:0] pos_cowboy_for_calc;
	reg [2:0] field_type_after;
	reg [3:0] click_to_process;
	reg [10:0] star_counter;
	reg [3:0] kd_mem;
	reg [6:0] address_write_om_gl;
	reg [10:0] data_write_om_gl;
	reg [4:0] state;
	
	wire wren_ent_mv;
	wire wren_ngc;
	wire new_state_ready;
	wire move_done;
	wire new_game_request;
	wire new_game_ready;
	wire resetting;

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
	wire [6:0] address_write_om_ngc;
	wire [10:0] data_write_om_ngc;
							
	assign cowboy_row_click = click_to_process[0] ? cowboy_row - 1 : (click_to_process[1] ? cowboy_row + 1 : cowboy_row);
	assign cowboy_col_click = click_to_process[3] ? cowboy_col -1 : (click_to_process[2] ? cowboy_col + 1 : cowboy_col);
	assign other_row_click = click_to_process[0] ? other_row -1 : (click_to_process[1] ? other_row + 1 : other_row);
	assign other_col_click = click_to_process[3] ? other_col -1 : (click_to_process[2] ? other_col + 1 : other_col);	

	// if you wanted to go exactly one step per click
	// posedge_detector p0(clk, keyboard_keys[0], kd[0]);
	// posedge_detector p1(clk, keyboard_keys[1], kd[1]);
	// posedge_detector p2(clk, keyboard_keys[2], kd[2]);
	// posedge_detector p3(clk, keyboard_keys[3], kd[3]);

	assign kd = keyboard_keys;

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
							new_game_ready);

	new_game_coordinator ngc(address_write_om_ngc,
							data_write_om_ngc,
							wren_ngc,
    						keys,
    						switches,
    						new_game_request,
							new_game_in_progress,
    						resetting,
							new_game_ready,
    						clk);

	assign address_write_om = resetting ? address_write_om_ngc : (process_move ? address_write_om_ent_mv : address_write_om_gl);
	assign data_write_om = resetting ? data_write_om_ngc : (process_move ? data_write_om_ent_mv : data_write_om_gl);
	assign wren = resetting ? wren_ngc : (process_move ? wren_ent_mv : wren_gl);

	parameter WAITING_FOR_NEW_GAME = 0;
	parameter STARTING_NEW_GAME = 1;
	parameter INITIALIZING_COWBOY_ROW = 2;
	parameter INITIALIZING_COWBOY_COL = 3;
	parameter INITIALIZING_STARS_COUNT = 4;
	parameter GAME_IN_PROGRESS_NOTHING = 5;
	parameter ENDING_GAME = 6;
	parameter GAME_ENDED_LOOP = 7;
	parameter GAME_IN_PROGRESS_CLICK = 8;
	parameter GAME_IN_PROGRESS_CHECK_COWBOY = 9;
	parameter GAME_IN_PROGRESS_MOVING_STUFF = 10;
	parameter GAME_IN_PROGRESS_CHECK_BOX = 11;

	initial begin
		wait_for_read <= 1'b1;
		address_write_om_gl <= 120;
		kd_mem <= 4'b0;
		star_counter <= 11'b0;
		started_end <= 1'b0;
		process_move <= 1'b0;
		state <= GAME_ENDED_LOOP;
		new_game_in_progress <= 1'b0;
	end

	always @(posedge clk) begin
		if (new_game_request) new_game_waiting <= 1'b1;

		case (state)
			WAITING_FOR_NEW_GAME:
				begin
					if (next_screen) begin
						state <= STARTING_NEW_GAME;
						wren_gl <= 1'b0;
						new_game_in_progress <= 1'b1;
						new_game_waiting <= 1'b0;
					end
				end
			STARTING_NEW_GAME:
				begin
					if (new_game_ready) begin
						new_game_in_progress <= 1'b0;
						state <= INITIALIZING_COWBOY_ROW;
						star_counter <= 6'b0;
						kd_mem <= 4'b0;
						address_read_om <= 7'd100;
						wait_for_read <= 1'b1;
					end
				end
			INITIALIZING_COWBOY_ROW:
				begin
					if (~wait_for_read) begin
						cowboy_row <= data_read_om;
						state <= INITIALIZING_COWBOY_COL;
						address_read_om <= address_read_om + 7'd1;
					end else address_read_om <= address_read_om + 7'd1;
				end
			INITIALIZING_COWBOY_COL:
				begin
					cowboy_col <= data_read_om;
					state <= INITIALIZING_STARS_COUNT;
				end
			INITIALIZING_STARS_COUNT:
				begin
					star_counter <= data_read_om;
					new_state <= 1'b1;
					state <= GAME_IN_PROGRESS_NOTHING;
				end
			GAME_IN_PROGRESS_NOTHING:
				begin
					if (next_screen) begin
						if (new_game_waiting) begin
							state <= WAITING_FOR_NEW_GAME;
							new_state <= 1'b1;
						end else begin
							if (star_counter == 0) begin
								state <= ENDING_GAME;
								started_end <= 1'b0;
							end else begin
								if (kd_mem != 0) begin
									state <= GAME_IN_PROGRESS_CLICK;
									click_to_process <= kd_mem;
									wait_for_read <= 1'b1;
								end else begin
									new_state <= 1'b1;
								end

								address_read_om <= cowboy_row * row + cowboy_col;
							end
						end
					end
				end
			ENDING_GAME:
				begin
					if (~started_end) begin
						started_end <= 1'b1;
						address_write_om_gl <= 0;
						data_write_om_gl <= {3'b000, 8'b0};
						wren_gl <= 1'b1;
					end else begin
						if (address_write_om_gl < 99) begin
							address_write_om_gl <= address_write_om_gl + 7'b1;
						end else begin
							wren_gl <= 1'b0;
							new_state <= 1'b1;
							address_write_om_gl <= 123;
							state <= GAME_ENDED_LOOP;
						end

						if (address_write_om_gl == 43) begin
							data_write_om_gl <= {3'b011, 8'b0};
						end else begin
							data_write_om_gl <= {3'b000, 8'b0};
						end
					end
				end
			GAME_IN_PROGRESS_CLICK:
				begin
					if (~wait_for_read) begin
						pos_cowboy_for_calc[10:8] <= data_read_om[10:8];
						pos_cowboy_for_calc[7:0] <= {6'b0, 1'b0, 1'b0};
						pos_other_for_calc[7:0] <= {6'b0, 1'b0, 1'b0};
						address_read_om <= cowboy_row_click * row + cowboy_col_click;
						other_row <= cowboy_row_click;
						other_col <= cowboy_col_click;
						wait_for_read <= 1'b1;
						state <= GAME_IN_PROGRESS_CHECK_COWBOY;
					end
				end
			GAME_IN_PROGRESS_CHECK_COWBOY:
				begin
					if (~wait_for_read) begin
						if (data_read_om[10:8] == 2) begin // wall
							new_state <= 1'b1;
							state <= GAME_IN_PROGRESS_NOTHING;
						end else if ((data_read_om[10:8] == 0) | (data_read_om[10:8] == 1)) begin // empty field
							pos_other_for_calc[10:8] <= data_read_om[10:8];
							pos_cowboy_for_calc[7:0] <= {6'b0, 
															click_to_process[0] | click_to_process[1],
															click_to_process[1] | click_to_process[2]};
							only_moving_cowboy <= 1'b1;
							new_state <= 1'b1;
							state <= GAME_IN_PROGRESS_MOVING_STUFF;
						end else begin // box
							address_read_om <= other_row_click * row + other_col_click;
							wait_for_read <= 1'b1;
							pos_other_for_calc[10:8] <= data_read_om[10:8];
							state <= GAME_IN_PROGRESS_CHECK_BOX;
						end
					end
				end
			GAME_IN_PROGRESS_CHECK_BOX:
				begin
					if (~wait_for_read) begin
						if ((data_read_om[10:8] == 0) | (data_read_om[10:8] == 1)) begin // box moving to an empty field
							field_type_after <= data_read_om[10:8];
							only_moving_cowboy <= 1'b0;
							pos_cowboy_for_calc[7:0] <= {6'b0, 
															click_to_process[0] | click_to_process[1],
															click_to_process[1] | click_to_process[2]};
							pos_other_for_calc[7:0] <= {6'b0, 
															click_to_process[0] | click_to_process[1],
															click_to_process[1] | click_to_process[2]};
							new_state <= 1'b1;
							case({pos_other_for_calc[10:8], data_read_om[10:8]})
								{3'd5, 3'd1}: star_counter <= star_counter - 1;
								{3'd6, 3'd0}: star_counter <= star_counter + 1;
								default: star_counter <= star_counter;
							endcase
							state <= GAME_IN_PROGRESS_MOVING_STUFF;
						end else begin // box can't move
							new_state <= 1'b1;
							state <= GAME_IN_PROGRESS_NOTHING;
						end
					end
				end
			GAME_IN_PROGRESS_MOVING_STUFF:
				begin
					if (next_screen) begin
						process_move <= 1'b1;
					end

					if (new_state_ready) begin
						process_move <= 1'b0;
						new_state <= 1'b1;
						if (move_done) begin
							cowboy_row <= cowboy_row_out;
							cowboy_col <= cowboy_col_out;
							state <= GAME_IN_PROGRESS_NOTHING;
						end
					end
				end
			GAME_ENDED_LOOP:
				begin
					if (next_screen) begin
						new_state <= 1'b1;
						if (new_game_waiting) begin
							state <= WAITING_FOR_NEW_GAME;
						end
					end
				end
			default: state <= GAME_ENDED_LOOP;
		endcase

		if (new_state) new_state <= 1'b0;
		if (wait_for_read) wait_for_read <= 1'b0;

		if (kd_one != 0) begin
			kd_mem <= kd_one;
		end else if (new_state) begin
			kd_mem <= 0;
		end

	end

endmodule