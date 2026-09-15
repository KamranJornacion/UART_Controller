# UART Controller v1

This is a first-pass UART design built to learn the protocol and practice RTL design. It is intentionally simple and meant as a learning version, not a production-ready implementation.

## 1. General design

The project is a small UART wrapper with separate TX and RX paths:

- `rtl/UART_top.v` - top-level module
- `rtl/tx.v` - transmitter
- `rtl/rx.v` - receiver
- `rtl/piso_shift_reg.v` and `rtl/sipo_shift_reg.v` - serial/parallel shift logic

The design is an 8-bit UART with a common-clock assumption for v1. TX loads parallel data and shifts it out serially. RX detects the start condition, shifts in the serial bits, and presents the recovered byte.

This is a simple state-machine-based implementation using edge detection and shift registers, which makes it easy to understand and modify while learning the UART protocol.

## 2. Rough work and design process

The design was driven by the rough project notes in `specs` and the main design doc: `UART controller spec.pdf`.

The spec for v1 is intentionally minimal:

- one TX and one RX
- common clock assumption
- 8-bit data path for the learning target
- idle high, start bit low
- optional parity and wider frame support left for later
- TX and RX treated as separate functional blocks controlled externally

The spec also notes future improvements that were intentionally left out of v1, including better RX timing, oversampling, CDC, and more robust framing support. That makes the scope clear: this is a learning-focused first iteration, not a final implementation.

## 3. Functional verification

The design was sanity-checked with a simple SystemVerilog testbench:

- `simulation/questa/tb/UART_top_tb.sv`

The testbench drives a known 8-bit pattern, enables TX, checks the serial output behavior, then exercises the RX path and verifies the recovered byte. This is a basic functional check, not rigorous verification.

It validates the core behavior needed for a first pass: serializing data out and deserializing data back in.

## Future work

This is v1 of the design. I want to improve it by:

- using a more realistic RX sampling rate
- adding oversampling or baud-driven RX timing
- adding CDC logic for asynchronous domains
- writing a simple SDC file for Quartus timing constraints
- extending the design toward the optional features mentioned in the spec

This project is meant to be a clear, simple UART learning design that can evolve into a more realistic implementation later.
