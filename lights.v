module lights(output [6:0] hex0, output [6:0] hex1, output [6:0] hex2, output [6:0] hex3,
				  output [6:0] hex4, output [6:0] hex5, input [7:0] code, input new_code, input clk);

reg [23:0] codes;

initial begin
	codes <= 24'b0;
end

always @(posedge clk) begin
	if (new_code) begin
		codes <= {codes[15:0], code};
	end
end

hextoseg h0(hex0, codes[3:0]);
hextoseg h1(hex1, codes[7:4]);
hextoseg h2(hex2, codes[11:8]);
hextoseg h3(hex3, codes[15:12]);
hextoseg h4(hex4, codes[19:16]);
hextoseg h5(hex5, codes[23:20]);
					
					
endmodule

module leds(output reg [9:0] led, input makeBreak, input new_code, input clk);
	initial led <= 10'b0;

	always @(posedge clk) begin
		if (new_code) led <= {led[8:0], makeBreak};
	end
	
endmodule