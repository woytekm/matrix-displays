module ram_reader_serial 
(
   input clk,
	input sclk, reset,
	output reg sda,
	output reg ramclk,
	input reg [7:0] input_byte,
	output reg [15:0] mem_addr
);


reg [3:0] bit_counter;
reg [7:0] readed_byte;
reg [15:0] memcell_counter;
reg [2:0] sclk_reg;
reg clock_out,load_byte;

wire sclk_rising = (sclk_reg == 2'b01);
wire sclk_falling = (sclk_reg == 2'b10);

initial begin
 bit_counter <= 4'b0;
 memcell_counter <= 16'b0;
 clock_out <= 1'b0;
end


always @(posedge clk)
 begin
  sclk_reg <= {sclk_reg[1:0],sclk};
 end

always @(posedge clk or negedge reset)
 begin
  if(~reset)
    begin 
	  mem_addr <= memcell_counter;
	  ramclk <= 1'b0;
	 end
  else if(sclk_rising)
    begin
      if(bit_counter == 4'b0000)
        begin 
		   mem_addr <= memcell_counter;
         ramclk <= 1'b1;
        end			
		if(bit_counter == 4'b0001)
        begin
	      ramclk <= 1'b0;
	     end
	 end
 end
 
always @(posedge clk or negedge reset)
 begin
  if(~reset)
    begin
     bit_counter <= 4'b0;
	  memcell_counter <= 16'b0;
	  sda <= 1'b0;
	 end
  else
   begin
	if(sclk_rising)
	 begin
	  if(bit_counter == 4'b0000)
	   load_byte <= 1'b1;
	  else
	   clock_out <= 1'b1;
	 end
	else if(load_byte)
	 begin
	  readed_byte <= input_byte;
	  load_byte <= 1'b0;
	  clock_out <= 1'b1;
	 end
	else if(clock_out)
	  begin
	   clock_out <= 1'b0;
		sda <= readed_byte[bit_counter];
	   bit_counter <= bit_counter + 4'b0001;   	   
      if(bit_counter == 4'b1000)  
       begin
        bit_counter <= 4'b0000;
	     memcell_counter <= memcell_counter + 16'b0000000000000001;
		  sda <= 1'b0;
	     if(memcell_counter == 16'b0010000000000000)
	      begin
		    memcell_counter <= 16'b0;
		   end
       end	
	
	 end
	  
	 end
 end
 
 endmodule