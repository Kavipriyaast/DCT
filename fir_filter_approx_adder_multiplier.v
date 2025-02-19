// Module: fir_filter
// Description: This module implements an 8-tap Finite Impulse Response (FIR) filter using
//              approximate multipliers and adders for processing the inputs and coefficients.
//              The module is parameterized to handle different bit widths for the inputs
//              and coefficients.

module fir_filter #(parameter bit_width = 16) (
    input clk, rst, mode,  // Clock, reset, and mode signals
    input signed [bit_width-1:0] x0, x1, x2, x3, x4, x5, x6, x7,  // Input samples
    input signed [bit_width-1:0] coeff0, coeff1, coeff2, coeff3, coeff4, coeff5, coeff6, coeff7,  // Filter coefficients
    output reg signed [bit_width-1:0] y_out  // Filtered output
);

    wire signed [31:0] mult [0:7];  // 32-bit products of inputs and coefficients
    wire signed [31:0] sum1, sum2, sum3, sum4, final_sum;  // Intermediate and final sums
    wire carry1, carry2, carry3, carry4, carry_final;  // Carry signals for approximate adders

    // Calculate products of inputs and coefficients using approximate multipliers
    approx_multiplier mult0 (.A(x0), .B(coeff0), .mode(mode), .result(mult[0]));
    approx_multiplier mult1 (.A(x1), .B(coeff1), .mode(mode), .result(mult[1]));
    approx_multiplier mult2 (.A(x2), .B(coeff2), .mode(mode), .result(mult[2]));
    approx_multiplier mult3 (.A(x3), .B(coeff3), .mode(mode), .result(mult[3]));
    approx_multiplier mult4 (.A(x4), .B(coeff4), .mode(mode), .result(mult[4]));
    approx_multiplier mult5 (.A(x5), .B(coeff5), .mode(mode), .result(mult[5]));
    approx_multiplier mult6 (.A(x6), .B(coeff6), .mode(mode), .result(mult[6]));
    approx_multiplier mult7 (.A(x7), .B(coeff7), .mode(mode), .result(mult[7]));

    // Sum the products using approximate adders
    approximate_adder sum_stage1 (.A(mult[0][23:0]), .B(mult[1][23:0]), .carry_in(0), .sum(sum1), .carry_out(carry1));
    approximate_adder sum_stage2 (.A(mult[2][23:0]), .B(mult[3][23:0]), .carry_in(carry1), .sum(sum2), .carry_out(carry2));
    approximate_adder sum_stage3 (.A(mult[4][23:0]), .B(mult[5][23:0]), .carry_in(carry2), .sum(sum3), .carry_out(carry3));
    approximate_adder sum_stage4 (.A(mult[6][23:0]), .B(mult[7][23:0]), .carry_in(carry3), .sum(sum4), .carry_out(carry4));
    approximate_adder final_sum_stage (.A(sum1), .B(sum2), .carry_in(carry4), .sum(final_sum), .carry_out(carry_final));

    // Always block triggered on the rising edge of the clock or when reset is active
    always @(posedge clk or posedge rst) begin
        if (rst)
            y_out <= 0;  // If reset is active, initialize the output to 0
        else
            y_out <= final_sum[15:0];  // Output the lower 16 bits of the final sum
    end
endmodule
