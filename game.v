`timescale 1 ps / 1 ps
module game (
		input  wire        reset_reset,                           //                   reset.reset
		input  wire        conduit_end_clk,                       //             conduit_end.conduit_end_clk
		input  wire        conduit_end_data,                      //                        .conduit_end_data
		output wire [29:0] avalon_streaming_source_data,          // avalon_streaming_source.data
		output wire        avalon_streaming_source_startofpacket, //                        .startofpacket
		output wire        avalon_streaming_source_endofpacket,   //                        .endofpacket
		output wire        avalon_streaming_source_valid,         //                        .valid
		input  wire        avalon_streaming_source_ready,         //                        .ready
		input  wire        clock_vga,                             //               clock_vga.clk
		input  wire        clock,                                 //                clock_50.clk
		input  wire        clock_ps,                              //                clock_ps.clk
		input  wire [3:0]  keys,                                  //                    keys
        input  wire [9:0]  switches                               //                    switches
	);

	wire [23:0] data_read_vga;
	wire [8:0] address_read_vga;
	wire [23:0] data_write_row;
	wire [8:0] address_write_row;
	wire [20:0] data_read_ent;
	wire [7:0] address_read_ent;
	wire [7:0] entities_number;
	wire [6:0] address_read_ed;
	wire [10:0] data_read_ed;
	wire [10:0] data_read_gl;
	wire [7:0] address_write_ent;
	wire [20:0] data_write_ent;
	wire [6:0] address_write_om;
	wire [10:0] data_write_om;
	wire [6:0] address_read_gl;
	wire [3:0] keys_keyboard;

	wire next_row;
	wire next_screen;
	wire swap_row;
	wire swap_screen;
	wire next_row_detected;
	wire next_screen_detected;
	wire wren;
	wire next_row_detected_vga;
	wire wren_ent_mem;
	wire new_state;
	wire wren_om;
	
	posedge_detector pd_row(clock, swap_row, next_row_detected);
	posedge_detector pd_screen(clock, swap_screen, next_screen_detected);
	
	synchronizer_slow_to_fast #(1) s1(clock, next_row, swap_row);
	synchronizer_slow_to_fast #(1) s2(clock, next_screen, swap_screen);
	
	posedge_detector pd_row_vga(clock_vga, next_row, next_row_detected_vga);
	
	vga_streamer v(avalon_streaming_source_data,
						avalon_streaming_source_startofpacket,
						avalon_streaming_source_endofpacket,
						avalon_streaming_source_valid,
						avalon_streaming_source_ready,
						clock_vga,
						next_row,
						next_screen,
						data_read_vga,
						address_read_vga);
						
	double_memory #(.A(9), .S(24)) d(address_write_row,
									data_write_row,
									clock,
									wren,
									address_read_vga,
									data_read_vga,
									clock_vga,
									next_row_detected_vga);
												 
	row_drawer rd(address_read_ent,
					data_read_ent,
					entities_number,
					address_write_row,
					data_write_row,
					wren,
					next_row_detected,
					next_screen_detected,
					clock);
					  
							
	double_memory #(.A(8), .S(21)) d_ent(address_write_ent,
										data_write_ent,
										clock,
										wren_ent_mem,
										address_read_ent,
										data_read_ent,
										clock,
										next_screen_detected);
													 
	entities_drawer ent_drawer(address_write_ent,
								data_write_ent,
								wren_ent_mem,
								entities_number,
								address_read_ed,
								data_read_ed,
								new_state,
								next_screen_detected,
								clock);
	
	operational_memory om(address_write_om,
							data_write_om,
							wren_om,
							address_read_gl,
							address_read_ed,
							data_read_gl,
							data_read_ed,
							next_screen_detected,
							new_state,
							clock);
								
	game_logic gl(address_write_om,
					data_write_om,
					wren_om,
					address_read_gl,
					data_read_gl,
					next_screen_detected,
					new_state,
					keys_keyboard,
					clock,
					keys,
					switches);
					  
	keyboard_controller kc(keys_keyboard,
							clock,
							clock_ps,
							conduit_end_data,
							conduit_end_clk);
	
endmodule
