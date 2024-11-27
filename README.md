
 # ICS3203-CAT2-Assembly-<David Kungu 136723>

## Overview
This repository contains four x86 Assembly language programs demonstrating various programming concepts:

1. **Control Flow Program**: Classifies user input numbers as POSITIVE, NEGATIVE, or ZERO using conditional jumps.
2. **Array Reversal Program**: Reverses an array of 5 integers in-place without using additional memory.
3. **Factorial Calculation Program**: Computes factorial using a modular subroutine approach.
4. **Sensor Control Simulation**: Simulates a water level monitoring system with motor and alarm controls.

## Compilation and Running

### Prerequisites
- NASM (Netwide Assembler)
- Linux environment (for system calls)

### Compilation Steps
For each program:
```bash (wsl)
nasm -f elf32 program_name.asm
ld -m elf_i386 -o program_name program_name.o
./program_name


## Challenges and Insights
Simulating ports in memory requires careful alignment and management of memory locations.
Ensuring that the program responds to edge cases (e.g., sensor value exactly at the thresholds) requires precise conditional logic.

### Control Flow Program
- Implemented multiple jump instructions to handle different number classifications
- Demonstrated how conditional and unconditional jumps control program flow

### Array Reversal
- Performed in-place reversal without additional memory allocation
- Used index manipulation to swap array elements
- Carefully managed loop conditions to prevent unnecessary iterations

### Factorial Calculation
- Used stack to preserve registers during subroutine execution
- Implemented recursive-like factorial calculation using loops
- Handled special cases for 0! and 1!

### Sensor Control Simulation
- Simulated sensor input control using memory locations
- Implemented multi-level condition checking
- Demonstrated bitwise and memory manipulation techniques

## Notes
- Programs are written for 32-bit x86 architecture
- Requires recompilation for different environments