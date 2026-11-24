# VLSI Testing

My homework for **EE6250 VLSI Testing** (超大型積體電路測試) at National Tsing Hua University (Spring 2025). The course covers fault modeling, fault simulation, ATPG, design-for-test (scan), delay test, and built-in self-test.

- **Instructor:** Prof. Shi-Yu Huang (黃錫瑜)
- **Author:** Yu-Shuo Chang (張育碩)

## Homework at a glance

| Folder | Topic | What's inside |
|---|---|---|
| [`HW1-Accumulator-TDF-ATPG`](HW1-Accumulator-TDF-ATPG) | Transition-delay-fault ATPG in C/C++ | Gate-level 4-bit accumulator `AC = AC + X[1:0]`; compiled-code simulator for its 64-entry truth table (`Basic`); two-pattern TDF test generation with **Launch-off-Shift** (`LoS`) and **Launch-off-Capture** (`LoC`), with a fault-coverage comparison |
| [`HW2-Scan-ATPG-TetraMAX`](HW2-Scan-ATPG-TetraMAX) | Commercial DFT flow | Gate-level simulation of the accumulator, scan insertion in Design Compiler (area overhead), and ATPG in TetraMAX (patterns, fault coverage, detected/undetectable faults). Repeated for a scaled-up 33-bit `AC = AC + X[16:0]`. Random test patterns generated in Python |
| [`HW3-BIST-Speed-Grading`](HW3-BIST-Speed-Grading) | Logic BIST and built-in speed grading | Unsigned multiplier with a 6-bit LFSR pattern generator, a MISR signature analyzer, and a BIST controller FSM. The clock period is swept in 100 ps steps until the signature no longer matches the golden one, which finds the maximum operating speed. Two versions: 6-bit multiplier with 12-bit MISR, and 8-bit multiplier with 16-bit MISR |

Each folder has `report.pdf` with the full write-up and results. HW3 folders follow `hdl/` (RTL), `sim/` (testbench and run scripts), `syn/` (Design Compiler scripts).

### Selected results

- **HW1:** 20 transition-delay faults in the accumulator. LoS reaches 100% fault coverage.
- **HW2:** TetraMAX reaches 100% fault coverage on the scanned 4-bit accumulator with 10 patterns.
- **HW3:** Golden signature `12'hb05` for the 6-bit design. The BISTed multiplier passes at 1 GHz.

## Tools

- C / C++ and Python
- Verilog
- Synopsys Design Compiler (scan insertion)
- Synopsys TetraMAX (ATPG)
- Synopsys VCS

Lecture slides, homework specs, past exams, and course-provided lab files are not included.
