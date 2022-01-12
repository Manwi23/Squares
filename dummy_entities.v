module dummy_entities(
	input [7:0] address_read_ent,
	output reg [20:0] data_read_ent,
	output [7:0] entities_number,
	input clk
);

	assign entities_number = 8'd100;
	
	always @(posedge clk) begin
		case (address_read_ent)
//			8'd0: data_read_ent <= {3'd0, 9'd0, 9'd100}; // typ, wiersz, kolumna
//			8'd1: data_read_ent <= {3'd1, 9'd0, 9'd0};
//			8'd2: data_read_ent <= {3'd2, 9'd350, 9'd100};
//			8'd3: data_read_ent <= {3'd3, 9'd350, 9'd200};
//			8'd0: data_read_ent <= {3'd4, 9'd100, 9'd0};
//			8'd1: data_read_ent <= {3'd4, 9'd100, 9'd48};
//			8'd2: data_read_ent <= {3'd4, 9'd100, 9'd96};
//			8'd3: data_read_ent <= {3'd4, 9'd100, 9'd144};
//			8'd4: data_read_ent <= {3'd4, 9'd100, 9'd192};
//			8'd5: data_read_ent <= {3'd4, 9'd100, 9'd240};
//			8'd6: data_read_ent <= {3'd4, 9'd100, 9'd288};
//			8'd7: data_read_ent <= {3'd4, 9'd100, 9'd336};
//			8'd8: data_read_ent <= {3'd4, 9'd100, 9'd384};
//			8'd9: data_read_ent <= {3'd4, 9'd100, 9'd432};
			8'd0: data_read_ent <= {3'd4, 9'd0, 9'd0};
			8'd1: data_read_ent <= {3'd4, 9'd0, 9'd48};
			8'd2: data_read_ent <= {3'd4, 9'd0, 9'd96};
			8'd3: data_read_ent <= {3'd4, 9'd0, 9'd144};
			8'd4: data_read_ent <= {3'd4, 9'd0, 9'd192};
			8'd5: data_read_ent <= {3'd4, 9'd0, 9'd240};
			8'd6: data_read_ent <= {3'd4, 9'd0, 9'd288};
			8'd7: data_read_ent <= {3'd4, 9'd0, 9'd336};
			8'd8: data_read_ent <= {3'd4, 9'd0, 9'd384};
			8'd9: data_read_ent <= {3'd4, 9'd0, 9'd432};
			8'd10: data_read_ent <= {3'd4, 9'd48, 9'd0};
			8'd11: data_read_ent <= {3'd4, 9'd48, 9'd48};
			8'd12: data_read_ent <= {3'd4, 9'd48, 9'd96};
			8'd13: data_read_ent <= {3'd4, 9'd48, 9'd144};
			8'd14: data_read_ent <= {3'd4, 9'd48, 9'd192};
			8'd15: data_read_ent <= {3'd4, 9'd48, 9'd240};
			8'd16: data_read_ent <= {3'd4, 9'd48, 9'd288};
			8'd17: data_read_ent <= {3'd4, 9'd48, 9'd336};
			8'd18: data_read_ent <= {3'd4, 9'd48, 9'd384};
			8'd19: data_read_ent <= {3'd4, 9'd48, 9'd432};
			8'd20: data_read_ent <= {3'd4, 9'd96, 9'd0};
			8'd21: data_read_ent <= {3'd4, 9'd96, 9'd48};
			8'd22: data_read_ent <= {3'd4, 9'd96, 9'd96};
			8'd23: data_read_ent <= {3'd4, 9'd96, 9'd144};
			8'd24: data_read_ent <= {3'd4, 9'd96, 9'd192};
			8'd25: data_read_ent <= {3'd4, 9'd96, 9'd240};
			8'd26: data_read_ent <= {3'd4, 9'd96, 9'd288};
			8'd27: data_read_ent <= {3'd4, 9'd96, 9'd336};
			8'd28: data_read_ent <= {3'd4, 9'd96, 9'd384};
			8'd29: data_read_ent <= {3'd4, 9'd96, 9'd432};
			8'd30: data_read_ent <= {3'd4, 9'd144, 9'd0};
			8'd31: data_read_ent <= {3'd4, 9'd144, 9'd48};
			8'd32: data_read_ent <= {3'd4, 9'd144, 9'd96};
			8'd33: data_read_ent <= {3'd4, 9'd144, 9'd144};
			8'd34: data_read_ent <= {3'd4, 9'd144, 9'd192};
			8'd35: data_read_ent <= {3'd4, 9'd144, 9'd240};
			8'd36: data_read_ent <= {3'd4, 9'd144, 9'd288};
			8'd37: data_read_ent <= {3'd4, 9'd144, 9'd336};
			8'd38: data_read_ent <= {3'd4, 9'd144, 9'd384};
			8'd39: data_read_ent <= {3'd4, 9'd144, 9'd432};
			8'd40: data_read_ent <= {3'd4, 9'd192, 9'd0};
			8'd41: data_read_ent <= {3'd4, 9'd192, 9'd48};
			8'd42: data_read_ent <= {3'd4, 9'd192, 9'd96};
			8'd43: data_read_ent <= {3'd4, 9'd192, 9'd144};
			8'd44: data_read_ent <= {3'd4, 9'd192, 9'd192};
			8'd45: data_read_ent <= {3'd4, 9'd192, 9'd240};
			8'd46: data_read_ent <= {3'd4, 9'd192, 9'd288};
			8'd47: data_read_ent <= {3'd4, 9'd192, 9'd336};
			8'd48: data_read_ent <= {3'd4, 9'd192, 9'd384};
			8'd49: data_read_ent <= {3'd4, 9'd192, 9'd432};
			8'd50: data_read_ent <= {3'd4, 9'd240, 9'd0};
			8'd51: data_read_ent <= {3'd4, 9'd240, 9'd48};
			8'd52: data_read_ent <= {3'd4, 9'd240, 9'd96};
			8'd53: data_read_ent <= {3'd4, 9'd240, 9'd144};
			8'd54: data_read_ent <= {3'd4, 9'd240, 9'd192};
			8'd55: data_read_ent <= {3'd4, 9'd240, 9'd240};
			8'd56: data_read_ent <= {3'd4, 9'd240, 9'd288};
			8'd57: data_read_ent <= {3'd4, 9'd240, 9'd336};
			8'd58: data_read_ent <= {3'd4, 9'd240, 9'd384};
			8'd59: data_read_ent <= {3'd4, 9'd240, 9'd432};
			8'd60: data_read_ent <= {3'd4, 9'd288, 9'd0};
			8'd61: data_read_ent <= {3'd4, 9'd288, 9'd48};
			8'd62: data_read_ent <= {3'd4, 9'd288, 9'd96};
			8'd63: data_read_ent <= {3'd4, 9'd288, 9'd144};
			8'd64: data_read_ent <= {3'd4, 9'd288, 9'd192};
			8'd65: data_read_ent <= {3'd4, 9'd288, 9'd240};
			8'd66: data_read_ent <= {3'd4, 9'd288, 9'd288};
			8'd67: data_read_ent <= {3'd4, 9'd288, 9'd336};
			8'd68: data_read_ent <= {3'd4, 9'd288, 9'd384};
			8'd69: data_read_ent <= {3'd4, 9'd288, 9'd432};
			8'd70: data_read_ent <= {3'd4, 9'd336, 9'd0};
			8'd71: data_read_ent <= {3'd4, 9'd336, 9'd48};
			8'd72: data_read_ent <= {3'd4, 9'd336, 9'd96};
			8'd73: data_read_ent <= {3'd4, 9'd336, 9'd144};
			8'd74: data_read_ent <= {3'd4, 9'd336, 9'd192};
			8'd75: data_read_ent <= {3'd4, 9'd336, 9'd240};
			8'd76: data_read_ent <= {3'd4, 9'd336, 9'd288};
			8'd77: data_read_ent <= {3'd4, 9'd336, 9'd336};
			8'd78: data_read_ent <= {3'd4, 9'd336, 9'd384};
			8'd79: data_read_ent <= {3'd4, 9'd336, 9'd432};
			8'd80: data_read_ent <= {3'd4, 9'd384, 9'd0};
			8'd81: data_read_ent <= {3'd4, 9'd384, 9'd48};
			8'd82: data_read_ent <= {3'd4, 9'd384, 9'd96};
			8'd83: data_read_ent <= {3'd4, 9'd384, 9'd144};
			8'd84: data_read_ent <= {3'd4, 9'd384, 9'd192};
			8'd85: data_read_ent <= {3'd4, 9'd384, 9'd240};
			8'd86: data_read_ent <= {3'd4, 9'd384, 9'd288};
			8'd87: data_read_ent <= {3'd4, 9'd384, 9'd336};
			8'd88: data_read_ent <= {3'd4, 9'd384, 9'd384};
			8'd89: data_read_ent <= {3'd4, 9'd384, 9'd432};
			8'd90: data_read_ent <= {3'd4, 9'd432, 9'd0};
			8'd91: data_read_ent <= {3'd4, 9'd432, 9'd48};
			8'd92: data_read_ent <= {3'd4, 9'd432, 9'd96};
			8'd93: data_read_ent <= {3'd4, 9'd432, 9'd144};
			8'd94: data_read_ent <= {3'd4, 9'd432, 9'd192};
			8'd95: data_read_ent <= {3'd4, 9'd432, 9'd240};
			8'd96: data_read_ent <= {3'd4, 9'd432, 9'd288};
			8'd97: data_read_ent <= {3'd4, 9'd432, 9'd336};
			8'd98: data_read_ent <= {3'd4, 9'd432, 9'd384};
			8'd99: data_read_ent <= {3'd4, 9'd432, 9'd432};

		endcase
	end

endmodule