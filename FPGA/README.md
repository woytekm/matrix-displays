This is my first useful Verilog project - 32x64 color LED matrix display driver with SPI interface. It's messy and not too advanced - only 64 colors (6-bit color), and even Adafruit bitbanging driver has 4096. Making it 4096 or even more color is just a question of rewriting PWM sequencing hardware so it has more stages, which is trivial. I don't need more than 64 colors at this moment, so i don't bother.

This project was made in Altera Quartus Prime 17.1. It works ok on Altera Cyclone IV E.

