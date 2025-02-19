// Module: carry_lookahead_adder
// Description: This module implements an 8-bit carry lookahead adder. The carry lookahead adder
//              is a type of digital adder used in computer microarchitecture to improve the speed
//              by reducing the time required to calculate carry bits. It uses the concepts of
//              generate and propagate to quickly determine carry bits.

module carry_lookahead_adder(A, B, carry_in, sum, carry_out);
    input [7:0] A, B;  // 8-bit input operands
    input carry_in;    // Input carry for the least significant bit
    output [7:0] sum;  // 8-bit sum output
    output carry_out;  // Output carry from the most significant bit

    wire [7:0] p, g, c;  // Internal wires for propagate, generate, and carry bits

    // Calculate propagate and generate signals
    assign p = A ^ B;  // Propagate: if either A or B is 1, but not both
    assign g = A & B;  // Generate: if both A and B are 1

    // Calculate carry bits using carry lookahead logic
    assign c[0] = carry_in;  // Initial carry is the input carry
    assign c[1] = g[0] | (p[0] & c[0]);  // Carry for bit 1
    assign c[2] = g[1] | (p[1] & c[1]);  // Carry for bit 2
    assign c[3] = g[2] | (p[2] & c[2]);  // Carry for bit 3
    assign c[4] = g[3] | (p[3] & c[3]);  // Carry for bit 4
    assign c[5] = g[4] | (p[4] & c[4]);  // Carry for bit 5
    assign c[6] = g[5] | (p[5] & c[5]);  // Carry for bit 6
    assign c[7] = g[6] | (p[6] & c[6]);  // Carry for bit 7

    // Calculate the sum bits
    assign sum = p ^ c;  // Sum is the XOR of propagate and carry

    // Calculate the final carry out
    assign carry_out = g[7] | (p[7] & c[7]);  // Carry out from the most significant bit

endmodule
