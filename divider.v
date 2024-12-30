module divider (
    input [3:0] a0,  // Dividend
    input [3:0] a1,  // Divisor
    output reg [3:0] quotient, // Quotient
    output reg overflow        // Division by zero flag
);
    always @(*) begin
        if (a1 == 0) begin
            quotient = 0;
            overflow = 1; // Division by zero
        end else begin
            quotient = a0 / a1;
            overflow = 0;
        end
    end
endmodule