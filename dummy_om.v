module dummy_om(
	input [6:0] address_read_om,
	output reg [10:0] data_read_om,
	output reg new_state,
	input next_screen,
	input clk
);


	reg [5:0] guy_shift;
	reg guy_pos;
	
	always @(posedge clk) begin
		if (next_screen) begin
//			if ((guy_shift == 47) | (guy_shift == 0)) begin
			if (guy_shift == 47) begin
				guy_pos <= ~guy_pos;
//				if (guy_shift == 0) guy_shift <= 1;
//				else guy_shift <= 46;
				guy_shift <= 0;
			end else begin
//				guy_shift <= guy_shift + (guy_pos ? 1 : -1);
				guy_shift <= guy_shift + 1;
			end
			new_state <= 1'b1;
		end else begin
			new_state <= 1'b0;
			if ((address_read_om == 12) & guy_pos) begin
				data_read_om <= {3'd7, guy_shift, 1'b0, 1'b1};
			end else if ((address_read_om == 13) & ~guy_pos) begin
				data_read_om <= {3'd7, guy_shift, 1'b0, 1'b0};
//			if (address_read_om == 12) begin
//				data_read_om <= {3'd4, guy_shift, 1'b0, 1'b1};
			end else begin
//				data_read_om <= {((address_read_om & 1) ? 3'd0 : 3'd2), 6'b0, 1'b0, 1'b0};
				if (address_read_om == 0) data_read_om <= {3'd1, 6'b0, 1'b0, 1'b0};
				else if (address_read_om == 12) data_read_om <= {3'd1, 6'b0, 1'b0, 1'b0};
				else if (address_read_om == 13) data_read_om <= {3'd1, 6'b0, 1'b0, 1'b0};
				else data_read_om <= {3'd2, 6'b0, 1'b0, 1'b0};
			end
		end
	end
	
	

endmodule