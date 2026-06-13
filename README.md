# Async FIFO with SystemVerilog Assertions

## Architecture
- Depth: 16, Width: 8-bit, parameterized
- Dual clock domain (2:1 ratio tested)
- Gray code pointers with 2-FF synchronizers for CDC
- Full/empty detection using Cummings 2002 methodology

## Modules
| Module | Description |
|---|---|
| async_fifo_top | Top level, full/empty logic |
| gray_counter | N+1 bit binary+gray pointer |
| sync_gray | 2-FF CDC synchronizer |
| fifo_mem | Dual-port RAM |

## Verification
- 3 SVA assertions: overflow, underflow, empty-after-reset
- Tested: write-to-full, drain-to-empty, 2:1 clock ratio

## Tools
Vivado 2024, SystemVerilog
