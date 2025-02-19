// Module: fir_filter
// Description: This module implements an 8-tap Finite Impulse Response (FIR) filter.
//              The filter processes input samples using a set of coefficients to produce
//              a filtered output. The module is parameterized to handle different bit widths.

module fir_filter #(parameter bit_width = 16) (
    input clk, rst,  // Clock and reset signals
    input signed [bit_width-1:0] x0, x1, x2, x3, x4, x5, x6, x7,  // Input samples
    input signed [bit_width-1:0] coeff0, coeff1, coeff2, coeff3, coeff4, coeff5, coeff6, coeff7,  // Filter coefficients
    output reg signed [bit_width-1:0] y_out  // Filtered output
);

    // Internal registers for storing intermediate multiplication and addition results
    reg signed [bit_width-1:0] mult [0:7];  // Array to store products of inputs and coefficients
    reg signed [bit_width-1:0] add_pipe [0:6];  // Array to store intermediate sums

    // Always block triggered on the rising edge of the clock or when reset is active
    always @(posedge clk or posedge rst) begin
        if (rst)
            // If reset is active, initialize the output to 0
            y_out <= 0;
        else begin
            // Multiply each input sample by its corresponding coefficient
            mult[0] <= x0 * coeff0;
            mult[1] <= x1 * coeff1;
            mult[2] <= x2 * coeff2;
            mult[3] <= x3 * coeff3;
            mult[4] <= x4 * coeff4;
            mult[5] <= x5 * coeff5;
            mult[6] <= x6 * coeff6;
            mult[7] <= x7 * coeff7;

            // Sum the products in pairs to reduce the number of additions
            add_pipe[0] <= mult[0] + mult[1];
            add_pipe[1] <= mult[2] + mult[3];
            add_pipe[2] <= mult[4] + mult[5];
            add_pipe[3] <= mult[6] + mult[7];

            // Further sum the intermediate results
            add_pipe[4] <= add_pipe[0] + add_pipe[1];
            add_pipe[5] <= add_pipe[2] + add_pipe[3];

            // Final sum to produce the output
            y_out <= add_pipe[4] + add_pipe[5];
        end
    end

endmodule
