module synchronizer_slow_to_fast(
	input clk_out,
	input [M-1:0] data_in,
	output [M-1:0] data_out
);

	parameter M = 15;

	reg [M-1:0] middle0;
	reg [M-1:0] middle1;
	reg [M-1:0] middle2;
	
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

module posedge_detector(input clk, input data_in, output reg data_out);
	initial begin
		data_out <= 1'b0;
	end
	
	always @(posedge clk) begin
		if (data_in & ~data_out) data_out <= 1'b1;
		else data_out <= 1'b0;
	end
	
endmodule