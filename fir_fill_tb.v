
`timescale 1ns/1ps

module tb_FIR_Filter;

    // Inputs
    reg clk;
    reg reset;
    reg signed [15:0] x_in;

    // Output
    wire signed [15:0] y_out;

    // Instantiate the FIR_Filter
    FIR_Filter uut (
        .clk(clk),
        .reset(reset),
        .x_in(x_in),
        .y_out(y_out)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    // Test stimulus
    initial begin
        $display("Time\tReset\tInput\tOutput");
        $monitor("%0dns\t%b\t%d\t%d", $time, reset, x_in, y_out);

        // Initialize signals
        clk = 0;
        reset = 1;
        x_in = 0;

        // Hold reset for a few cycles
        #12;
        reset = 0;

        // Apply step input (simulate a constant signal of value 100)
        repeat(10) begin
            x_in = 16'd100;
            #10;
        end

        // Apply pulse input (a single non-zero input followed by zeros)
        x_in = 16'd500;
        #10;
        x_in = 16'd0;
        repeat(10) #10;

        // Apply negative input
        x_in = -16'd100;
        repeat(8) #10;

        // Stop simulation
        $finish;
    end

endmodule
