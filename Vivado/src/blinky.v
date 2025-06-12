module blinky (
    input wire i_clock,
    input wire i_enable,
    output wire o_led_drive
);

    // Constants
    // Equation: (clk freq (Hz) / blink freq (Hz) * 50% duty cycle) e.g. 100,000,000/2 *0.5

    localparam integer C_CNT_05HZ = 25000000;

    // Registers
    reg [25:0] r_CNT_05HZ = 0;  // 24 bits is enough for counting up to 10 million
    reg r_TOGGLE_05HZ = 0;

    // Counter and toggle logic
    always @(posedge i_clock) begin
        if (r_CNT_05HZ == C_CNT_05HZ - 1) begin
            r_CNT_05HZ <= 0;
            r_TOGGLE_05HZ <= ~r_TOGGLE_05HZ;
        end else begin
            r_CNT_05HZ <= r_CNT_05HZ + 1;
        end
    end

    // Output logic
    assign o_led_drive = (i_enable == 1'b1) ? r_TOGGLE_05HZ : 1'b0;

endmodule
