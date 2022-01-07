// game.v

// This file was auto-generated as a prototype implementation of a module
// created in component editor.  It ties off all outputs to ground and
// ignores all inputs.  It needs to be edited to make it do something
// useful.
// 
// This file will not be automatically regenerated.  You should check it in
// to your version control system if you want to keep it.

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
		input  wire        clock_ps                               //                clock_ps.clk
	);

	wire next_row, next_screen;
	wire [23:0] data_read_vga;
	wire [8:0] address_read_vga;
	wire [23:0] data_write_row;
	wire [8:0] address_write_row;
	wire [20:0] data_read_ent;
	wire [7:0] address_read_ent;
	wire [7:0] entities_number;
	wire swap_row;
	wire swap_screen;
	wire next_row_detected;
	wire next_screen_detected;
	wire wren;
	wire next_row_detected_vga;
	
	wire start = 1'b1;
	wire swapped;
	
	posedge_detector pd_row(clock, swap_row, next_row_detected);
	posedge_detector pd_screen(clock, swap_screen, next_screen_detected);
	
	synchronizer_slow_to_fast #(1) s1(clock, next_row, swap_row); // input output
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
						address_read_vga,
						start);
						
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
					  clock);
					  
	dummy_entities de(address_read_ent,
							data_read_ent,
							entities_number,
							clock);
	

endmodule
