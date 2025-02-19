// Module: lut_module
// Description: This module implements a Look-Up Table (LUT) that outputs a set of coefficients
//              based on a 3-bit address input. The LUT is parameterized to handle different
//              bit widths for the coefficients. The coefficients are updated on the rising
//              edge of the clock signal.

module lut_module #(parameter bit_width = 16) (
    input clk,                      // Clock signal for synchronization
    input [2:0] addr,               // 3-bit address input to select the coefficient set
    output reg signed [bit_width-1:0] c0, c1, c2, c3, c4, c5, c6, c7  // Output coefficients
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        // Select the set of coefficients based on the address input
        case(addr)
            3'b000: {c0, c1, c2, c3, c4, c5, c6, c7} = {16'sd32767, 16'sd0, 16'sd0, 16'sd0, 16'sd0, 16'sd0, 16'sd0, 16'sd0}; // Pass-through
            3'b001: {c0, c1, c2, c3, c4, c5, c6, c7} = {16'sd8192, 16'sd8192, 16'sd8192, 16'sd8192, 16'sd8192, 16'sd8192, 16'sd8192, 16'sd8192}; // Simple averaging
            3'b010: {c0, c1, c2, c3, c4, c5, c6, c7} = {16'sd16384, 16'sd8192, 16'sd4096, 16'sd2048, 16'sd1024, 16'sd512, 16'sd256, 16'sd128}; // Low-pass filter
            3'b011: {c0, c1, c2, c3, c4, c5, c6, c7} = {16'sd128, 16'sd256, 16'sd512, 16'sd1024, 16'sd2048, 16'sd4096, 16'sd8192, 16'sd16384}; // High-pass filter
            3'b100: {c0, c1, c2, c3, c4, c5, c6, c7} = {16'sd4096, 16'sd8192, 16'sd16384, 16'sd8192, 16'sd4096, 16'sd2048, 16'sd1024, 16'sd512}; // Band-pass filter
            3'b101: {c0, c1, c2, c3, c4, c5, c6, c7} = {16'sd512, 16'sd1024, 16'sd2048, 16'sd4096, 16'sd8192, 16'sd16384, 16'sd8192, 16'sd4096}; // Band-stop filter
            3'b110: {c0, c1, c2, c3, c4, c5, c6, c7} = {16'sd1024, 16'sd2048, 16'sd4096, 16'sd8192, 16'sd4096, 16'sd2048, 16'sd1024, 16'sd512}; // Smoothing filter
            3'b111: {c0, c1, c2, c3, c4, c5, c6, c7} = {16'sd256, 16'sd512, 16'sd1024, 16'sd2048, 16'sd4096, 16'sd8192, 16'sd4096, 16'sd2048}; // Custom filter
            default: {c0, c1, c2, c3, c4, c5, c6, c7} = 0;  // Default case sets all coefficients to 0
        endcase
    end

endmodule
