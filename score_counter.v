`timescale 1ns / 1ps

module score_counter(
    input clk,
    input rst,
    input shot_tick,         // Pulse from the debouncer one_shot
    output reg [3:0] digit0, // Units (0-9)
    output reg [3:0] digit1, // Tens (0-9)
    output reg [3:0] digit2, // Hundreds (0-9)
    output reg [3:0] digit3  // Thousands (0-9)
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            digit0 <= 4'd0;
            digit1 <= 4'd0;
            digit2 <= 4'd0;
            digit3 <= 4'd0;
        end else if (shot_tick) begin
            // BCD Increment Logic
            if (digit0 == 4'd9) begin
                digit0 <= 4'd0;
                if (digit1 == 4'd9) begin
                    digit1 <= 4'd0;
                    if (digit2 == 4'd9) begin
                        digit2 <= 4'd0;
                        if (digit3 == 4'd9) begin
                            digit3 <= 4'd0; // Reset everything at 9999
                        end else begin
                            digit3 <= digit3 + 1;
                        end
                    end else begin
                        digit2 <= digit2 + 1;
                    end
                end else begin
                    digit1 <= digit1 + 1;
                end
            end else begin
                digit0 <= digit0 + 1;
            end
        end
    end

endmodule