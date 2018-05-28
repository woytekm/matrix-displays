module spi_recv 
(
	input sclk, mosi, cs, clk,
	output reg miso,
	output reg [7:0] output_byte_reversed,
	output reg [15:0] mem_addr,	
   output reg memclk,
	output reg mem_we
);


reg [7:0] output_byte;
reg [3:0] bit_counter;
reg [15:0] memcell_counter;
reg [2:0] sclk_reg;
reg [3:0] bit_reverser;

wire sclk_rising = (sclk_reg == 2'b01);
wire sclk_falling = (sclk_reg == 2'b10);


// reverse bits in output byte to change from MSB to LSB (RPi can't do hardware SPI in LSB mode)
			
assign output_byte_reversed[0] = output_byte[7];
assign output_byte_reversed[1] = output_byte[6];
assign output_byte_reversed[2] = output_byte[5];
assign output_byte_reversed[3] = output_byte[4];
assign output_byte_reversed[4] = output_byte[3];
assign output_byte_reversed[5] = output_byte[2];
assign output_byte_reversed[6] = output_byte[1];
assign output_byte_reversed[7] = output_byte[0];


initial begin
 bit_counter <= 4'b0;
 memcell_counter <= 16'b0;
 mem_we <= 1'b1;
end


always @(posedge clk)
 begin
  sclk_reg <= {sclk_reg[1:0],sclk};
 end

 
always @(posedge clk or posedge cs)
 begin
 if(cs)
   begin
    bit_counter <= 4'b0;
 	 memcell_counter <= 16'b0;
	 miso <= 1'b0;
  end
  
 else 

 begin
 
  if(sclk_falling)
   begin
	 miso <= mosi;
	end
  else if(sclk_rising)
   begin  
    miso <= mosi;
    output_byte[bit_counter] <= mosi;
    bit_counter <= bit_counter + 4'b0001;
    if(bit_counter > 4'b0110)
     begin
      mem_addr <= memcell_counter;
      memclk <= 1'b1;	
      memcell_counter <= memcell_counter + 16'b0000000000000001;
      bit_counter <= 4'b0000;	 
     end
  
    if(bit_counter == 4'b0001)
     begin
 	   memclk <= 1'b0;
	  end
    if(memcell_counter == 8192)
     begin
 	   memcell_counter <= 0; 
	  end 
	  
    end
	 
   end

  end
 
 endmodule
 
