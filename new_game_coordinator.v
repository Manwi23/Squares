module new_game_coordinator (
    output reg [6:0] address_write_om,
	output reg [10:0] data_write_om,
	output reg wren,
    input wire [3:0] keys,
    input wire [9:0] switches,
    output reg new_game_request,
    input new_game_in_progress,
    output reg resetting,
    output reg new_game_ready,
    input clk, 
    output [1:0] leds
);

    wire reset;

    reg wait_for_read;

    reg [9:0] address_read_bm;
	wire [10:0] data_read_bm;

    reg [1:0] state;
    parameter WAITING_FOR_REQUEST_APPROVAL = 0;
    parameter PERFORMING_RESET = 1;
    parameter DOING_NOTHING = 2;

    initial begin
        new_game_request <= 1'b1;
        resetting <= 1'b0;
        state <= WAITING_FOR_REQUEST_APPROVAL;
    end

    posedge_detector pd(clk, ~keys[0], reset);

    boards_memory bm(address_read_bm, data_read_bm, clk);

    assign leds = state;
    
    always @(posedge clk) begin
        case (state)
            WAITING_FOR_REQUEST_APPROVAL:
                begin
                    if (new_game_in_progress) begin
                        address_read_bm <= (10'd128 * switches[2:0]);
                        resetting <= 1'b1;
                        address_write_om <= -1;
                        wait_for_read <= 1'b1;
                        state <= PERFORMING_RESET;
                    end
                end
            PERFORMING_RESET:
                begin
                    if (~wait_for_read) begin
                        data_write_om <= data_read_bm;
                        wren <= 1'b1;
                        address_read_bm <= address_read_bm + 10'b1;
                        address_write_om <= address_write_om + 7'b1;
                        if (address_write_om == 7'd103) begin
                            resetting <= 1'b0;
                            new_game_ready <= 1'b1;
                            state <= DOING_NOTHING;
                        end
                    end else begin
                        address_read_bm <= address_read_bm + 10'b1;
                    end
                end
            DOING_NOTHING:
                begin
                    wren <= 1'b0;
                    if (reset) begin
                        new_game_request <= 1'b1;
                        state <= WAITING_FOR_REQUEST_APPROVAL;
                    end
                end
            default: state <= WAITING_FOR_REQUEST_APPROVAL;
        endcase

        if (wait_for_read) wait_for_read <= 1'b0;
        if (new_game_ready) new_game_ready <= 1'b0;
        if (new_game_request) new_game_request <= 1'b0;
    end


endmodule


module boards_memory(
	input [9:0] address_read,
	output reg [10:0] data_read,
	input clk
);

    wire [10:0] longer_stuff; 

	reg [7:0] boards_mem [1024] /* synthesis ram_init_file = "boards_memory.mif" */;
	
    assign longer_stuff = boards_mem[address_read];

	always @(posedge clk) begin
        data_read <= longer_stuff[7:7] ? (longer_stuff[6:0]) : (longer_stuff[2:0] << 8); 
    end

endmodule