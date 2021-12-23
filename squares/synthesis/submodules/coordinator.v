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
		input  wire        clock_clk, //vga                                            clock.clk do vga
		input  wire        reset_reset,                           //                   reset.reset
		input  wire        conduit_end_clk,                       //             conduit_end.ps2_clk
		input  wire        conduit_end_data,                       //                        .ps2_data
		input  wire        clock_50_clk, // avalon master                               the system clock
		output wire [9:0]  leds,                                  //                  lights.leds
      output wire [41:0] hex,                                    //                        .hex
		input  wire        clock_25_clk,   // ps2                                   clock_25.clk  do ps2
		output reg  [9:0]  avalon_master_address,                 //           avalon_master.address
	   output reg         avalon_master_read,                    //                        .read
	   input  wire [15:0] avalon_master_readdata,                //                        .readdata
	   output reg         avalon_master_write,                   //                        .write
	   output reg  [15:0] avalon_master_writedata,               //                        .writedata
	   input  wire        avalon_master_waitrequest 
	);
	
	reg [19:0] counter;
	reg [9:0] cur_width;
	reg [9:0] cur_height;
	
	reg [24:0] memory;
	reg [29:0] cntt;
	
	wire [9:0] width = 640;
	wire [9:0] height = 480;
	
	wire [29:0] outcolor1;
	wire [29:0] outcolor2;
	reg next1;
	
	integer max = 307200;
	
	assign avalon_streaming_source_valid = 1'b1;
	
	auto_square square1(outcolor1, cur_width, cur_height, clock_clk, next1);
	keyboard_square ks(outcolor2, cur_width, cur_height, clock_clk, next1, conduit_end_clk, 
							conduit_end_data, clock_50_clk, clock_25_clk, , );						
							
	hextoseg h0(hex[6:0], memory[3:0]);
	hextoseg h1(hex[13:7], memory[7:4]);
	hextoseg h2(hex[20:14], memory[11:8]);
	hextoseg h3(hex[27:21], memory[15:12]);
	hextoseg h4(hex[34:28], memory[19:16]);
	hextoseg h5(hex[41:35], memory[23:20]);						
	
	initial begin
		counter <= 0;
		cur_width <= 0;
		cur_height <= 0;
		avalon_streaming_source_startofpacket <= 1'b0;
		avalon_streaming_source_endofpacket <= 1'b0;
		avalon_master_write <= 1'b0;
		avalon_master_address <= 1'b0;
		avalon_master_read <= 1'b0;
		next1 <= 1'b0;
		cntt <= 30'b0;
		memory <= 24'b0;
	end
								
	always @(posedge clock_50_clk) begin
		if(cntt == 50000000) begin
			cntt <= 0;
			avalon_master_read <= 1'b1;
		end else begin
			cntt <= cntt + 1;
			if (avalon_master_read & ~avalon_master_waitrequest) begin
				memory <= {memory[7:0], avalon_master_readdata};
				avalon_master_read <= 1'b0;
				avalon_master_address <= avalon_master_address + 2;
			end
		end
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
