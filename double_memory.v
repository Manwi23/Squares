module double_memory(
	input [A-1:0] address_write,
	input [S-1:0] data_write,
	input clock_write,
	input wren,
	input [A-1:0] address_read,
	output [S-1:0] data_read,
	input clock_read,
	input swap
);

	parameter A = 9;
	parameter S = 24;

	reg swapped;
	wire nswapped;
	
	integer counter;
	
	wire [S-1:0] data_read_1;
	wire [S-1:0] data_read_2;
	
	reg reset_mem;
	
	initial begin
		swapped <= 1'b1;
		reset_mem <= 1'b0;
	end
	
	assign nswapped = ~swapped;
	assign data_read = nswapped ? data_read_1 : data_read_2;

	
	always @(posedge clock_read) begin
		if (swap) begin
			swapped <= ~swapped;
			reset_mem <= 1'b1;
		end else reset_mem <= 1'b0;
	end

	mem #(.A(A), .S(S)) m1(address_write, data_write, clock_write, swapped & wren, address_read, data_read_1, clock_read, swapped & reset_mem);
	mem #(.A(A), .S(S)) m2(address_write, data_write, clock_write, nswapped & wren, address_read, data_read_2, clock_read, nswapped & reset_mem);

endmodule