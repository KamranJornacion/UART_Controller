# UART Controller v1

This is an in-progress UART design built to learn the protocol and practice RTL design.

## 1. General design

The project is a small UART wrapper with separate TX and RX paths:

- `rtl/UART_top.v` - top-level module
- `rtl/tx.v` - transmitter
- `rtl/rx.v` - receiver
- `rtl/piso_shift_reg.v` and `rtl/sipo_shift_reg.v` - serial/parallel shift logic

The design is a parameterized-width UART, currently exercised with an 8-bit data path. TX loads parallel data on a rising-edge transmit request and shifts it out serially. RX uses a 16x sampling clock, detects a falling-edge start condition, checks the start bit with a voting mechanism, shifts in the serial bits, and presents the recovered byte.

The implementation uses state machines, edge detection, sampling counters, a start-bit voting counter, and shift registers. TX and RX use separate clock inputs, with clock-domain handling planned as the design evolves.

## 2. Rough work and design process

The design was driven by the rough project notes in `specs` and the main design doc: `UART controller spec.pdf`.

The v1 design targets:

- one TX and one RX
- separate TX and RX clocks, with RX currently using a 16x sampling clock
- parameterized data width, currently exercised with an 8-bit data path
- idle high, start bit low
- TX and RX treated as separate functional blocks controlled externally

RX start-bit voting and 16x sampling are part of the current implementation. More complete frame validation, buffering, parity, and broader verification are planned next.

## 3. Functional verification

The design was sanity-checked with a simple SystemVerilog testbench:

- `simulation/questa/tb/UART_top_tb.sv`

The testbench drives a known 8-bit pattern through TX and exercises the RX path with a single byte. TX and RX single-byte behavior has been verified, including recovery of the expected byte. Burst traffic, false starts, malformed frames, randomized data, and assertions are covered in the planned verification work.

It validates the current core behavior: serializing one byte out and deserializing one byte back in.

## Next steps

The next planned verification and feature work is:

1. Test RX handling of false starts and verify the start-bit voting mechanism.
2. Test RX handling of incorrect frame structures.
3. Test RX bursting: determine whether it can handle multiple subsequent frames separated by a single stop bit.
4. Improve coverage with randomized TX/RX data packets and functional assertions.
5. Add parity-bit functionality.
6. Add caching functionality.
7. Add RX stop-bit verification and frame-error flagging.
