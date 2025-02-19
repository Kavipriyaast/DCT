// Module: dff
// Description: This module implements a D Flip-Flop with asynchronous reset.
//              The D Flip-Flop captures the input data on the rising edge of the clock
//              and holds it until the next clock edge. The reset signal initializes
//              the output to zero when active. The module is parameterized to handle
//              different bit widths.

module dff #(parameter bit_width = 16) (clk, rst, d, q);
    input clk;  // Clock signal for synchronization
    input rst;  // Asynchronous reset signal
    input signed [bit_width-1:0] d;  // Data input to be stored
    output reg signed [bit_width-1:0] q;  // Data output, which holds the stored value

    // Always block triggered on the rising edge of the clock or when reset is active
    always @(posedge clk or posedge rst) begin
        if (rst)
            // If reset is active, initialize the output to 0
            q <= 0;
        else
            // Otherwise, capture the input data and store it in the output register
            q <= d;
    end

endmodule
