module calculator (
    input clk,
    input [9:0] sw,           
    input [1:0] key,          
    output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, 
    output reg overflow,      
    output led,               // Green LED output
    output reg red_led        // Red LED output (Arduino_IO6)
);
    // Input signals
    wire [3:0] a0 = sw[3:0];   // First number
    wire [3:0] a1 = sw[7:4];   // Second number
    wire [1:0] op_select = sw[9:8]; // Operation selection

    // Intermediate results
    wire [3:0] add_sub_result; // Result for addition/subtraction
    wire [3:0] div_result;     // Result for division
    wire [7:0] multi_result;   // Result for multiplication
    wire add_sub_overflow;     // Overflow flag for addition/subtraction
    wire div_overflow;         // Overflow flag for division

    reg [7:0] result;          // Final result for display
    wire [7:0] display_value;  // Value to display (from memory or result)
    reg [7:0] memory;          // Internal memory for saved value

    // Memory-related signals
    wire save_mem = ~key[0] && key[1];   // Save memory (short press key[0])
    wire clear_mem = ~key[0] && ~key[1]; // Clear memory (long press key[0])
    wire read_mem = ~key[1];             // Read memory (key[1])

    // Tens and units for display
    wire [3:0] a0_tens, a0_units; 
    wire [3:0] a1_tens, a1_units;
    wire [3:0] result_tens, result_units;

    // Instantiate the adder/subtractor module
    four_bit_adder_subtraction addSub (
        .operand1(a0), 
        .operand2(a1), 
        .carryIn(op_select[0]), 
        .operation(op_select[0]), 
        .result(add_sub_result), 
        .carryOut(add_sub_overflow) 
    );

    // Instantiate the multiplier module
    customMultiplier multi (
        .operand1(a0), 
        .operand2(a1), 
        .product(multi_result)
    );

    // Instantiate the divider module
    divider div (
        .a0(a0), 
        .a1(a1), 
        .quotient(div_result), 
        .overflow(div_overflow)
    );

    // Instantiate the LED control module
    LEDControl led_control (
        .display_value(display_value),  // Connect the display value
        .led(led)                       // Green LED control signal
    );

    // Memory-related functionality
    always @(posedge clk) begin
        // Handle memory save and clear
        if (clear_mem) begin
            memory <= 8'b0;       // Clear memory
            red_led <= 1'b0;      // Turn off red LED when memory is cleared
        end else if (save_mem) begin
            memory <= result;     // Save current result to memory
        end

        // Handle red LED control
        if (read_mem) begin
            red_led <= 1'b1;      // Turn on red LED when memory is read
        end else if (clear_mem) begin
            red_led <= 1'b0;      // Ensure red LED turns off when clearing memory
        end else if (!read_mem) begin
            red_led <= 1'b0;      // Default state: Red LED off
        end
    end

    // Operation selection logic
    always @(*) begin
        case (op_select)
            2'b00: result = {4'b0000, add_sub_result};  
            2'b01: result = {4'b0000, add_sub_result};  
            2'b10: result = multi_result;              
            2'b11: result = {4'b0000, div_result};     
            default: result = 8'b00000000;             
        endcase
    end

    // Display logic
    assign display_value = read_mem ? memory : result;

    // Overflow logic
    always @(*) begin
        case (op_select)
            2'b10: overflow = (result > 8'd99); 
            2'b11: overflow = div_overflow;     
            default: overflow = add_sub_overflow; 
        endcase
    end

    // Split inputs and result into tens and units for display
    assign a0_tens = a0 / 10;   
    assign a0_units = a0 % 10;  
    assign a1_tens = a1 / 10;   
    assign a1_units = a1 % 10;  
    assign result_tens = display_value / 10; 
    assign result_units = display_value % 10; 

    // Seven-segment display connections
    seven_segment_decoder display_a0_tens (.binary(a0_tens), .seg(HEX5));
    seven_segment_decoder display_a0_units (.binary(a0_units), .seg(HEX4));
    seven_segment_decoder display_a1_tens (.binary(a1_tens), .seg(HEX3));
    seven_segment_decoder display_a1_units (.binary(a1_units), .seg(HEX2));
    seven_segment_decoder display_result_tens (.binary(result_tens), .seg(HEX1));
    seven_segment_decoder display_result_units (.binary(result_units), .seg(HEX0));
endmodule
