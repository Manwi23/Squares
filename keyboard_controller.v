module keyboard_controller(output reg [3:0] keys, input clk_50, input clk_25, input PS2_DAT, input PS2_CLK);

	localparam [7:0] up = 8'h75;
	localparam [7:0] down = 8'h72;
	localparam [7:0] left = 8'h6b;
	localparam [7:0] right = 8'h74;
	
	reg [7:0] code;
	reg ifMakereg;
	reg newcode;
	
	wire [7:0] outCode;
	wire valid, ifMake;
	
	initial begin
		keys <= 4'b0;
		code <= 8'b0;
		newcode <= 1'b0;
		ifMakereg <= 1'b0;
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