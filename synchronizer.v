module synchronizer_slow_to_fast(
	input clk_out,
	input [M:0] data_in,
	output [M:0] data_out
);

	parameter M = 15;

	reg [M:0] middle0;
	reg [M:0] middle1;
	reg [M:0] middle2;
	
	initial begin
		middle0 <= 0;
		middle1 <= 0;
		middle2 <= 0;
	end
	
	assign data_out = middle2;
	
	always @(posedge clk_out) begin
		middle0 <= data_in;
		middle1 <= middle0;
		middle2 <= middle1;
	end

endmodule