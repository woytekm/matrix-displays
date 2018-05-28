module matrix_driver 
(
   input matrix_refresh_clk,
	input display_driver_clk,
	input reset,
	output reg ramclk,
	input reg [7:0] input_byte,
	output reg [15:0] mem_addr,
	output reg [3:0] m_line_addr,
	output reg m_r1,m_g1,m_b1,m_r2,m_g2,m_b2,
   output reg m_latch,
   output reg m_oe,
   output reg m_clk
);


reg [63:0] red_1 [15:0];
reg [63:0] green_1 [15:0];
reg [63:0] blue_1 [15:0];

reg [63:0] red_2 [15:0];
reg [63:0] green_2 [15:0];
reg [63:0] blue_2 [15:0];


reg [63:0] red_1_phase0 [15:0];
reg [63:0] green_1_phase0 [15:0];
reg [63:0] blue_1_phase0 [15:0];

reg [63:0] red_2_phase0 [15:0];
reg [63:0] green_2_phase0 [15:0];
reg [63:0] blue_2_phase0 [15:0];

reg [63:0] red_1_phase1 [15:0];
reg [63:0] green_1_phase1 [15:0];
reg [63:0] blue_1_phase1 [15:0];

reg [63:0] red_2_phase1 [15:0];
reg [63:0] green_2_phase1 [15:0];
reg [63:0] blue_2_phase1 [15:0];

reg [63:0] red_1_phase2 [15:0];
reg [63:0] green_1_phase2 [15:0];
reg [63:0] blue_1_phase2 [15:0];

reg [63:0] red_2_phase2 [15:0];
reg [63:0] green_2_phase2 [15:0];
reg [63:0] blue_2_phase2 [15:0];


reg [1:0] phase;

reg [3:0] line_addr_1;
reg [3:0] line_addr_2;

reg [7:0] col_addr_1;
reg [7:0] col_addr_2;


reg [1:0] clock_div_1;
reg [1:0] clock_div_2;

reg fetch_byte_u;
reg next_byte_u;
reg next_line_u;
reg ramclkzero_u;
reg ramclkone_u;

reg m_r1_p0,m_g1_p0,m_b1_p0,m_r2_p0,m_g2_p0,m_b2_p0;
reg m_r1_p1,m_g1_p1,m_b1_p1,m_r2_p1,m_g2_p1,m_b2_p1;
reg m_r1_p2,m_g1_p2,m_b1_p2,m_r2_p2,m_g2_p2,m_b2_p2;

reg fetch_byte_l;
reg next_byte_l;
reg next_line;
reg incr_addr;
reg ramclkzero_l;
reg ramclkone_l;

reg load_regs;
reg load_ram;

reg wait_state;
reg wait_cycles;

reg load_intermediate_regs;
reg set_output_lines;
reg clock_out;
reg post_clock_out;

reg display_line;

reg [15:0] wait_cntr;

reg [7:0] fetched_byte_u;
reg [15:0] curr_mem_addr_u;

reg [7:0] fetched_byte_l;
reg [15:0] curr_mem_addr_l;

reg [15:0] frame_refresh_wait_state;

reg [7:0] display_brightness;

reg get_brightness_byte;
reg get_brightness_byte_clkone;
reg get_brightness_byte_fetch;
reg get_brightness_byte_clkzero;

wire pixel_red_lineu_phase0;
wire pixel_red_lineu_phase1;
wire pixel_red_lineu_phase2;

wire pixel_green_lineu_phase0;
wire pixel_green_lineu_phase1;
wire pixel_green_lineu_phase2;

wire pixel_blue_lineu_phase0;
wire pixel_blue_lineu_phase1;
wire pixel_blue_lineu_phase2;

wire pixel_red_linel_phase0;
wire pixel_red_linel_phase1;
wire pixel_red_linel_phase2;

wire pixel_green_linel_phase0;
wire pixel_green_linel_phase1;
wire pixel_green_linel_phase2;

