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
    output wire one_led,
    output wire another_led,
    output reg [2:0] leeds
);

    wire reset;

    reg wait_for_read;

    reg [9:0] address_read_bm;
	wire [10:0] data_read_bm;

    posedge_detector pd(clk, ~keys[0], reset);

    boards_memory bm(address_read_bm, data_read_bm, clk);

    initial begin
        new_game_request <= 1'b1;
        resetting <= 1'b0;
    end

    assign one_led = reset;
    assign another_led = keys[0];

    always @(posedge clk) begin
        if (reset & ~new_game_request & ~resetting) begin
            new_game_request <= 1'b1;
        end

        if (resetting) begin
            if (~wait_for_read) begin
                data_write_om <= data_read_bm;
                wren <= 1'b1;
                address_read_bm <= address_read_bm + 10'b1;
                address_write_om <= address_write_om + 7'b1;
                if (address_write_om == 7'd104) begin
                    resetting <= 1'b0;
                    new_game_ready <= 1'b1;
                end
            end else begin
                address_read_bm <= address_read_bm + 10'b1;
            end
        end else if (new_game_in_progress & ~new_game_ready) begin
            resetting <= 1'b1;
            address_read_bm <= (10'd128 * switches[2:0]);
            leeds <= switches[2:0];
            address_write_om <= -1;
            wait_for_read <= 1'b1;
        end else begin
            wren <= 1'b0;
        end

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

	reg [15:0] boards_memory [1024] /* synthesis ram_init_file = "boards_memory.mif" */;
	
	always @(posedge clk) begin
        data_read <= boards_memory[address_read][10:0];
	end

endmodule