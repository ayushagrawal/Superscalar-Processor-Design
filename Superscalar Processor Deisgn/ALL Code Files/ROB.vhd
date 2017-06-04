library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

library work;
use work.components.all;

-- ASSUMPTION : INSTRUCTIONS CAN BE TAKEN IN MULTIPLES OF 2

entity ROB is
	generic(N : integer := 32);			-- Represents total number of entries
	port(reset 	: in std_logic;
			clk	: in std_logic;
			stall_out : out std_logic;
			broadcast	: in main_array(0 to 4)(22 downto 0);	-- Max of 5 units can return
			-- Data 		= 16 bits
			-- Tag  		= 5  bits (RRF size)
			-- Validity = 1 bit
			-- (In the above order) --
		 
			-- FROM DECODE
			 instruction1 : in std_logic_vector(22 downto 0);
			 instruction2 : in std_logic_vector(22 downto 0);
			 -- If write back					: 1  bit
			 -- Instruction type 			: 2  bits
			 -- Register affected 			: 3  bits
			 -- Data/Memory Address			: 16 bits
			 -- Validity of information 	: 1  bit
			 -- Total							: 23 bits
			 
			 -- TO DECODE
			 inst1_tag : out std_logic_vector(natural(log2(real(N)))-1 downto 0);
			 inst2_tag : out std_logic_vector(natural(log2(real(N)))-1 downto 0);
			 
			 -- TO COMPLETE
			 complete1 : out std_logic_vector(37 downto 0);
			 complete2 : out std_logic_vector(37 downto 0)
			 -- If write back		 : 1  bit
			 -- Inst_type 			 : 2  bits
			 -- Register affected : 3  bits
			 -- Memory affected   : 16 bits
			 -- Data				    : 16 bits
			 -- validity		    : 1  bit
		 );
		 
end entity;

architecture files of ROB is
	
	signal inst_type_in,inst_type_out : main_array(0 to N-1)(1 downto 0);
	signal rob_valid_in,rob_valid_en,rob_valid_out,rob_busy_in,rob_busy_en,rob_busy_out,inst_type_en,rob_data_en,rob_r_en : main_array(0 to N-1)(0 downto 0);
	signal rob_data_in,rob_data_out : main_array(0 to N-1)(15 downto 0);
	signal rob_r_in, rob_r_out : main_array(0 to N-1)(2 downto 0);
	
	signal top_in,top_out,top_add_two,top_add_one,top_add_in_two,top_add_in : std_logic_vector(natural(log2(real(N)))-1 downto 0);
	signal bottom_in,bottom_out,bottom_out_one,bottom_out_two,bottom_1,bottom_2: std_logic_vector(natural(log2(real(N)))-1 downto 0);
	
	signal manage_bit_in,manage_bit_out : std_logic_vector(0 downto 0);
	signal top_en,bottom_en,manage_bit_en : std_logic;
	
	signal rob_mem_in,rob_mem_en,rob_mem_out : main_array(0 to N-1)(15 downto 0);
	
	signal rob_wb_in,rob_wb_en,rob_wb_out : main_array(0 to N-1)(0 downto 0);
	
