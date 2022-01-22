module entities_mover(
    output reg [6:0] address_write_om,
	output reg [10:0] data_write_om,
	output reg wren,
    output reg [6:0] cowboy_row_out,
    output reg [6:0] cowboy_col_out,
    output reg new_state_ready,
    output reg move_done,
    input [6:0] cowboy_row,
    input [6:0] cowboy_col,
    input [10:0] pos_cowboy_om,
    input [6:0] box_row,
    input [6:0] box_col,
    input [10:0] pos_box_om,
    input only_moving_cowboy,
    input process_move,
    input [2:0] field_type_after,
    input clk,
    output wire [9:0] leds
);

    localparam [6:0] row = 10;
    
    wire [10:0] next_cowboy_pos;
    wire [10:0] next_box_pos;
    wire [6:0] cowboy_row_new;
	wire [6:0] cowboy_col_new;
	wire [6:0] box_row_new;
	wire [6:0] box_col_new;

    reg processing;
    reg cowboy_leaving_field_first_pass;
    reg waiting_for_new_move;

    reg [10:0] pos_cowboy_calc;
    reg [10:0] pos_box_calc;
    reg [1:0] moved_cowboy_and_box;

    assign next_cowboy_pos = {pos_cowboy_calc[10:8], 
                                pos_cowboy_calc[7:2] + 6'b1,
                                pos_cowboy_calc[1:0]};
    assign next_box_pos =  {pos_box_calc[10:8], 
                                    pos_box_calc[7:2] + 6'b1,
                                    pos_box_calc[1:0]};
    
    assign cowboy_row_new = pos_cowboy_calc[1] ? (pos_cowboy_calc[0] ? (cowboy_row_out + 1) : (cowboy_row_out - 1)) : cowboy_row_out;
	assign cowboy_col_new = ~(pos_cowboy_calc[1]) ? (pos_cowboy_calc[0] ? (cowboy_col_out + 1) : (cowboy_col_out - 1)) : cowboy_col_out;
	assign box_row_new = pos_box_calc[1] ? (pos_box_calc[0] ? (box_row + 1) : (box_row - 1)) : box_row;
	assign box_col_new = ~(pos_box_calc[1]) ? (pos_box_calc[0] ? (box_col + 1) : (box_col - 1)) : box_col;

    initial begin
        processing <= 1'b0;
        waiting_for_new_move <= 1'b1;
    end

    assign leds[0] = processing;
    assign leds[4:1] = box_row_new[3:0];
    assign leds[8:5] = box_row[3:0];
    // assign leds[9:7] = pos_cowboy_calc[10:8];
    // assign leds[7] = process_move;
    
    always @(posedge clk) begin
        if (process_move & ~processing) begin
            processing <= 1'b1;
            cowboy_row_out <= cowboy_row;
            cowboy_col_out <= cowboy_col;
            waiting_for_new_move <= 1'b0;
            if (waiting_for_new_move) begin
                pos_cowboy_calc <= pos_cowboy_om;
                pos_box_calc <= pos_box_om;
                moved_cowboy_and_box <= {~(pos_cowboy_om[7:2] < 48), 
                                        only_moving_cowboy | (~only_moving_cowboy & ~(pos_box_om[7:2] < 48))};
            end else begin
                moved_cowboy_and_box <= {~(pos_cowboy_calc[7:2] < 48), 
                                        only_moving_cowboy | (~only_moving_cowboy & ~(pos_box_calc[7:2] < 48))};
            end
        end else if (process_move & ~new_state_ready) begin
            if (~(moved_cowboy_and_box[1])) begin
                if (pos_cowboy_calc[7:2] < 47) begin
                    data_write_om <= next_cowboy_pos;
                    pos_cowboy_calc[7:0] <= next_cowboy_pos[7:0];
                    address_write_om <= cowboy_row_out * row + cowboy_col_out;
                    wren <= 1'b1;
                    cowboy_leaving_field_first_pass <= 1'b1;
                    moved_cowboy_and_box[1] <= 1'b1;
                end else begin
                    if (cowboy_leaving_field_first_pass) begin
                        data_write_om <= {(pos_cowboy_calc[10:8] == 3'd4) ? 3'b0 : 3'b1, 6'b0, 1'b0, 1'b0};
                        address_write_om <= cowboy_row_out * row + cowboy_col_out;
                        wren <= 1'b1;
                        cowboy_leaving_field_first_pass <= 1'b0;
                        pos_cowboy_calc[7:0] <= next_cowboy_pos[7:0];
                    end else begin
                        data_write_om <= {((pos_box_calc[10:8] == 3'd5) | (pos_box_calc[10:8] == 3'd0)) ? 3'd4 : 3'd7, 6'b0, 1'b0, 1'b0};
                        address_write_om <= cowboy_row_new * row + cowboy_col_new;
                        cowboy_row_out <= cowboy_row_new;
                        cowboy_col_out <= cowboy_col_new;
                        wren <= 1'b1;
                        moved_cowboy_and_box[1] <= 1'b1;
                    end
                end
            end else if (~moved_cowboy_and_box[0]) begin
                if (pos_box_calc[7:2] < 47) begin
                    data_write_om <= next_box_pos;
                    pos_box_calc[7:0] <= next_box_pos[7:0];
                    address_write_om <= box_row * row + box_col;
                    wren <= 1'b1;
                    moved_cowboy_and_box[0] <= 1'b1;
                end else begin
                    data_write_om <= {(field_type_after == 3'b0) ? 3'd5 : 3'd6, 6'b0, 1'b0, 1'b0};
                    address_write_om <= box_row_new * row + box_col_new;
                    pos_box_calc[7:0] <= next_box_pos[7:0];
                    wren <= 1'b1;
                    moved_cowboy_and_box[0] <= 1'b1;
                end
            end else begin
                wren <= 1'b0;
                address_write_om <= 7'd120;
                moved_cowboy_and_box <= {~(pos_cowboy_calc[7:2] < 48), 
                                        only_moving_cowboy | (~only_moving_cowboy & ~(pos_box_calc[7:2] < 48))};
                if (only_moving_cowboy ? (pos_cowboy_calc[7:2] < 48) : (pos_box_calc[7:2] < 48)) begin
                    new_state_ready <= 1'b1;
                end else begin
                    move_done <= 1'b1;
                    new_state_ready <= 1'b1;
                    waiting_for_new_move <= 1'b1;
                end
            end
        end else begin
            processing <= 1'b0;
            new_state_ready <= 1'b0;
            move_done <= 1'b0;
        end
    end




endmodule