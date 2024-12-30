module operation_mux (
    input [3:0] add_result,
    input [3:0] sub_result,
    input [7:0] mul_result,
    input [3:0] div_result,
    input [1:0] op_select,  // sw[9:8]
    output reg [7:0] final_result
);
    always @(*) begin
        case (op_select)
            2'b00: final_result = {4'b0000, add_result}; // Addition
            2'b01: final_result = {4'b0000, sub_result}; // Subtraction
            2'b10: final_result = mul_result;            // Multiplication
            2'b11: final_result = {4'b0000, div_result}; // Division
            default: final_result = 8'b00000000;         // Default
        endcase
    end
endmodule