begin
	
	-------------------- DEFINING REGISTERS ------------------------
	
	GEN_REG : for I in 0 to N-1
					generate
					INSTRUCTION_TYPE : registers generic map(N => 2)
										  port map(reset => reset,
												   clk   => clk,
												   input => inst_type_in(I),
												   enable => inst_type_en(I)(0),
												   output => inst_type_out(I));
					BUSY				 : registers generic map(N => 1)
										  port map(reset => reset,
												   clk   => clk,
												   input => rob_busy_in(I),
												   enable => rob_busy_en(I)(0),
												   output => rob_busy_out(I));
					VALIDITY 		 : registers generic map(N => 1)
										  port map(reset => reset,
												   clk   => clk,
												   input => rob_valid_in(I),
												   enable => rob_valid_en(I)(0),
												   output => rob_valid_out(I));
					DATA			 : registers generic map(N => 16)
										  port map(reset => reset,
												   clk   => clk,
												   input => rob_data_in(I),
												   enable => rob_data_en(I)(0),
												   output => rob_data_out(I));
					R_AFFECTED		 : registers generic map(N => 3)
										  port map(reset => reset,
												   clk   => clk,
												   input => rob_r_in(I),
												   enable => rob_r_en(I)(0),
												   output => rob_r_out(I));
					
					MEM_AFFECTED	 : registers generic map(N => 16)
										  port map(reset => reset,
												   clk   => clk,
												   input => rob_mem_in(I),
												   enable => rob_mem_en(I)(0),
												   output => rob_mem_out(I));
					
					IF_WB	 			 : registers generic map(N => 1)
										  port map(reset => reset,
												   clk   => clk,
												   input => rob_wb_in(I),
												   enable => rob_wb_en(I)(0),
												   output => rob_wb_out(I));
					
					end generate;
	------------------ END DEFINING REGISTERS ----------------------
	
	---------- POINTER REGISTETRS ------------
	
	-- 1. NEW INTRUCTIONS ARE ADDED WITH THE HELP OF THE TOP POINTER
	top_pointer : registers generic map(N => natural(log2(real(N))))
									port map(reset => reset,
												clk => clk,
												input => top_in,
												enable => top_en,
												output => top_out);
	
	-- 2. INSTRUCTIONS ARE COMPLETED WITH THE HELP OF BOTTOM POINTER
	bottom_pointer : registers generic map(N => natural(log2(real(N))))
										port map(reset => reset,
													clk => clk,
													input => bottom_in,
													enable => bottom_en,
													output => bottom_out);
	
	----------- TOP POINTER AND INCOMING INSTRUCTIONS' LOGIC ------------
	-- 1. This will control the top_pointer register enable bit.
	-- 2. This will make decisions based on 'instruction1' and 'instruction2'
	process(instruction1,instruction2,broadcast,top_in,top_add_one,top_add_two,top_out,rob_valid_out,bottom_out,bottom_out_one,rob_wb_out,inst_type_out,rob_r_out,rob_mem_out,rob_data_out,bottom_out_two)
	begin
		if(instruction1(0) = '1' and instruction2(0) = '1') then
			top_in <= top_add_two;
			top_en <= '1';
			inst1_tag <= top_add_one;
			inst2_tag <= top_add_two;
			rob_busy_in(to_integer(unsigned(top_add_one))) <= "1";
			rob_busy_en(to_integer(unsigned(top_add_one))) <= "1";
			-- Initially the result is invalid
			rob_valid_in(to_integer(unsigned(top_add_one))) <= "0";
			rob_valid_en(to_integer(unsigned(top_add_one))) <= "1";
			inst_type_in(to_integer(unsigned(top_add_one))) <= instruction1(21 downto 20);
			inst_type_en(to_integer(unsigned(top_add_one))) <= "1";
			rob_r_in(to_integer(unsigned(top_add_one))) <= instruction1(19 downto 17);
			rob_r_en(to_integer(unsigned(top_add_one))) <= "1";
			rob_wb_in(to_integer(unsigned(top_add_one)))(0) <= instruction1(22);
			rob_wb_en(to_integer(unsigned(top_add_one))) <= "1";
			rob_mem_in(to_integer(unsigned(top_add_one))) <= instruction1(16 downto 1);
			rob_mem_en(to_integer(unsigned(top_add_one))) <= "1";
			
			rob_busy_in(to_integer(unsigned(top_add_two))) <= "1";
			rob_busy_en(to_integer(unsigned(top_add_two))) <= "1";
			rob_valid_in(to_integer(unsigned(top_add_two))) <= "0";
			rob_valid_en(to_integer(unsigned(top_add_two))) <= "1";
			inst_type_in(to_integer(unsigned(top_add_two))) <= instruction2(21 downto 20);
			inst_type_en(to_integer(unsigned(top_add_two))) <= "1";
			rob_r_in(to_integer(unsigned(top_add_two))) <= instruction2(19 downto 17);
			rob_r_en(to_integer(unsigned(top_add_two))) <= "1";
			rob_wb_in(to_integer(unsigned(top_add_two)))(0) <= instruction2(22);
			rob_wb_en(to_integer(unsigned(top_add_two))) <= "1";
			rob_mem_in(to_integer(unsigned(top_add_two))) <= instruction2(16 downto 1);
			rob_mem_en(to_integer(unsigned(top_add_two))) <= "1";
			
		else											-- If no new valid instruction is entered, top is not updated
			top_in <= top_out;
			top_en <= '0';
			rob_busy_in(to_integer(unsigned(top_in))) <= "0";
			rob_busy_en(to_integer(unsigned(top_in))) <= "0";
			rob_busy_in(to_integer(unsigned(top_add_one))) <= "0";
			rob_busy_en(to_integer(unsigned(top_add_one))) <= "0";
			inst1_tag <= "00000";			-- Don't Care because no new instructions would be coming
			inst2_tag <= "00000";			-- Don't Care because no new instructions would be coming
		end if;
		
		rob_busy_in <= (others => (others => '0'));
		rob_busy_en <= (others => (others => '0'));
		inst_type_in <= (others => (others => '0'));
		inst_type_en <= (others => (others => '0'));
		rob_r_in	<= (others => (others => '0'));
		rob_r_en	<= (others => (others => '0'));
		rob_mem_in <= (others => (others => '0'));
		rob_mem_en <= (others => (others => '0'));
		rob_wb_in <= (others => (others => '0'));
		rob_wb_en <= (others => (others => '0'));
		
		
		-- MANAGING THE BOTTOM POINTER AND COMPLETING AN INSTRUCTION
		
		complete1(37)			   <= rob_wb_out(to_integer(unsigned(bottom_out)))(0);
		complete1(36 downto 35) <= inst_type_out(to_integer(unsigned(bottom_out)));
		complete1(35 downto 33) <= rob_r_out(to_integer(unsigned(bottom_out)));
		complete1(32 downto 17) <= rob_mem_out(to_integer(unsigned(bottom_out)));
		complete1(16 downto  1) <= rob_data_out(to_integer(unsigned(bottom_out)));
		
		complete2(37)			   <= rob_wb_out(to_integer(unsigned(bottom_out_one)))(0);
		complete2(36 downto 35) <= inst_type_out(to_integer(unsigned(bottom_out_one)));
		complete2(35 downto 33) <= rob_r_out(to_integer(unsigned(bottom_out_one)));
		complete2(32 downto 17) <= rob_mem_out(to_integer(unsigned(bottom_out_one)));
		complete2(16 downto  1) <= rob_data_out(to_integer(unsigned(bottom_out_one)));
		
		if(rob_valid_out(to_integer(unsigned(bottom_out)))(0) = '1' and rob_valid_out(to_integer(unsigned(bottom_out_one)))(0) = '1') then
			-- Implies 2 intructions are ready for completion
			complete1(0) <= '1';
			complete2(0) <= '1';
			bottom_en <= '1';
			bottom_in <= bottom_out_two;
			
		elsif(rob_valid_out(to_integer(unsigned(bottom_out)))(0) = '1') then
			-- Implies only 1 instruction is ready for completion
			complete1(0) <= '1';
			complete2(0) <= '0';
			bottom_en <= '1';
			bottom_in <= bottom_out_one;
			
		else
			-- Implies no instruction is ready for completion
			complete1(0) <= '0';
			complete2(0) <= '0';
			bottom_in <= bottom_out;
			bottom_en <= '0';
			
		end if;
		
		
		
		
		
		----------- VALIDITY REGISTER LOGIC ------------
		-- 1. This will make decisions based on broadcast
		
		if(broadcast(0)(0) = '1') then
			rob_valid_in(to_integer(unsigned(broadcast(0)(natural(log2(real(N))) downto 1))))(0) <= '1';
			rob_valid_en(to_integer(unsigned(broadcast(0)(natural(log2(real(N))) downto 1))))(0) <= '1';
			rob_data_in(to_integer(unsigned(broadcast(0)(natural(log2(real(N))) downto 1)))) <= broadcast(0)(21 downto 6);
			rob_data_en(to_integer(unsigned(broadcast(0)(natural(log2(real(N))) downto 1))))(0) <= '1';
		else
			rob_valid_en(to_integer(unsigned(broadcast(0)(natural(log2(real(N))) downto 1))))(0) <= '0';
			rob_data_en(to_integer(unsigned(broadcast(0)(natural(log2(real(N))) downto 1))))(0) <= '0';
		end if;
		if(broadcast(1)(0) = '1') then
			rob_valid_in(to_integer(unsigned(broadcast(1)(natural(log2(real(N))) downto 1))))(0) <= '1';
			rob_valid_en(to_integer(unsigned(broadcast(1)(natural(log2(real(N))) downto 1))))(0) <= '1';
			rob_data_in(to_integer(unsigned(broadcast(1)(natural(log2(real(N))) downto 1)))) <= broadcast(1)(21 downto 6);
			rob_data_en(to_integer(unsigned(broadcast(1)(natural(log2(real(N))) downto 1))))(0) <= '1';
		else
			rob_valid_en(to_integer(unsigned(broadcast(1)(natural(log2(real(N))) downto 1))))(0) <= '0';
			rob_data_en(to_integer(unsigned(broadcast(1)(natural(log2(real(N))) downto 1))))(0) <= '0';
		end if;
		if(broadcast(2)(0) = '1') then
			rob_valid_in(to_integer(unsigned(broadcast(2)(natural(log2(real(N))) downto 1))))(0) <= '1';
			rob_valid_en(to_integer(unsigned(broadcast(2)(natural(log2(real(N))) downto 1))))(0) <= '1';
			rob_data_in(to_integer(unsigned(broadcast(2)(natural(log2(real(N))) downto 1)))) <= broadcast(2)(21 downto 6);
			rob_data_en(to_integer(unsigned(broadcast(2)(natural(log2(real(N))) downto 1))))(0) <= '1';
		else
			rob_valid_en(to_integer(unsigned(broadcast(2)(natural(log2(real(N))) downto 1))))(0) <= '0';
			rob_data_en(to_integer(unsigned(broadcast(2)(natural(log2(real(N))) downto 1))))(0) <= '0';
		end if;
		if(broadcast(3)(0) = '1') then
			rob_valid_in(to_integer(unsigned(broadcast(3)(natural(log2(real(N))) downto 1))))(0) <= '1';
			rob_valid_en(to_integer(unsigned(broadcast(3)(natural(log2(real(N))) downto 1))))(0) <= '1';
			rob_data_in(to_integer(unsigned(broadcast(3)(natural(log2(real(N))) downto 1)))) <= broadcast(3)(21 downto 6);
			rob_data_en(to_integer(unsigned(broadcast(3)(natural(log2(real(N))) downto 1))))(0) <= '1';
		else
			rob_valid_en(to_integer(unsigned(broadcast(3)(natural(log2(real(N))) downto 1))))(0) <= '0';
			rob_data_en(to_integer(unsigned(broadcast(3)(natural(log2(real(N))) downto 1))))(0) <= '0';
		end if;
		if(broadcast(4)(0) = '1') then
			rob_valid_in(to_integer(unsigned(broadcast(4)(natural(log2(real(N))) downto 1))))(0) <= '1';
			rob_valid_en(to_integer(unsigned(broadcast(4)(natural(log2(real(N))) downto 1))))(0) <= '1';
			rob_data_in(to_integer(unsigned(broadcast(4)(natural(log2(real(N))) downto 1)))) <= broadcast(4)(21 downto 6);
			rob_data_en(to_integer(unsigned(broadcast(4)(natural(log2(real(N))) downto 1))))(0) <= '1';
		else
			rob_valid_en(to_integer(unsigned(broadcast(4)(natural(log2(real(N))) downto 1))))(0) <= '0';
			rob_data_en(to_integer(unsigned(broadcast(4)(natural(log2(real(N))) downto 1))))(0) <= '0';
		end if;
		
		rob_valid_in <= (others => (others => '0'));
		rob_valid_en <= (others => (others => '0'));
		rob_data_in <= (others => (others => '0'));
		rob_data_en <= (others => (others => '0'));
		
	end process;
	
	adder0 : adds generic map(N => natural(log2(real(N))))
					 port map(data1 => top_out,
								 data2 => top_add_in_two,
								 output => top_add_two);
	
	top_add_in <= (0 => '1',others => '0');
	top_add_in_two <= (1 => '1',others => '0');
	
	adder1 : adds generic map(N => natural(log2(real(N))))
					 port map(data1 => top_out,
								 data2 => top_add_in,
								 output => top_add_one);
	
	bottom_1 <= (0 => '1', others => '0');
	bottom_2 <= (1 => '1', others => '0');
	
	adder2 : adds generic map(N => natural(log2(real(N))))
					 port map(data1 => bottom_out,
								 data2 => bottom_1,
								 output => bottom_out_one);
	
	adder3 : adds generic map(N => natural(log2(real(N))))
					 port map(data1 => bottom_out,
								 data2 => bottom_2,
								 output => bottom_out_two);
	
	--________ TOP POINTER LOGIC ENDS ______--
	
	
	
	--------- POINTER REGISTERS END ----------
	
	--------- STALL MANAGING REGISTER --------
	
	stall_manage : registers generic map(N => 1)
										port map(reset => reset,
													clk => clk,
													input => manage_bit_in,
													enable => manage_bit_en,
													output => manage_bit_out);
	stall_out <= manage_bit_out(0);
	process(top_out,bottom_out,rob_busy_out)
	
	begin
		if((top_out = bottom_out) and (rob_busy_out(to_integer(unsigned(top_out)))(0) = '1')) then		-- This means false call
			manage_bit_in <= "0";
			manage_bit_en <= '1';
		elsif((top_out = bottom_out) and (rob_busy_out(to_integer(unsigned(top_out)))(0) = '0')) then
			manage_bit_in <= "1";
			manage_bit_en <= '1';
		else
			manage_bit_in <= "0";
			manage_bit_en <= '1';
		end if;
	end process;
	
	------- STALL MANAGING REGISTER END ------
	
end files;