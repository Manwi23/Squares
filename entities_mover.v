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
    input new_game_ready
);

    localparam [6:0] row = 10;
    
    wire [10:0] next_cowboy_pos;
    wire [10:0] next_box_pos;
    wire [6:0] cowboy_row_new;
	wire [6:0] cowboy_col_new;
	wire [6:0] box_row_new;
	wire [6:0] box_col_new;

    reg cowboy_leaving_field_first_pass;
    reg cooldown;

    reg [10:0] pos_cowboy_calc;
    reg [10:0] pos_box_calc;

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

    reg [2:0] state;
    parameter WAITING_FOR_NEW_MOVE = 0;
    parameter WAITING_FOR_OLD_MOVE = 1;
    parameter PROCESSING_MOVE_COWBOY = 2;
    parameter PROCESSING_MOVE_BOX = 3;
    parameter PROCESSING_MOVE_AFTER = 4;

    initial begin
        cooldown <= 1'b1;
        state <= WAITING_FOR_NEW_MOVE;
    end

    always @(posedge clk) begin
        if (new_game_ready) begin
            state <= WAITING_FOR_NEW_MOVE;
        end else begin
            case (state)
                WAITING_FOR_NEW_MOVE:
                    begin
                        if (process_move & ~cooldown) begin
                            cowboy_row_out <= cowboy_row;
                            cowboy_col_out <= cowboy_col;
                            pos_cowboy_calc <= pos_cowboy_om;
                            pos_box_calc <= pos_box_om;
                            state <= PROCESSING_MOVE_COWBOY;
                        end
                    end
                WAITING_FOR_OLD_MOVE:
                    begin
                        if (process_move & ~cooldown) begin
                            cowboy_row_out <= cowboy_row;
                            cowboy_col_out <= cowboy_col;
                            state <= PROCESSING_MOVE_COWBOY;
                        end
                    end
                PROCESSING_MOVE_COWBOY:
                    begin
                        if (pos_cowboy_calc[7:2] < 47) begin
                            data_write_om <= next_cowboy_pos;
                            pos_cowboy_calc[7:0] <= next_cowboy_pos[7:0];
                            address_write_om <= cowboy_row_out * row + cowboy_col_out;
                            wren <= 1'b1;
                            cowboy_leaving_field_first_pass <= 1'b1;
                            if (only_moving_cowboy) begin
                                state <= PROCESSING_MOVE_AFTER;
                            end else begin
                                state <= PROCESSING_MOVE_BOX;
                            end
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
                                if (only_moving_cowboy) begin
                                    state <= PROCESSING_MOVE_AFTER;
                                    move_done <= 1'b1;
                                end else begin
                                    state <= PROCESSING_MOVE_BOX;
                                end
                            end
                        end
                    end
                PROCESSING_MOVE_BOX:
                    begin
                        if (pos_box_calc[7:2] < 47) begin
                            data_write_om <= next_box_pos;
                            pos_box_calc[7:0] <= next_box_pos[7:0];
                            address_write_om <= box_row * row + box_col;
                            wren <= 1'b1;
                            state <= PROCESSING_MOVE_AFTER;
                        end else begin
                            data_write_om <= {(field_type_after == 3'b0) ? 3'd5 : 3'd6, 6'b0, 1'b0, 1'b0};
                            address_write_om <= box_row_new * row + box_col_new;
                            pos_box_calc[7:0] <= next_box_pos[7:0];
                            wren <= 1'b1;
                            state <= PROCESSING_MOVE_AFTER;
                            move_done <= 1'b1;
                        end
                    end
                PROCESSING_MOVE_AFTER:
                    begin
                        wren <= 1'b0;
                        address_write_om <= 7'd120;
                        new_state_ready <= 1'b1;
                        cooldown <= 1'b1;
                        if (move_done) begin
                            state <= WAITING_FOR_NEW_MOVE;
                        end else begin
                            state <= WAITING_FOR_OLD_MOVE;
                        end
                    end
                default: state <= WAITING_FOR_NEW_MOVE;
            endcase
        end

        if (new_state_ready) new_state_ready <= 1'b0;
        if (move_done & new_state_ready) move_done <= 1'b0;
        if (cooldown) cooldown <= 1'b0;


    end




endmodule