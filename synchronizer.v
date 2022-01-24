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

module synchronize_and_detect(input clk, input data_in, output data_out);
	wire synced;

	synchronizer s(synced, clk, data_in);
	posedge_detector p(clk, synced, data_out);
	
endmodule

module posedge_detector(input clk, input data_in, output data_out);
    reg q;
    initial begin
        q <= 1'b0;
    end

    always @(posedge clk) begin
        q <= data_in;
	end

    assign data_out = !q && data_in;

endmodule

module first_lit(input [3:0] data_in, output reg [3:0] data_out);
	always @(data_in) begin
		casez(data_in)
			4'b1???: data_out = 4'b1000;
			4'b01??: data_out = 4'b0100;
			4'b001?: data_out = 4'b0010;
			4'b0001: data_out = 4'b0001;
			default: data_out = 4'b0000;
		endcase
	end
endmodule

module synchronizer(input clk, input sig, output synsig);
    parameter N=2;

    reg [N-1:0] buffer;
    assign synsig = buffer[N-1];
    always @(posedge clk) begin
        buffer <= {buffer[N-2:0], sig};
    end
endmodule