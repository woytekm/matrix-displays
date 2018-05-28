module true_dpram_dclk

(

	input [7:0] input_a,

	input [15:0] addr_a, addr_b,

	input we_a, clk_a, clk_b,

	output reg [7:0] output_b

);

	
	// Declare the RAM variable

	reg [7:0] ram[8192:0];

	

	// Port A

	always @ (posedge clk_a)

	begin

		if (we_a) 

		 begin
			ram[addr_a] <= input_a;
		 end

	end

	

	// Port B

	always @ (posedge clk_b)

	begin
			output_b <= ram[addr_b];
	end

	

endmodule
