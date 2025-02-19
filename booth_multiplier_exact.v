// Module: booth_multiplier_exact
// Description: This module implements an exact Booth multiplier for 8-bit inputs.
//              Booth encoding is used to efficiently multiply signed numbers.

module booth_multiplier_exact #(parameter N = 8) (
    input [N-1:0] A, B,
    output [2*N-1:0] result
);
    reg signed [2*N-1:0] partial_products [N:0];
    integer i;
    
    always @(*) begin
        for (i = 0; i < N; i = i + 1) begin
            if (B[i])
                partial_products[i] = A << i;
            else
                partial_products[i] = 0;
        end
        result = partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3] + 
                 partial_products[4] + partial_products[5] + partial_products[6] + partial_products[7];
    end
endmodule
