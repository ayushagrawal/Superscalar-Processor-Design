library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

library work;
use work.components.all;

entity ROB is
	generic(N : integer := 32);			-- Represents total number of entries
	port(reset 	: in std_logic;
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
		 -- Instruction type 		: 2 bits
		 -- Validity of information : 1 bit
		 -- Register affected 		: 3 bits
		 -- Data 					: 16 bits
		 -- Total					: 22 bits
		 );
		 
end entity;

architecture files of ROB is
	
	signal inst_type_in,inst_type_out : main_array(0 to N-1)(1 downto 0);
	signal rob_valid_in,rob_valid_en,rob_valid_out,inst_type_en,rob_data_en,rob_r_en : main_array(0 to N-1)(0 downto 0);
	signal rob_data_in,rob_data_out : main_array(0 to N-1)(15 downto 0);
	signal rob_r_in, rob_r_out : main_array(0 to N-1)(2 downto 0);
	signal top_in,top_out,bottom_in,bottom_out : std_logic_vector(natural(log2(real(N)))-1 downto 0);
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
		if((top_out = bottom_out) and (rob_valid_out(to_integer(unsigned(top_out)))(0) = '0')) then		-- This means false call
			manage_bit_in <= "0";
			manage_bit_en <= '1';
		elsif((top_out = bottom_out) and (rob_valid_out(to_integer(unsigned(top_out)))(0) = '0')) then
			manage_bit_in <= "1";
			manage_bit_en <= '1';
		else
			manage_bit_in <= "0";
			manage_bit_en <= '0';
		end if;
	end process;
	
	------- STALL MANAGING REGISTER END ------
	
end files;