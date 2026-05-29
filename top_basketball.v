`timescale 1ns / 1ps

module top_basketball(
    input clk,              // Pin W5 (100MHz)
    input btnC,             // Pin U18 (Center Button for Reset)
    input sensor_in,        // Pin J1 (Pmod JB - adjust as needed)
    output [3:0] an,        // Anodes for 7-seg
    output [6:0] seg        // Segments for 7-seg
);

    // Internal wires for connecting modules
    wire clean_tick;
    wire [3:0] d0, d1, d2, d3;

    // 1. Instantiate Debouncer
    // Connects the raw sensor input to a clean pulse
    debouncer unit_debounce (
        .clk(clk),
        .rst(btnC),
        .noisy_in(sensor_in),
        .clean_out(),       // Unused
        .one_shot(clean_tick)
    );

    // 2. Instantiate Score Counter
    // Connects the debounced pulse to the decimal digits
    score_counter unit_counter (
        .clk(clk),
        .rst(btnC),
        .shot_tick(clean_tick),
        .digit0(d0),
        .digit1(d1),
        .digit2(d2),
        .digit3(d3)
    );

    // 3. Instantiate 7-Segment Driver
    // Connects the 4 digits to the physical pins
    sev_seg_driver unit_display (
        .clk(clk),
        .rst(btnC),
        .digit0(d0),
        .digit1(d1),
        .digit2(d2),
        .digit3(d3),
        .an(an),
        .seg(seg)
    );

endmodule