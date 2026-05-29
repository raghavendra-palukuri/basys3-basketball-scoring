`timescale 1ns / 1ps

module sev_seg_driver(
    input clk,           // 100MHz Basys 3 clock
    input rst,           // Reset
    input [3:0] digit0,  // Rightmost digit (Units)
    input [3:0] digit1,  // Tens digit
    input [3:0] digit2,  // Hundreds digit
    input [3:0] digit3,  // Leftmost digit (Thousands)
    output reg [3:0] an, // Anodes (Active Low: 0 is ON)
    output reg [6:0] seg // Segments (Active Low: 0 is ON)
);

    // 1. Refresh Counter
    // We need a refresh rate of ~1kHz. 
    // 100MHz / 2^18 is roughly 380Hz per digit, which is perfect.
    reg [17:0] refresh_counter;
    
    always @(posedge clk or posedge rst) begin
        if (rst)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end

    // 2. Select which digit is active based on the top 2 bits of the counter
    wire [1:0] active_digit = refresh_counter[17:16];

    // 3. Anode Control and BCD Mux
    reg [3:0] bcd_val;
    
    always @(*) begin
        case(active_digit)
            2'b00: begin
                an = 4'b1110;      // Activate Digit 0
                bcd_val = digit0;
            end
            2'b01: begin
                an = 4'b1101;      // Activate Digit 1
                bcd_val = digit1;
            end
            2'b10: begin
                an = 4'b1011;      // Activate Digit 2
                bcd_val = digit2;
            end
            2'b11: begin
                an = 4'b0111;      // Activate Digit 3
                bcd_val = digit3;
            end
            default: begin
                an = 4'b1111;
                bcd_val = 4'd0;
            end
        endcase
    end

    // 4. BCD to 7-Segment Decoder (Active Low for Basys 3)
    // Segment mapping: {g, f, e, d, c, b, a}
    always @(*) begin
        case(bcd_val)
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010;
            4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0010000;
            4'hA: seg = 7'b0001000;
            4'hB: seg = 7'b0000011;
            4'hC: seg = 7'b1000110;
            4'hD: seg = 7'b0100001;
            4'hE: seg = 7'b0000110;
            4'hF: seg = 7'b0001110;
            default: seg = 7'b1111111;
        endcase
    end

endmodule