# APB Memory RTL and Verification Project

This project implements an APB (Advanced Peripheral Bus) compliant memory module in SystemVerilog/Verilog along with a testbench for functional verification.

## 📌 Project Overview

The goal of this project is to design and verify an APB memory slave that interacts with an APB master and supports basic read and write transactions. Both RTL and verification environments are included:

* **RTL Design** (`APB_MEMORY.sv` / `APB_MEMORY.v`): Implements the APB memory logic, handling PWRITE, PSEL, PENABLE and providing data on PRDATA.
* **Testbench** (`APB_MEMORY_TB.sv` / `APB_MEMORY_TB.v`): Generates stimulus for APB read and write operations and checks correctness of data transfers.

The verification environment contains:

* Clock and reset generation
* Stimulus tasks for read and write
* Basic self-checking logic
* Simulation finish and pass/fail reporting

## ℹ️ About APB AMBA

The Advanced Peripheral Bus (APB) is a part of the AMBA (Advanced Microcontroller Bus Architecture) specification developed by ARM. It is optimized for low‐bandwidth and low‐power communication with peripheral components. APB uses a simple, non‑pipelined protocol that does not support burst transfers or complex handshaking like AHB or AXI, making it ideal for register access inside SoCs. Typical APB signals include PCLK (clock), PRESETn (reset), PSEL (select), PENABLE (enable), PWRITE (read/write control), PADDR (address), PWDATA (write data), and PRDATA (read data). APB transactions consist of two phases: setup and enable. During setup, the address and control signals are driven; during enable, data transfer occurs. This simplicity reduces design complexity and enables easier verification.

## 🛠️ Prerequisites

To run the RTL and testbench, you need:

* A SystemVerilog supported simulator (e.g., **ModelSim**, **VCS**, **QuestaSim**, etc.)
* A working command-line interface to compile and run the simulation

## ▶️ How to Run

### Using ModelSim / QuestaSim

```bash
# 1. Change directory to the project folder
cd /path/to/project

# 2. Compile the RTL and testbench files
vlog APB_MEMORY.sv APB_MEMORY_TB.sv   # (or .v depending on the version)

# 3. Run the simulation
vsim work.APB_MEMORY_TB

# 4. Open waveform (optional)
do wave.do        # if you have a waveform script
run -all
```

### Using VCS

```bash
# 1. Compile
vcs -full64 -sverilog APB_MEMORY.sv APB_MEMORY_TB.sv -l compile.log

# 2. Run
./simv -l run.log
```

## 📑 File Structure

| File                                   | Description                             |
| -------------------------------------- | --------------------------------------- |
| APB\_MEMORY.sv / APB\_MEMORY.v         | RTL implementation of APB memory module |
| APB\_MEMORY\_TB.sv / APB\_MEMORY\_TB.v | Testbench file for verification         |

## ✅ Expected Output

The simulation should print messages indicating the success of each transaction and end with a “TEST PASSED” message if all read/write operations were correctly verified.

---

If you want to extend this project, you can add:

* Coverage collection
* Assertions
* Randomized stimulus using UVM

Feel free to modify the testbench for more complex testcases.
