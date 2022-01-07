module mem(
	input [A-1:0] address_in,
	input [S-1:0] data_in,
	input clock_in,
	input wren,
	input [A-1:0] address_out,
	output reg [S-1:0] data_out,
	input clock_out,
	input reset
);

	parameter A = 9;
	parameter S = 24;

	reg [S-1:0] memory [1<<A];
	reg [((1<<A) - 1):0] holding_data;
	
	wire [A-1:0] zero = 0;
	
	initial begin
		holding_data <= 0;
	end
	
	always @(posedge clock_out) begin
		if (holding_data[address_out]) data_out <=  memory[address_out];
		else data_out <= 0;
	end
	
	always @(posedge clock_in) begin
		if (reset) begin
			holding_data <= 0;
		end else if (wren) begin
			memory[address_in] <= data_in;
			holding_data[address_in] <= 1'b1;
		end
	end

endmodule