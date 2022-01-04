module mem(
	input [A-1:0] address_in,
	input [S-1:0] data_in,
	input clock_in,
	input wren,
	input [A-1:0] address_out,
	output reg [S-1:0] data_out,
	input clock_out
);

	parameter A = 10;
	parameter S = 24;

	reg [S-1:0] memory [512];
	
	always @(posedge clock_out) begin
		data_out <= memory[address_out];
	end
	
	always @(posedge clock_in) begin
		if (wren) begin
			memory[address_in] <= data_in;
		end
	end

endmodule