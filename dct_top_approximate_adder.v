// Module: dct_top
// Description: This module implements a pipelined Discrete Cosine Transform (DCT) using
//              various submodules, including clock gating, dynamic scaling, LUT, adaptive LMS,
//              FIR filter, and D Flip-Flop. The module is parameterized to handle different bit widths.

module dct_top #(parameter bit_width = 16) (clk, rst, enable, data_in, dct_out);
    input clk, rst, enable;  // Clock, reset, and enable signals
    input signed [bit_width-1:0] data_in;  // Input data
    output wire signed [bit_width-1:0] dct_out;  // Output data

    wire gated_clk;  // Gated clock signal
    wire signed [bit_width-1:0] scaled_data, da_result;  // Scaled data and result from FIR filter
    wire signed [bit_width-1:0] lut_coeff0, lut_coeff1, lut_coeff2, lut_coeff3, lut_coeff4, lut_coeff5, lut_coeff6, lut_coeff7;  // Coefficients from LUT
    wire signed [bit_width-1:0] lms_coeff0, lms_coeff1, lms_coeff2, lms_coeff3, lms_coeff4, lms_coeff5, lms_coeff6, lms_coeff7;  // Coefficients from LMS
    wire signed [bit_width-1:0] coeff0, coeff1, coeff2, coeff3, coeff4, coeff5, coeff6, coeff7;  // Selected coefficients
    reg signed [bit_width-1:0] error;  // Error signal for LMS
    reg signed [bit_width-1:0] input_buffer [0:7];  // Input buffer for storing data
    integer idx;  // Index for input buffer

    // Clock gating to reduce power consumption
    clock_gating cg (.clk(clk), .enable(enable), .gated_clk(gated_clk));

    // Dynamic scaling of input data
    dynamic_scaling #(bit_width) ds (.clk(gated_clk), .rst(rst), .in_data(data_in), .scaled_data(scaled_data));

    // LUT module for coefficients
    lut_module #(bit_width) lut (
        .clk(gated_clk),
        .addr(idx[2:0]),
        .c0(lut_coeff0), .c1(lut_coeff1), .c2(lut_coeff2), .c3(lut_coeff3),
        .c4(lut_coeff4), .c5(lut_coeff5), .c6(lut_coeff6), .c7(lut_coeff7)
    );

    // Adaptive LMS module for updating coefficients
    adaptive_lms #(bit_width) adapt (
        .clk(gated_clk), .rst(rst), .error_in(error),
        .x0(input_buffer[0]), .x1(input_buffer[1]), .x2(input_buffer[2]), .x3(input_buffer[3]),
        .x4(input_buffer[4]), .x5(input_buffer[5]), .x6(input_buffer[6]), .x7(input_buffer[7]),
        .coeff0(lms_coeff0), .coeff1(lms_coeff1), .coeff2(lms_coeff2), .coeff3(lms_coeff3),
        .coeff4(lms_coeff4), .coeff5(lms_coeff5), .coeff6(lms_coeff6), .coeff7(lms_coeff7)
    );

    // Select between LUT and LMS coefficients
    assign coeff0 = (enable) ? lms_coeff0 : lut_coeff0;
    assign coeff1 = (enable) ? lms_coeff1 : lut_coeff1;
    assign coeff2 = (enable) ? lms_coeff2 : lut_coeff2;
    assign coeff3 = (enable) ? lms_coeff3 : lut_coeff3;
    assign coeff4 = (enable) ? lms_coeff4 : lut_coeff4;
    assign coeff5 = (enable) ? lms_coeff5 : lut_coeff5;
    assign coeff6 = (enable) ? lms_coeff6 : lut_coeff6;
    assign coeff7 = (enable) ? lms_coeff7 : lut_coeff7;

    // FIR filter using selected coefficients
    fir_filter #(bit_width) fir (
        .clk(gated_clk), .rst(rst),
        .x0(input_buffer[0]), .x1(input_buffer[1]), .x2(input_buffer[2]), .x3(input_buffer[3]),
        .x4(input_buffer[4]), .x5(input_buffer[5]), .x6(input_buffer[6]), .x7(input_buffer[7]),
        .coeff0(coeff0), .coeff1(coeff1), .coeff2(coeff2), .coeff3(coeff3),
        .coeff4(coeff4), .coeff5(coeff5), .coeff6(coeff6), .coeff7(coeff7),
        .y_out(da_result)
    );

    // D Flip-Flop to store the output of the FIR filter
    dff #(bit_width) dff_inst (
        .clk(gated_clk),
        .rst(rst),
        .d(da_result),
        .q(dct_out)
    );

    // Sequential logic for managing input buffer and error calculation
    always @(posedge gated_clk) begin
        if (rst) begin
            idx <= 0;  // Reset index
            error <= 0;  // Reset error
            input_buffer[0] <= 0; input_buffer[1] <= 0; input_buffer[2] <= 0; input_buffer[3] <= 0;
            input_buffer[4] <= 0; input_buffer[5] <= 0; input_buffer[6] <= 0; input_buffer[7] <= 0;
        end else begin
            input_buffer[idx] <= data_in;  // Store input data in buffer
            idx <= idx + 1;  // Increment index
            if (idx >= 7) begin
                idx <= 0;  // Reset index after reaching buffer size
                error <= data_in - da_result;  // Calculate error for LMS
            end
        end
    end
endmodule
