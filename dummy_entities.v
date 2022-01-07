module dummy_entities(
	input [7:0] address_read_ent,
	output reg [20:0] data_read_ent,
	output [7:0] entities_number,
	input clk
);

	assign entities_number = 8'd3;
	
	always @(posedge clk) begin
		case (address_read_ent)
			8'd0: data_read_ent <= {3'd0, 9'd0, 9'd150}; // typ, wiersz, kolumna
			8'd1: data_read_ent <= {3'd1, 9'd200, 9'd300};
			8'd2: data_read_ent <= {3'd2, 9'd350, 9'd0};
		endcase
	end

endmodule