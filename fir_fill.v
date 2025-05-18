module FIR_Filter (
    input clk,
    input reset,
    input signed [15:0] x_in,
    output reg signed [15:0] y_out
);

    // Define coefficients individually
    parameter signed [15:0] C0 = 16'd50;
    parameter signed [15:0] C1 = 16'd100;
    parameter signed [15:0] C2 = 16'd150;
    parameter signed [15:0] C3 = 16'd200;
    parameter signed [15:0] C4 = 16'd200;
    parameter signed [15:0] C5 = 16'd150;
    parameter signed [15:0] C6 = 16'd100;
    parameter signed [15:0] C7 = 16'd50;

    reg signed [15:0] shift_reg [0:7];
    reg signed [31:0] acc;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 8; i = i + 1)
                shift_reg[i] <= 16'd0;
            y_out <= 16'd0;
        end else begin
            // Shift samples
            for (i = 7; i > 0; i = i - 1)
                shift_reg[i] <= shift_reg[i - 1];
            shift_reg[0] <= x_in;

            // Multiply-Accumulate
            acc = 0;
            acc = acc + (shift_reg[0] * C0);
            acc = acc + (shift_reg[1] * C1);
            acc = acc + (shift_reg[2] * C2);
            acc = acc + (shift_reg[3] * C3);
            acc = acc + (shift_reg[4] * C4);
            acc = acc + (shift_reg[5] * C5);
            acc = acc + (shift_reg[6] * C6);
            acc = acc + (shift_reg[7] * C7);

            y_out <= acc >>> 8;
        end
    end
endmodule
