Color LED matrix display driver. It consists of two parts: Verilog code for FPGA driver with SPI interface, and C code driving FPGA project via SPI from SBC.
I am able to get more than 40 FPS from one segment 32x64 panel driven from RPi B+ with hardware SPI at 4Mhz using libbcm2835 bulk SPI transfers.

