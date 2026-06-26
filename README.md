\# UART Communication Protocol (Verilog HDL)



\## Overview



This project implements a \*\*UART (Universal Asynchronous Receiver Transmitter)\*\* communication protocol using \*\*Verilog HDL\*\*. The design consists of a parameterized baud rate generator, UART transmitter, UART receiver, top-level integration module, and a behavioral testbench. The project was developed and verified using \*\*Xilinx Vivado 2018.1\*\*.



\---



\## Features



\* 8-bit UART Communication

\* 1 Start Bit

\* 1 Stop Bit

\* No Parity

\* Parameterized Baud Rate Generator

\* UART Transmitter (TX)

\* UART Receiver (RX)

\* Top-Level Integration Module

\* Behavioral Testbench

\* Loopback Verification

\* Synthesizable RTL Design



\---



\## Project Structure



```text

UART\_Communication\_Protocol/

│

├── rtl/

│   ├── baud\_generator.v

│   ├── uart\_tx.v

│   ├── uart\_rx.v

│   └── uart\_top.v

│

├── tb/

│   └── uart\_tb.v

│

├── docs/

│   └── uart\_block\_diagram.png

│

└── README.md

```



\---



\## Block Diagram



!\[UART Block Diagram](docs/uart\_block\_diagram.png)



\---



\## Simulation Result



The design was successfully verified using a behavioral testbench.



\*\*Example Result\*\*



```

Sent Byte     : 0x41

Received Byte : 0x41



Simulation Status : PASS

```



\---



\## Tools Used



\* Verilog HDL

\* Xilinx Vivado 2018.1

\* Artix-7 FPGA (Target Device)



\---



\## Future Improvements



\* UART Parity Support

\* FIFO Integration

\* Configurable Stop Bits

\* AXI-Lite Interface



\---



\## Author



\*\*Divyansh Dubey\*\*



