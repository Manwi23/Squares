module keyboard_controller(output reg [3:0] keys, input clk_50, input clk_25, input PS2_DAT, input PS2_CLK,
									output reg [5:0] leds, output [41:0] hex);
//	wire [15:0] up = 16'h1275;
//	wire [15:0] down = 16'h1272;
//	wire [15:0] left = 16'h126b;
//	wire [15:0] right = 16'h1274;

	wire [7:0] up = 8'h75;
	wire [7:0] down = 8'h72;
	wire [7:0] left = 8'h6b;
	wire [7:0] right = 8'h74;
	
//	reg [15:0] twoCodes;
	reg [7:0] code;
	reg ifMakereg;
	reg newcode;
	
	wire [7:0] outCode;
	wire valid, ifMake;
	reg [23:0] codes;

	hextoseg h0(hex[6:0], codes[3:0]);
	hextoseg h1(hex[13:7], codes[7:4]);
	hextoseg h2(hex[20:14], codes[11:8]);
	hextoseg h3(hex[27:21], codes[15:12]);
	hextoseg h4(hex[34:28], codes[19:16]);
	hextoseg h5(hex[41:35], codes[23:20]);
	
	initial begin
		codes <= 24'b0;
		keys <= 4'b0;
//		twoCodes <= 16'b0;
		code <= 8'b0;
		newcode <= 1'b0;
		ifMakereg <= 1'b0;
		leds <= 6'b0;
	end
	
	always @(posedge clk_50) begin
		if (valid) begin
			codes <= {codes[15:0], outCode};
		end
	end
	
	keyboard_press_driver kpd(
	  clk_50, clk_25,
	  valid, ifMake,
	  outCode,
	  PS2_DAT, // PS2 data line
	  PS2_CLK, // PS2 clock line
	  1'b0
	);
	
	
	always @(posedge clk_50) begin
		if (valid) begin
			code <= outCode;
			ifMakereg <= ifMake;
			newcode <= 1'b1;
			leds <= {leds[4:0], 1'b1};
		end else begin
			if (newcode) begin
				newcode <= 1'b0;
				if (ifMakereg) begin
					casez(code)
						up: keys[0] <= 1'b1;
						down: keys[1] <= 1'b1;
						right: keys[2] <= 1'b1;
						left: keys[3] <= 1'b1;
					endcase
				end else begin
					casez(code)
//						{up[7:0], up[15:8]}: keys[0] <= 1'b0;
//						{down[7:0], down[15:8]}: keys[1] <= 1'b0;
//						{right[7:0], right[15:8]}: keys[2] <= 1'b0;
//						{left[7:0], left[15:8]}: keys[3] <= 1'b0;
						up: keys[0] <= 1'b0;
						down: keys[1] <= 1'b0;
						right: keys[2] <= 1'b0;
						left: keys[3] <= 1'b0;
					endcase
				end
			end
		end
	end
	
	

endmodule 