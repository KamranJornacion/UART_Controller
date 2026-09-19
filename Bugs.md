1. High impedence of bit counter -> and gate disconnected in netlist, looked at fan in of bit counter, somehow found the bit width mismatch


2. Smpl counter spanning too many slow clk cycles -> Timing disconnect -> frequency math incorrect, noticed skew, checked tb no skew -> likely a tooling rounding error so i specified the timing and it fixed

-> raised a flag about timing verification for rx since skew should be anticipated...


3. Weird voting behaviour (jumped from 0 ->3) but the rtl increments explicitly by 1 -> couldn't find bug in rtl -> looked into the netlist -> saw unexpected synthesis of a bunch of muxes -> decided to opt into using counter block for actual clocked registers and clean up the RTL to make the debug easier and reduce combinational logic -> debugged!

4. missing explicit ending bit -> checked shift register logic -> realized the statae machine assumptions misaligned with shift register -> need an additional shift out whenr eturning to idle as the shift register doesn't destory data when inactive -> it was updated to hold its state -> need to explicity shift out because shift in is 1.