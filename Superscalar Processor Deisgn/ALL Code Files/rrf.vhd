library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;


library work;
use work.components.all;

entity RRF is
	generic(N : integer := 32);				-- Represents total number of registers
	port(reset 	 		: in std_logic;
		  clk   	 		: in std_logic;
		  
		  validity_in  : in  main_array(0 to N-1)(0 downto 0);
		  validity_out : out main_array(0 to N-1)(0 downto 0);
		  
		  val_en_ch 	: in main_array(0 to N-1)(0 downto 0));	-- DEFAULT is '1' ;change to 0 indicate action to be performed
		  
end entity;

architecture files of RRF is
	
	signal data_out : main_array(0 to N-1)(15 downto 0);	-- CONTAINS OUTPUT OF EACH REGISTER
	signal input : main_array(0 to N-1)(15 downto 0);		-- CONTAINS INPUT FOR EACH REGISTER
	signal enable_data : main_array(0 to N-1)(0 downto 0);

begin
	
	----------------- REGISTERS ARE DEFINED HERE --------------------------
	-- 1. VALIDITY AND DATA REGISTERS ARE DEFINED SEPERATELY
	-- 2. TAG IS CONSIDERED INTERNALLY DURING THE DECODING
	
	-- DEFINING DATA REGISTERS
	GEN_REG : for I in 0 to N-1 
				 generate
				 VALD : registers generic map(N => 1)
										port map(reset	=> reset,
													clk	=> clk,
													input => validity_in(I),
													output => validity_out(I),
													enable => val_en_ch(I)(0));
				end generate;	
	
end files;