// Module: dynamic_scaling
// Description: This module performs dynamic scaling on input data. 
//              It scales down the input data by performing a right arithmetic shift.
//              The module is parameterized to handle different bit widths and includes
//              a reset functionality to initialize the output.

module dynamic_scaling #(parameter bit_width = 16) (
    input clk,                      // Clock signal for synchronization
    input rst,                      // Asynchronous reset signal
    input signed [bit_width-1:0] in_data,  // Signed input data to be scaled
    output reg signed [bit_width-1:0] scaled_data  // Scaled output data
);

    // Always block triggered on the rising edge of the clock or when reset is active
    always @(posedge clk or posedge rst) begin
        if (rst)
            // If reset is active, initialize the scaled data to 0
            scaled_data <= 0;
        else
            // Otherwise, perform a right arithmetic shift on the input data
            // This effectively divides the input by 4, scaling it down
            scaled_data <= in_data >>> 2;
    end

endmodule
