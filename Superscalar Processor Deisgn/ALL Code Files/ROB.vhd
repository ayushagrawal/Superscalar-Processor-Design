library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

library work;
use work.components.all;

-- ASSUMPTION : INSTRUCTIONS CAN BE TAKEN IN MULTIPLES OF 2

entity ROB is
	generic(N : integer := 32);			-- Represents total number of entries
	port(	reset 	: in std_logic;
			clk	: in std_logic;
			stall_out : out std_logic;
			broadcast	: in main_array(0 to 4)(21 downto 0);	-- Max of 5 units can return
			-- Data 		= 16 bits
			-- Tag  		= 5  bits (RRF size)
			-- Validity = 1 bit
			-- (In the above order) --
			
			valid_in : in main_array(0 to N-1)(0 downto 0);
			valid_out : out main_array(0 to N-1)(0 downto 0);
			valid_en : in main_array(0 to N-1)(0 downto 0);
		 
			-- FROM DECODE
			 instruction1 : in std_logic_vector(21 downto 0);
			 instruction2 : in std_logic_vector(21 downto 0)
			 -- Instruction type 			: 2 bits
			 -- Register affected 			: 3 bits
			 -- Data 							: 16 bits
			 -- Validity of information 	: 1 bit
			 -- Total							: 22 bits
			 
			 -- TO DECODE
			 
		 );
		 
end entity;

architecture files of ROB is
	
	signal inst_type_in,inst_type_out : main_array(0 to N-1)(1 downto 0);
	signal rob_valid_in,rob_valid_en,rob_valid_out,rob_busy_in,rob_busy_en,rob_busy_out,inst_type_en,rob_data_en,rob_r_en : main_array(0 to N-1)(0 downto 0);
	signal rob_data_in,rob_data_out : main_array(0 to N-1)(15 downto 0);
	signal rob_r_in, rob_r_out : main_array(0 to N-1)(2 downto 0);
	signal top_in,top_out,bottom_in,bottom_out,top_add,bottom_add,top_add_one,top_add_in : std_logic_vector(natural(log2(real(N)))-1 downto 0);
	signal manage_bit_in,manage_bit_out : std_logic_vector(0 downto 0);
	signal top_en,bottom_en,manage_bit_en : std_logic;
	
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
					end generate;
	------------------ END DEFINING REGISTERS ----------------------
	
	---------- POINTER REGISTETRS ------------
	
	top_pointer : registers generic map(N => natural(log2(real(N))))
									port map(reset => reset,
												clk => clk,
												input => top_in,
												enable => top_en,
												output => top_out);
	
	bottom_pointer : registers generic map(N => natural(log2(real(N))))
										port map(reset => reset,
													clk => clk,
													input => bottom_in,
													enable => bottom_en,
													output => bottom_out);
	
	----------- TOP POINTER AND INCOMING INSTRUCTIONS' LOGIC ------------
	-- 1. This will control the top_pointer register enable bit.
	-- 2. This will make decisions based on 'instruction1' and 'instruction2'
	process(instruction1,instruction2)
	begin
		if(instruction1(0) = '1' and instruction2(0) = '1') then
			top_add(1 downto 0) <= "10";
			top_en <= '1';
			rob_busy_in(to_integer(unsigned(top_add_one))) <= "1";
			rob_busy_en(to_integer(unsigned(top_add_one))) <= "1";
			rob_busy_in(to_integer(unsigned(top_in))) <= "1";
			rob_busy_en(to_integer(unsigned(top_in))) <= "1";
		else											-- If no new valid instruction is entered, top is not updated
			top_add(1 downto 0) <= "00";
			top_en <= '0';
			rob_busy_in(to_integer(unsigned(top_add_one))) <= "0";
			rob_busy_en(to_integer(unsigned(top_add_one))) <= "0";
			rob_busy_in(to_integer(unsigned(top_in))) <= "0";
			rob_busy_en(to_integer(unsigned(top_in))) <= "0";
		end if;
		top_add <= (others => '0');
	end process;
	
	adder0 : adds generic map(N => natural(log2(real(N))))
					 port map(data1 => top_out,
								 data2 => top_add,
								 output => top_in);
	
	top_add_in <= (0 => '1',others => '0');
	
	adder1 : adds generic map(N => natural(log2(real(N))))
					 port map(data1 => top_out,
								 data2 => top_add_in,
								 output => top_add_one);
	
	--________ TOP POINTER LOGIC ENDS ______--
	
	
	----------- VALIDITY REGISTER LOGIC ------------
	-- 1. This will make decisions based on broadcast
	process(broadcast)
	
	begin
	
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
		
	end process;
	
	
	
	--________ VALIDITY REGISTER LOGIC ENDS ______--
	
	
	--------- POINTER REGISTERS END ----------
	
	--------- STALL MANAGING REGISTER --------
	
	stall_manage : registers generic map(N => 1)
										port map(reset => reset,
													clk => clk,
													input => manage_bit_in,
													enable => manage_bit_en,
													output => manage_bit_out);
	stall_out <= manage_bit_out(0);
	process(top_out,bottom_out,rob_valid_out)
	
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