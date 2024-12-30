module four_bit_adder_subtraction (
    input [3:0] operand1, 
    input [3:0] operand2, 
    input carryIn, 
    input operation, 
    output [4:0] result, 
    output carryOut
);
    wire [3:0] modifiedOperand;
    wire carry1, carry2, carry3;

    // Modify operand2 based on operation
    assign modifiedOperand[0] = operand2[0] ^ operation;
    assign modifiedOperand[1] = operand2[1] ^ operation;
    assign modifiedOperand[2] = operand2[2] ^ operation;
    assign modifiedOperand[3] = operand2[3] ^ operation;

    // Full adder logic for each bit
    full_adder adder0 (
        .a(operand1[0]), 
        .b(modifiedOperand[0]), 
        .cin(operation), 
        .sum(result[0]), 
        .cout(carry1)
    );
    full_adder adder1 (
        .a(operand1[1]), 
        .b(modifiedOperand[1]), 
        .cin(carry1), 
        .sum(result[1]), 
        .cout(carry2)
    );
    full_adder adder2 (
        .a(operand1[2]), 
        .b(modifiedOperand[2]), 
        .cin(carry2), 
        .sum(result[2]), 
        .cout(carry3)
    );
    full_adder adder3 (
        .a(operand1[3]), 
        .b(modifiedOperand[3]), 
        .cin(carry3), 
        .sum(result[3]), 
        .cout(carryOut)
		  
    );
	 
endmodule