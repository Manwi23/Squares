module hextoseg(output [6:0] digit, input [3:0] hex);
    reg [6:0] ndigit;
    assign digit = ~ndigit;
    always @ (hex) begin
        case (hex)
            4'b0000: ndigit = 7'b0111111;
            4'b0001: ndigit = 7'b0000110;
            4'b0010: ndigit = 7'b1011011;
            4'b0011: ndigit = 7'b1001111;
            4'b0100: ndigit = 7'b1100110;
            4'b0101: ndigit = 7'b1101101;
            4'b0110: ndigit = 7'b1111101;
            4'b0111: ndigit = 7'b0000111;
            4'b1000: ndigit = 7'b1111111;
            4'b1001: ndigit = 7'b1101111;
            4'b1010: ndigit = 7'b1110111;
            4'b1011: ndigit = 7'b1111100;
            4'b1100: ndigit = 7'b0111001;
            4'b1101: ndigit = 7'b1011110;
            4'b1110: ndigit = 7'b1111001;
            4'b1111: ndigit = 7'b1110001;
            default: ndigit = 7'b1000000;
        endcase
    end
endmodule
