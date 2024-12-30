module customMultiplier (
    input [3:0] operand1,      // First 4bit 
    input [3:0] operand2,      // Second 4bit
    output reg [7:0] product   // 8-bit result
);
    reg [7:0] accumulator;     // Accumulated product
    reg [7:0] extendedOperand; // Extended first operand to 8 bits
    reg [3:0] multiplierBits;  // Second operand as multiplier
    integer bitIndex;          // Loop index

    always @(*) begin
        accumulator = 8'b0;                
        extendedOperand = {4'b0, operand1}; 
        multiplierBits = operand2;

        for (bitIndex = 0; bitIndex < 4; bitIndex = bitIndex + 1) begin
            if (multiplierBits[0]) begin
                accumulator = accumulator + extendedOperand; // Add product
            end
            extendedOperand = extendedOperand << 1; // Shift left 
            multiplierBits = multiplierBits >> 1;   // Shift right 
        end

        product = accumulator; // Assign final result to product
    end
endmodule