// Module: approx_multiplier
// Description: This module implements a hybrid approximate multiplier using Booth encoding
//              for exact multiplication of the most significant bits (MSBs) and an OR-AND
//              based approximation for the least significant bits (LSBs). It includes error
//              compensation logic and allows switching between exact and approximate modes.

module approx_multiplier (
    input [15:0] A, B,    // 16-bit input operands
    input mode,           // Mode: 0 = Approximate, 1 = Exact
    output [31:0] result  // 32-bit multiplication result
);
    wire [31:0] exact_result;
    wire [31:0] approx_result;

    // Exact Booth Multiplier for MSBs
    booth_multiplier_exact #(8) exact_mult (
        .A(A[15:8]), 
        .B(B[15:8]),
        .result(exact_result[31:16])
    );
    
    // Approximate OR-AND Based Multiplier for LSBs
    or_and_multiplier #(8) approx_mult (
        .A(A[7:0]), 
        .B(B[7:0]),
        .result(approx_result[15:0])
    );
    
    // Error Compensation Logic
    wire [15:0] compensation = (A[7:0] & B[7:0]) >> 4;  // Simple error correction
    
    // Final Result Selection Based on Mode
    assign result = mode ? exact_result : {exact_result[31:16], (approx_result[15:0] + compensation)};
endmodule
