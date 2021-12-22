module bouncing_line(output [9:0] nu, output [9:0] nd,
								input [9:0] u, input [9:0] d, 
								input clk, input ifup, input ifdown);
	parameter max = 480;
	parameter auto = 1;
	
	reg moving_down;
	reg prev_moving_down;
	initial begin
		moving_down = 1'b1;
		prev_moving_down = 1'b1;
	end
	
	assign nu = (d == max) ? u - ifup : ((u == 0) ? u + ifdown : 
						(auto ? (moving_down ? u + ifdown : u - ifup) : u - ifup + ifdown)); 
	assign nd = (d == max) ? d - ifup : ((u == 0) ? d + ifdown : 
						(auto ? (moving_down ? d + ifdown : d - ifup) : d - ifup + ifdown)); 
	
	always @(posedge clk) begin
		moving_down <= prev_moving_down;
		prev_moving_down <= (d == max) ? 1'b0 : ((u == 0) ? 1'b1 : prev_moving_down);
	end							
endmodule

module bouncing_square(output [9:0] nl, output [9:0] nr, output [9:0] nu, output [9:0] nd,
								input [9:0] l, input [9:0] r, input [9:0] u, input [9:0] d, 
								input clk, input [3:0] dirs);
	parameter maxh = 480;
	parameter maxw = 640;
	parameter auto = 1;
	
	bouncing_line #(.max(maxw), .auto(auto)) l1(nl, nr, l, r, clk, dirs[3], dirs[2]);
	bouncing_line #(.max(maxh), .auto(auto)) l2(nu, nd, u, d, clk, dirs[0], dirs[1]);
	
endmodule

module auto_square(output [29:0] outcolor, input [9:0] cur_width, input [9:0] cur_height, 
						input clk, input next);
	parameter L = 200;
	parameter R = 300;
	parameter U = 200;
	parameter D = 300;
	parameter maxh = 480;
	parameter maxw = 640;
	parameter color = 30'b111111111111111111110000000000; // blue
	
	wire [29:0] white = 30'b111111111111111111111111111111;

	wire [9:0] next_left;
	wire [9:0] next_right;
	wire [9:0] next_up;
	wire [9:0] next_down;
	reg [9:0] left;
	reg [9:0] right;
   reg [9:0] up;
	reg [9:0] down;
	
	initial begin
		left <= L;
		right <= R;
		up <= U;
		down <= D;
	end
	
	bouncing_square #(.maxh(maxh), .maxw(maxw)) square(next_left, next_right, next_up, next_down, 
							left, right, up, down, clk, 4'b1111);
	
	always @(posedge clk) begin
		if (next) begin
			left <= next_left;
			right <= next_right;
			down <= next_down;
			up <= next_up;
		end
	end
	
	assign outcolor = ((cur_height > up) & (cur_height < down) & (cur_width > left) & (cur_width < right)) ? color : white;
	
endmodule

module keyboard_square(output [29:0] outcolor, input [9:0] cur_width, input [9:0] cur_height,
								input clk, input next, input ps2_clk, input ps2_data, input clk_50, input clk_25,
								output [9:0] leds, output [41:0] hex);
	parameter L = 300;
	parameter R = 400;
	parameter U = 200;
	parameter D = 300;
	parameter maxh = 480;
	parameter maxw = 640;
	parameter color = 30'b000000000011111111111111111111; // red
	
	wire [9:0] next_left;
	wire [9:0] next_right;
	wire [9:0] next_up;
	wire [9:0] next_down;
	reg [9:0] left;
	reg [9:0] right;
   reg [9:0] up;
	reg [9:0] down;
	
	wire [29:0] white = 30'b111111111111111111111111111111;
	wire [3:0] keys; // up down right left
	
	assign leds[3:0] = keys;
//	assign leds[9:4] = 6'b0;
	
	keyboard_controller kc(keys, clk_50, clk_25, ps2_data, ps2_clk, leds[9:4], hex);
	bouncing_square #(.maxh(maxh), .maxw(maxw), .auto(0)) square(next_left, next_right, next_up, next_down,
																		left, right, up, down, clk, keys);
	
	initial begin
		left <= L;
		right <= R;
		up <= U;
		down <= D;
	end
	
	always @(posedge clk) begin
		if (next) begin
			left <= next_left;
			right <= next_right;
			down <= next_down;
			up <= next_up;
		end
	end
	
	assign outcolor = ((cur_height > up) & (cur_height < down) & (cur_width > left) & (cur_width < right)) ? color : white;
	
endmodule
