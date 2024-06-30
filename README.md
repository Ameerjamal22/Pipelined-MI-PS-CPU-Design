# 16-bit Pipelined MIPS CPU

## Overview
This project presents the design and implementation of a 16-bit pipelined RISC processor with a comprehensive instruction set architecture (ISA). The processor is capable of executing a variety of arithmetic, logical, memory access, and control flow operations efficiently using a 5-stage pipeline. This repository contains the complete Verilog implementation, simulation testbenches, and detailed documentation.

## Features
- **16-bit Instruction Set Architecture (ISA)**
  - Supports R-type, I-type, J-type, and S-type instructions
  - Four instruction formats with a shared opcode field
- **5-stage Pipeline**
  - Stages: Fetch, Decode, Execute, Memory Access, Write-back
  - Separate data and instruction memories
  - Byte-addressable memory using little-endian byte ordering
- **Eight 16-bit General-purpose Registers**
  - R0 is hardwired to zero
  - 16-bit program counter (PC)
- **Arithmetic Logic Unit (ALU)**
  - Handles arithmetic and logical operations
  - Generates zero, carry, and overflow flags for branch outcomes
- **Hazard Handling Mechanisms**
  - Effective hazard detection and resolution to maintain pipeline efficiency

## Implementation Details
The processor design process involved creating a detailed datapath and control path. Key components include:

- **Datapath Components**
  - General-purpose registers, PC, ALU, data and instruction memory
- **Control Path**
  - Main control unit, ALU control, PC control
- **Pipeline Control Units**
  - Instruction fetch (IF), decode (ID), execute (EX), memory access (MEM), write-back (WB)
  - Hazard control unit

## Verification
The verification process involved developing a comprehensive testbench and multiple code sequences to ensure the processor's correctness and completeness. Simulation results confirmed that the processor accurately executes the instruction set, with snapshots of the simulator validating the implementation.

## Project Structure
- **src/**: Contains the Verilog source files for the CPU design
- **test/**: Includes the testbenches and simulation scripts
- **docs/**: Detailed project report and documentation

## Getting Started
clone the repo, then open and the code and run using active hdl . 

### Prerequisites
- Verilog simulator (e.g., ModelSim, VCS)
- Git

### Clone the Repository
```bash
git clone https://github.com/yourusername/16-bit-pipelined-mips-cpu.git
cd 16-bit-pipelined-mips-cpu
