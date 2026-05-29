`timescale 1ns / 1ps

module debouncer (
    input clk,          // 100MHz Basys 3 clock
    input rst,          // Reset
    input noisy_in,     // Raw signal from your IR sensor
    output reg clean_out, // Stable signal (for debugging)
    output one_shot     // A single pulse when a shot is detected
);

    // 1. Synchronizer (Prevent Metastability)
    reg sync_0, sync_1;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sync_0 <= 0;
            sync_1 <= 0;
        end else begin
            sync_0 <= noisy_in;
            sync_1 <= sync_0;
        end
    end

    // 2. Counter-based Debounce Logic (~10ms delay)
    // 100MHz clock = 10ns period. 10ms = 1,000,000 cycles.
    // 2^20 is roughly 1,048,576 (ideal for a 10ms-20ms debounce)
    reg [19:0] count;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            clean_out <= 0;
        end else begin
            if (sync_1 !== clean_out) begin
                count <= count + 1;
                if (count == 20'hFFFFF) begin // Counter full
                    clean_out <= sync_1;
                    count <= 0;
                end
            end else begin
                count <= 0;
            end
        end
    end

    // 3. Edge Detector (Creates a 1-clock-cycle pulse)
    reg clean_out_delayed;
    always @(posedge clk) begin
        clean_out_delayed <= clean_out;
    end
    
    // Pulse is high only when signal goes from Low to High
    assign one_shot = clean_out & ~clean_out_delayed;

endmodule