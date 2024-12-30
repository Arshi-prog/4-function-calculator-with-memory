# DE10-Lite 4-Function Calculator with Memory

This project implements a 4-function calculator (addition, subtraction, multiplication, and division) with memory functionality on the DE10-Lite FPGA board. The result is displayed on a seven-segment display.

## Features
- **Arithmetic operations:** Add, Subtract, Multiply, Divide
- **Memory functions:** Save result, Read result
- **Error detection:** Includes handling for division by zero

## Hardware
- **FPGA:** DE10-Lite Board
- **Display:** Seven-segment display
- **Inputs:** Switches and buttons on the board

## Files in this Repository
Here are the main Verilog modules included in this project:

1. **`calculator.v`** - Main module that coordinates all operations.
2. **`customMultiplier.v`** - Handles 4-bit multiplication.
3. **`divider.v`** - Implements division and handles division-by-zero errors.
4. **`four_bit_adder_subtractor.v`** - Performs addition and subtraction using four-bit full adders.
5. **`full_adder.v`** - Basic building block for addition operations.
6. **`memory_unit.v`** - Module for saving and retrieving results.
7. **`operation_mux.v`** - Multiplexer to select between arithmetic operations.
8. **`seven_segment_decoder.v`** - Converts binary output to seven-segment display format.

## Project Highlights
This project demonstrates:
- **Digital arithmetic design** using Verilog.
- **Sequential logic** for memory functionality.
- **Practical FPGA implementation** for embedded systems.