wire pixel_blue_linel_phase0;
wire pixel_blue_linel_phase1;
wire pixel_blue_linel_phase2;


assign pixel_red_lineu_phase0 = (fetched_byte_u[0] == 1'b1);
assign pixel_red_lineu_phase1 = (fetched_byte_u[1] == 1'b1);
assign pixel_red_lineu_phase2 = (fetched_byte_u[1:0] == 2'b11);

assign pixel_green_lineu_phase0 = (fetched_byte_u[2] == 1'b1);
assign pixel_green_lineu_phase1 = (fetched_byte_u[3] == 1'b1);
assign pixel_green_lineu_phase2 = (fetched_byte_u[3:2] == 2'b11);

assign pixel_blue_lineu_phase0 = (fetched_byte_u[4] == 1'b1);
assign pixel_blue_lineu_phase1 = (fetched_byte_u[5] == 1'b1);
assign pixel_blue_lineu_phase2 = (fetched_byte_u[5:4] == 2'b11);

assign pixel_red_linel_phase0 = (fetched_byte_l[0] == 1'b1);
assign pixel_red_linel_phase1 = (fetched_byte_l[1] == 1'b1);
assign pixel_red_linel_phase2 = (fetched_byte_l[1:0] == 2'b11);

assign pixel_green_linel_phase0 = (fetched_byte_l[2] == 1'b1);
assign pixel_green_linel_phase1 = (fetched_byte_l[3] == 1'b1);
assign pixel_green_linel_phase2 = (fetched_byte_l[3:2] == 2'b11);

assign pixel_blue_linel_phase0 = (fetched_byte_l[4] == 1'b1);
assign pixel_blue_linel_phase1 = (fetched_byte_l[5] == 1'b1);
assign pixel_blue_linel_phase2 = (fetched_byte_l[5:4] == 2'b11);

reg [15:0] phase_wait_all [2:0];
reg [15:0] phase_wait_on [2:0];


initial 
 begin
   phase <= 2'b00;
	load_intermediate_regs <= 1'b1;	
   clock_div_2 <= 2'b00;
	line_addr_1 <= 4'b0000;
	line_addr_2 <= 4'b0000;
	col_addr_1 <= 8'b00000000;
	col_addr_2 <= 8'b00000000;
	next_line <= 1'b0;
	wait_cycles <= 1'b0;
	wait_state <= 1'b0;
	curr_mem_addr_u <= 16'b0;
	curr_mem_addr_l <= 16'b0000010000000000;
	fetch_byte_u <= 1'b0;
	fetch_byte_l <= 1'b0;
	next_byte_u <= 1'b1;
	next_byte_l <= 1'b0;
	ramclkzero_u <= 1'b0;
	ramclkzero_l <= 1'b0;
	ramclkone_u <= 1'b0;
	ramclkone_l <= 1'b0;
	incr_addr <= 1'b0;
	ramclk <= 1'b0;
	set_output_lines <= 1'b0;
	clock_out <= 1'b0;
	post_clock_out <= 1'b0;
	frame_refresh_wait_state <= 16'b0;
	get_brightness_byte <= 1'b0;
   get_brightness_byte_clkone <= 1'b0;
   get_brightness_byte_fetch <= 1'b0;
   get_brightness_byte_clkzero <= 1'b0;
	display_brightness <= 8'b00000100;
 end
 

 
 
always @(posedge display_driver_clk)
 begin
 
	 //if(wait_state <= 1'b1)
	 // begin
	 //  frame_refresh_wait_state <= frame_refresh_wait_state + 16'b0000000000000001;
    //  if(frame_refresh_wait_state == 16'b0001000000000000)
	 //	  begin
	 //	    wait_state <= 1'b0;
	 //		 next_byte_u <= 1'b1;
	 //	  end
	 // end
	  
    if(curr_mem_addr_u == 16'b0000010000000001)
      begin
		 // reset state machine:
	    curr_mem_addr_u <= 16'b0;
		 curr_mem_addr_l <= 16'b0000010000000000;
	    line_addr_1 <= 4'b0000;
	    col_addr_1 <= 8'b00000000;
		 fetch_byte_u <= 1'b0;
	    fetch_byte_l <= 1'b0;
	    next_byte_u <= 1'b0;
	    next_byte_l <= 1'b0;
	    ramclkzero_u <= 1'b0;
	    ramclkzero_l <= 1'b0;
    	 ramclkone_u <= 1'b0;
	    ramclkone_l <= 1'b0;
	    incr_addr <= 1'b0;
		 get_brightness_byte <= 1'b1;
	   end
		
	 else if(get_brightness_byte == 1'b1)
	   begin
		 get_brightness_byte <= 1'b0;
	    mem_addr <= 16'b0000100000000000;
		 get_brightness_byte_clkone <= 1'b1;
      end	
	 else if(get_brightness_byte_clkone == 1'b1)
	  begin
	   get_brightness_byte_clkone <= 1'b0;
		ramclk <= 1'b1;
		get_brightness_byte_fetch <= 1'b1;
	  end	 
	 else if(get_brightness_byte_fetch == 1'b1)
	  begin
	    get_brightness_byte_fetch <= 1'b0; 
	    display_brightness <= input_byte;
		 get_brightness_byte_clkzero <= 1'b1;
	  end
	 else if(get_brightness_byte_clkzero == 1'b1)
	   begin
		  get_brightness_byte_clkzero <= 1'b0;
		  ramclk <= 1'b0; 
		  next_byte_u <= 1'b1;
		end
    else if(next_byte_u == 1'b1)
      begin    
	    next_byte_u <= 1'b0;
	    mem_addr <= curr_mem_addr_u;
		 ramclkone_u <= 1'b1;
	   end
	 else if(ramclkone_u == 1'b1)
	  begin
	   ramclkone_u <= 1'b0; 
	   ramclk <= 1'b1;
		fetch_byte_u <= 1'b1;
	  end
    else if(fetch_byte_u == 1'b1)
      begin
	    fetch_byte_u <= 1'b0;
	    fetched_byte_u <= input_byte;
	    ramclkzero_u <= 1'b1;
	   end
    else if(ramclkzero_u == 1'b1)
      begin
	    ramclkzero_u <= 1'b0;
	    ramclk <= 1'b0; 
		 curr_mem_addr_u <= curr_mem_addr_u + 16'b0000000000000001;
		 next_byte_l <= 1'b1;
	   end
	 else if(next_byte_l == 1'b1)
	  begin
	    next_byte_l <= 1'b0;
	    mem_addr <= curr_mem_addr_l;
	    ramclkone_l <= 1'b1;	  
	  end
	 else if(ramclkone_l == 1'b1)
	  begin
	   ramclkone_l <= 1'b0; 
	   ramclk <= 1'b1;
		fetch_byte_l <= 1'b1;
	  end	  
    else if(fetch_byte_l == 1'b1)
	  begin
	    fetch_byte_l <= 1'b0;
	    fetched_byte_l <= input_byte;
	    ramclkzero_l <= 1'b1;
	  end
	 else if(ramclkzero_l == 1'b1)
      begin
	    ramclkzero_l <= 1'b0;
	    ramclk <= 1'b0; 
		 curr_mem_addr_l <= curr_mem_addr_l + 16'b0000000000000001;
		 load_ram <= 1'b1;
	   end
	 else if(load_ram == 1'b1)
	  begin
	    load_ram <= 1'b0;
		 
	    red_1_phase0[line_addr_1][col_addr_1] <= pixel_red_lineu_phase0;
		 green_1_phase0[line_addr_1][col_addr_1] <= pixel_green_lineu_phase0;
       blue_1_phase0[line_addr_1][col_addr_1] <= pixel_blue_lineu_phase0;
	    red_2_phase0[line_addr_1][col_addr_1] <= pixel_red_linel_phase0;
		 green_2_phase0[line_addr_1][col_addr_1] <= pixel_green_linel_phase0;
       blue_2_phase0[line_addr_1][col_addr_1] <= pixel_blue_linel_phase0;

	    red_1_phase1[line_addr_1][col_addr_1] <= pixel_red_lineu_phase1;
		 green_1_phase1[line_addr_1][col_addr_1] <= pixel_green_lineu_phase1;
       blue_1_phase1[line_addr_1][col_addr_1] <= pixel_blue_lineu_phase1;
	    red_2_phase1[line_addr_1][col_addr_1] <= pixel_red_linel_phase1;
		 green_2_phase1[line_addr_1][col_addr_1] <= pixel_green_linel_phase1;
       blue_2_phase1[line_addr_1][col_addr_1] <= pixel_blue_linel_phase1;

	    red_1_phase2[line_addr_1][col_addr_1] <= pixel_red_lineu_phase2;
		 green_1_phase2[line_addr_1][col_addr_1] <= pixel_green_lineu_phase2;
       blue_1_phase2[line_addr_1][col_addr_1] <= pixel_blue_lineu_phase2;
	    red_2_phase2[line_addr_1][col_addr_1] <= pixel_red_linel_phase2;
		 green_2_phase2[line_addr_1][col_addr_1] <= pixel_green_linel_phase2;
       blue_2_phase2[line_addr_1][col_addr_1] <= pixel_blue_linel_phase2;
		 
       incr_addr <= 1'b1; 
	  end
    else if(incr_addr == 1'b1)
      begin
	    incr_addr <= 1'b0;
	    if(col_addr_1 < 8'b00111111)
	     begin
	      col_addr_1 <= col_addr_1 + 8'b00000001;
	     end
	    else
        begin
	      col_addr_1 <= 8'b00000000;
		   line_addr_1 <= line_addr_1 + 4'b0001;
	     end
		  //wait_state <= 1'b1;
		  next_byte_u <= 1'b1;
	   end 
	 	 
  end

always @(posedge display_driver_clk)
 begin

  case(display_brightness)
  
        8'b00000001:
		   begin
        	  phase_wait_all[2'b00] <= 16'b0000001000000000;
	        phase_wait_on[2'b00] <=  16'b0000000000000010;	 

           phase_wait_all[2'b01] <= 16'b0000010000000000;
	        phase_wait_on[2'b01] <=  16'b0000000000000100;	 

           phase_wait_all[2'b10] <= 16'b0000100000000000;
	        phase_wait_on[2'b10] <=  16'b0000000000001000;	 
          end	

		  8'b00000010: 
		   begin
        	  phase_wait_all[2'b00] <= 16'b0000001000000000;
	        phase_wait_on[2'b00] <=  16'b0000000000000100;	 

           phase_wait_all[2'b01] <= 16'b0000010000000000;
	        phase_wait_on[2'b01] <=  16'b0000000000001000;	 

           phase_wait_all[2'b10] <= 16'b0000100000000000;
	        phase_wait_on[2'b10] <=  16'b0000000000010000;	 
          end	

		  8'b00000011: 
		   begin
        	  phase_wait_all[2'b00] <= 16'b0000001000000000;
	        phase_wait_on[2'b00] <=  16'b0000000000001000;	 

           phase_wait_all[2'b01] <= 16'b0000010000000000;
	        phase_wait_on[2'b01] <=  16'b0000000000010000;	 

           phase_wait_all[2'b10] <= 16'b0000100000000000;
	        phase_wait_on[2'b10] <=  16'b0000000000100000;	 
          end	

		  8'b00000100: 
		   begin
        	  phase_wait_all[2'b00] <= 16'b0000001000000000;
	        phase_wait_on[2'b00] <=  16'b0000000000010000;	 

           phase_wait_all[2'b01] <= 16'b0000010000000000;
	        phase_wait_on[2'b01] <=  16'b0000000000100000;	 

           phase_wait_all[2'b10] <= 16'b0000100000000000;
	        phase_wait_on[2'b10] <=  16'b0000000001000000;	 
          end	

		  8'b00000101: 
		   begin
        	  phase_wait_all[2'b00] <= 16'b0000001000000000;
	        phase_wait_on[2'b00] <=  16'b0000000000100000;	 

           phase_wait_all[2'b01] <= 16'b0000010000000000;
	        phase_wait_on[2'b01] <=  16'b0000000001000000;	 

           phase_wait_all[2'b10] <= 16'b0000100000000000;
	        phase_wait_on[2'b10] <=  16'b0000000010000000;	 
          end	

		  8'b00000110: 
		   begin
        	  phase_wait_all[2'b00] <= 16'b0000001000000000;
	        phase_wait_on[2'b00] <=  16'b0000000001000000;	 

           phase_wait_all[2'b01] <= 16'b0000010000000000;
	        phase_wait_on[2'b01] <=  16'b0000000010000000;	 

           phase_wait_all[2'b10] <= 16'b0000100000000000;
	        phase_wait_on[2'b10] <=  16'b0000000100000000;	 
          end	


		  8'b00000111: 
		   begin
        	  phase_wait_all[2'b00] <= 16'b0000001000000000;
	        phase_wait_on[2'b00] <=  16'b0000000010000000;	 

           phase_wait_all[2'b01] <= 16'b0000010000000000;
	        phase_wait_on[2'b01] <=  16'b0000000100000000;	  

           phase_wait_all[2'b10] <= 16'b0000100000000000;
	        phase_wait_on[2'b10] <=  16'b0000001000000000;	 
          end	


		  8'b00001000: 
		   begin
        	  phase_wait_all[2'b00] <= 16'b0000001000000000;
	        phase_wait_on[2'b00] <=  16'b0000000100000000;	 

           phase_wait_all[2'b01] <= 16'b0000010000000000;
	        phase_wait_on[2'b01] <=  16'b0000001000000000;	 

           phase_wait_all[2'b10] <= 16'b0000100000000000;
	        phase_wait_on[2'b10] <=  16'b0000010000000000;	 
          end	
			 
   endcase
 
 end 
 
always @(posedge matrix_refresh_clk)
 begin
 
   if(col_addr_2==8'b01000000 && post_clock_out==1'b0)
    begin
      m_oe <= 1'b1;
		m_line_addr <= line_addr_2;
		m_latch <= 1'b1;				   
      col_addr_2 <= 8'b0;
      display_line <= 1'b1;
      phase <= phase + 2'b01;		
    end	  
	 
	else if(display_line == 1'b1)
    begin
	   display_line <= 1'b0;
	   m_oe <= 1'b0;
	   if(phase == 2'b11)
		 begin
         next_line <= 1'b1;
			phase <= 2'b00;
		  end 
		 else
		  begin
		   wait_cycles <= 1'b1;
		  end
    end	
	 
	else if(next_line == 1'b1)
	 begin
	  next_line <= 1'b0;
	  if(line_addr_2 < 4'b1111)
	   begin
	    line_addr_2 <= line_addr_2 + 4'b0001;
		end
	  else
	   begin
	    line_addr_2 <= 4'b0000;
		end		 
	  wait_cycles <= 1'b1;
	 end
	 
	else if(wait_cycles == 1'b1)
	 begin
	  if(wait_cntr < phase_wait_all[phase])
	   begin
	   wait_cntr <= wait_cntr + 16'b0000000000000001;
		if(wait_cntr == phase_wait_on[phase])
		  m_oe <= 1'b1;
		end
	  else
	   begin
   	  m_latch <= 1'b0;
	     wait_cntr <= 16'b0;
		  wait_cycles <= 1'b0;
		  load_intermediate_regs <= 1'b1;
		end
	 end
	 
   else if(phase==2'b00 && load_intermediate_regs==1'b1)
	 begin	
	   load_intermediate_regs <= 1'b0;
    	m_r1_p0 <= red_1_phase0[line_addr_2][col_addr_2];
	   m_g1_p0 <= green_1_phase0[line_addr_2][col_addr_2];
		m_b1_p0 <= blue_1_phase0[line_addr_2][col_addr_2];
      m_r2_p0 <= red_2_phase0[line_addr_2][col_addr_2];
      m_g2_p0 <= blue_2_phase0[line_addr_2][col_addr_2];
      m_b2_p0 <= green_2_phase0[line_addr_2][col_addr_2];			 
		set_output_lines <= 1'b1;
    end
	 
   else if(phase==2'b01 && load_intermediate_regs==1'b1)
	 begin		 
	   load_intermediate_regs <= 1'b0;
		m_r1_p1 <= red_1_phase1[line_addr_2][col_addr_2];
		m_g1_p1 <= green_1_phase1[line_addr_2][col_addr_2];
		m_b1_p1 <= blue_1_phase1[line_addr_2][col_addr_2];
		m_r2_p1 <= red_2_phase1[line_addr_2][col_addr_2]; 
		m_g2_p1 <= blue_2_phase1[line_addr_2][col_addr_2];
      m_b2_p1 <= green_2_phase1[line_addr_2][col_addr_2];
		set_output_lines <= 1'b1;
     end	
	  
  else if(phase==2'b10 && load_intermediate_regs==1'b1)
	 begin		 	  
	   load_intermediate_regs <= 1'b0;
		m_r1_p2 <= red_1_phase2[line_addr_2][col_addr_2];
	   m_g1_p2 <= green_1_phase2[line_addr_2][col_addr_2];
      m_b1_p2 <= blue_1_phase2[line_addr_2][col_addr_2];
      m_r2_p2 <= red_2_phase2[line_addr_2][col_addr_2];
      m_g2_p2 <= blue_2_phase2[line_addr_2][col_addr_2];
      m_b2_p2 <= green_2_phase2[line_addr_2][col_addr_2];			 		
		set_output_lines <= 1'b1;
    end

  else if(set_output_lines == 1'b1)
	 begin
	   set_output_lines <= 1'b0;
		case(phase)
	    2'b00: 
		   begin
     		 m_r1 <= m_r1_p0; 
		    m_g1 <= m_g1_p0;
		    m_b1 <= m_b1_p0;
	       m_r2 <= m_r2_p0;
		    m_g2 <= m_g2_p0;
		    m_b2 <= m_b2_p0;
			end
	    2'b01: 
		   begin
     		 m_r1 <= m_r1_p1; 
		    m_g1 <= m_g1_p1;
		    m_b1 <= m_b1_p1;
	       m_r2 <= m_r2_p1;
		    m_g2 <= m_g2_p1;
		    m_b2 <= m_b2_p1;
			end
	    2'b10: 
		   begin
     		 m_r1 <= m_r1_p2; 
		    m_g1 <= m_g1_p2;
		    m_b1 <= m_b1_p2;
	       m_r2 <= m_r2_p2;
		    m_g2 <= m_g2_p2;
		    m_b2 <= m_b2_p2;
			end
		endcase
      clock_out <= 1'b1;		
	 end
	 
   else if(clock_out == 1'b1)
	 begin
	   clock_out <= 1'b0;
	   m_clk <= 1'b1;
		post_clock_out <= 1'b1;
      col_addr_2 <= col_addr_2 + 8'b00000001;
	 end
	 
 	else if(post_clock_out == 1'b1)
	 begin
	   post_clock_out <= 1'b0;
	   m_clk <= 1'b0;
		load_intermediate_regs <= 1'b1;
    end
	 
 end 
  
  
 endmodule