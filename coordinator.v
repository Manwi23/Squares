// coordinator.v

// This file was auto-generated as a prototype implementation of a module
// created in component editor.  It ties off all outputs to ground and
// ignores all inputs.  It needs to be edited to make it do something
// useful.
// 
// This file will not be automatically regenerated.  You should check it in
// to your version control system if you want to keep it.

`timescale 1 ps / 1 ps
module coordinator (
		output reg  [29:0] avalon_streaming_source_data,          // avalon_streaming_source.data
		output wire        avalon_streaming_source_valid,         //                        .valid
		input  wire        avalon_streaming_source_ready,         //                        .ready
		output reg         avalon_streaming_source_startofpacket, //                        .startofpacket
		output reg         avalon_streaming_source_endofpacket,   //                        .endofpacket
		input  wire        clock_clk,                             //                   clock.clk
		input  wire        reset_reset,                           //                   reset.reset
		input  wire        conduit_end_clk,                       //             conduit_end.ps2_clk
		input  wire        conduit_end_data,                       //                        .ps2_data
		input  wire        clock_50_clk,                          //           the system clock
		output wire [9:0]  leds,                                  //                  lights.leds
      output wire [41:0] hex,                                    //                        .hex
		input  wire        clock_25_clk,                           //                clock_25.clk
		output wire [9:0]  avalon_master_address,                 //           avalon_master.address
	   output wire        avalon_master_read,                    //                        .read
	   input  wire [7:0]  avalon_master_readdata,                //                        .readdata
	   output wire        avalon_master_write,                   //                        .write
	   output wire [7:0]  avalon_master_writedata,               //                        .writedata
	   input  wire        avalon_master_waitrequest 
	);
	
	reg [19:0] counter;
	reg [9:0] cur_width;
	reg [9:0] cur_height;
	
	wire [9:0] width = 640;
	wire [9:0] height = 480;
	
	wire [29:0] outcolor1;
	wire [29:0] outcolor2;
	reg next1;
	
	integer max = 307200;
	
	assign avalon_streaming_source_valid = 1'b1;
	
	auto_square square1(outcolor1, cur_width, cur_height, clock_clk, next1);
	keyboard_square ks(outcolor2, cur_width, cur_height, clock_clk, next1, conduit_end_clk, 
							conduit_end_data, clock_50_clk, clock_25_clk, leds, hex);
	
	initial begin
		counter <= 0;
		cur_width <= 0;
		cur_height <= 0;
		avalon_streaming_source_startofpacket <= 1'b0;
		avalon_streaming_source_endofpacket <= 1'b0;
		next1 <= 1'b0;
	end
	
	always @(posedge clock_clk) begin
		if (reset_reset) begin 
			counter <= 0;
			cur_width <= 0;
			cur_height <= 0;
		end
		else begin
			if (avalon_streaming_source_ready) begin
				if (counter == 0) avalon_streaming_source_startofpacket <= 1'b1;
				else avalon_streaming_source_startofpacket <= 1'b0;
					
				avalon_streaming_source_data <= ~(outcolor1 & outcolor2);
				
				counter <= counter + 1;
				cur_width <= cur_width + 1;
				
				if (cur_width == width - 1) begin 
					cur_width <= 1'b0;
					cur_height <= cur_height + 1;
					if (cur_height == height - 1) cur_height <= 1'b0;
				end
				if (counter == max - 1) begin
					avalon_streaming_source_endofpacket <= 1'b1;
					counter <= 0;
					cur_width <= 0;
					cur_height <= 0;
					next1 <= 1'b1;
				end else begin
					avalon_streaming_source_endofpacket <= 1'b0;
					next1 <= 1'b0;
				end
			end else next1 <= 1'b0;
		end
	end

endmodule
