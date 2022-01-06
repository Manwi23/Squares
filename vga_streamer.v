module vga_streamer(
		output reg  [29:0] avalon_streaming_source_data,          // avalon_streaming_source.data
		output wire        avalon_streaming_source_startofpacket, //                        .startofpacket
		output wire        avalon_streaming_source_endofpacket,   //                        .endofpacket
		output reg         avalon_streaming_source_valid,         //                        .valid
		input  wire        avalon_streaming_source_ready,         //                        .ready
		input  wire        clock_vga,                             //               clock_vga.clk
		output wire			 next_row,
		output wire        next_screen,
		input       [23:0] data,
		output reg  [8:0]  address,
		input              start
);

	localparam [23:0] max = 307200;
	localparam [9:0] row = 640;
	integer start_drawing = 80;
	integer end_drawing = 480;
	localparam [9:0] signal_next_row = row - 40;
	localparam [23:0] signal_next_screen = max - 100;
	
	reg [19:0] counter;
	reg [9:0] row_counter;
	
	wire drawing;
	
	initial begin
		counter <= 0;
		row_counter <= 0;
		avalon_streaming_source_valid <= 1'b1;
		address <= 9'b0;
	end
	
	assign avalon_streaming_source_startofpacket = start & !counter;
	assign avalon_streaming_source_endofpacket = (counter == max - 1);
	assign next_screen = counter == signal_next_screen;
	assign next_row = (row_counter == signal_next_row);
	assign drawing = row_counter >= start_drawing & row_counter <= end_drawing;
	
	always @(posedge clock_vga) begin
		if (start & avalon_streaming_source_ready) begin
			if (drawing) begin
				avalon_streaming_source_data <= {data[23:16], 2'b0, data[15:8], 2'b0, data[7:0], 2'b0};
				address <= address + 1;
			end else avalon_streaming_source_data <= 30'b0;
			
			if (counter == max - 1) counter <= 0;
			else counter <= counter + 1;
			
			if (row_counter == row - 1) begin
				row_counter <= 0;
				address <= 0;
			end else row_counter <= row_counter + 1;
			
		end
	end
	

endmodule