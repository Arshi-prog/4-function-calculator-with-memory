module MemoryUnit (
    input wire clk,                  // System clock
    input wire reset,                // System reset
    input wire key0,                 // Key 0 for save/clear
    input wire key1,                 // Key 1 for read
    input wire [7:0] current_result, // Current result to save (Hex1 and Hex0 combined)
    output reg [7:0] memory_result,  // Saved result to recall
    output reg memory_clear          // Indicates if memory is cleared
);
    reg [31:0] hold_counter;         // Counter for key0 hold duration

    initial begin
        memory_result = 8'b0;
        memory_clear = 1'b0;
        hold_counter = 32'b0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            memory_result <= 8'b0;
            memory_clear <= 1'b0;
            hold_counter <= 32'b0;
        end else begin
            // Handle key0 (Save and Clear)
            if (key0) begin
                hold_counter <= hold_counter + 1;
                if (hold_counter >= 32'd500000000) begin // Assuming 50MHz clock for ~10 seconds
                    memory_result <= 8'b0;
                    memory_clear <= 1'b1;
                end else begin
                    memory_clear <= 1'b0;
                end
            end else if (hold_counter > 0 && hold_counter < 32'd500000000) begin
                memory_result <= current_result; // Save result
                memory_clear <= 1'b0;
                hold_counter <= 32'b0;
            end

            // Handle key1 (Read)
            if (key1) begin
                memory_clear <= 1'b0; // Ensure clear flag is reset
            end
        end
    end
endmodule
