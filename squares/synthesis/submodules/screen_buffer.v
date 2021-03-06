// screen_buffer.v

// This file was auto-generated as a prototype implementation of a module
// created in component editor.  It ties off all outputs to ground and
// ignores all inputs.  It needs to be edited to make it do something
// useful.
// 
// This file will not be automatically regenerated.  You should check it in
// to your version control system if you want to keep it.

`timescale 1 ps / 1 ps
module screen_buffer (
		input  wire        clock_vga,                             //                   clock.clk
		input  wire        reset_reset,                           //                   reset.reset
		input  wire        swap,                                  //             conduit_end.swap
		input  wire [23:0] color,                                 //                        .color
		input  wire [23:0] address,                               //                        .address
		input  wire        clock_input,                           //                  clock2.clk
		output wire [29:0] avalon_streaming_source_data,          // avalon_streaming_source.data
		output wire        avalon_streaming_source_startofpacket, //                        .startofpacket
		output wire        avalon_streaming_source_endofpacket,   //                        .endofpacket
		output wire        avalon_streaming_source_valid,         //                        .valid
		input  wire        avalon_streaming_source_ready          //                        .ready
	);

	// TODO: Auto-generated HDL template

	assign avalon_streaming_source_valid = 1'b0;

	assign avalon_streaming_source_data = 30'b000000000000000000000000000000;

	assign avalon_streaming_source_startofpacket = 1'b0;

	assign avalon_streaming_source_endofpacket = 1'b0;

endmodule
