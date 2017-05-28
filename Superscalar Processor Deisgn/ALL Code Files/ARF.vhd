-- INTERFACING WITH REGISTER FILE:
--	1. It will receive the index of the registers demanded from the respective instructions.
-- 2. Due to the architecture, there can be a maximum of 4 demands, therefore 4 output ports are required.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library work;
use work.components.all;

entity ARF is
	port(reset : in std_logic;
		  clk   : in std_logic;
		  
		  in_sel1 : in std_logic_vector(2 downto 0);
		  in_sel2 : in std_logic_vector(2 downto 0);
		  in_sel3 : in std_logic_vector(2 downto 0);
		  in_sel4 : in std_logic_vector(2 downto 0);
		  
		  --
		  input1 : in std_logic_vector(15 downto 0);
		  input2 : in std_logic_vector(15 downto 0);
		  input3 : in std_logic_vector(15 downto 0);
		  input4 : in std_logic_vector(15 downto 0);
		  wren1 : in std_logic;
		  wren2 : in std_logic;
		  wren3 : in std_logic;
		  wren4 : in std_logic;
		  
		  validity_in : in main_array(0 to 7)(0 downto 0);
		  
		  val_en_ch : in main_array(0 to 7)(0 downto 0);	-- DEFAULT is '1' ;change to 0 indicate action to be performed
		  
		  -- TO THE REGISTER FILE
		  -- MSB is the validity of the data
		  output1 : out std_logic_vector(16 downto 0);
		  output2 : out std_logic_vector(16 downto 0);
		  output3 : out std_logic_vector(16 downto 0);
		  output4 : out std_logic_vector(16 downto 0);
		  
		  -- FROM REGISTER FILE
		  osel1	 : in std_logic_vector(2 downto 0);
		  osel2	 : in std_logic_vector(2 downto 0);
		  osel3	 : in std_logic_vector(2 downto 0);
		  osel4	 : in std_logic_vector(2 downto 0));
	
end entity;

architecture files of ARF is
	
	signal data_out : main_array(0 to 7)(15 downto 0);	-- CONTAINS OUTPUT OF EACH REGISTER
	signal input : main_array(0 to 7)(15 downto 0);		-- CONTAINS INPUT FOR EACH REGISTER
	signal enable_data : main_array(0 to 7)(0 downto 0);
	signal validity_out : main_array(0 to 7)(0 downto 0);

begin
	
	----------------- REGISTERS ARE DEFINED HERE --------------------------
	-- 1. VALIDITY AND DATA REGISTERS ARE DEFINED SEPERATELY
	-- 2. TAG IS CONSIDERED INTERNALLY DURING THE DECODING
	
	-- DEFINING DATA REGISTERS
	GEN_REG : for I in 0 to 7 
				 generate
				 REGX : registers generic map(N => 16) 
										port map(reset => reset,
													clk	=> clk,
													input => input(I),
													output => data_out(I),
													enable => enable_data(I)(0));
				 VALD : registers generic map(N => 1)
										port map(reset	=> reset,
													clk	=> clk,
													input => validity_in(I),
													output => validity_out(I),
													enable => val_en_ch(I)(0));
				end generate;
	----------------------------------------------------------------------
	
	-------------	DEFINING THE 4 OUTPUT PORTS' LOGIC --------------------
	
	mux1 : multiplexer generic map(X => 8, Y => 16)			-- (NUM_PORTS,DATA_WIDTH)
							 port map(output => output1(15 downto 0),
										 input  => data_out,
										 sel	  => osel1);
										 
	output1(16) <= validity_out(to_integer(unsigned(osel1)))(0);
	
	mux2 : multiplexer generic map(X => 8, Y => 16) 
							 port map(output => output2(15 downto 0),
										 input  => data_out,
										 sel	  => osel2);
	
	output2(16) <= validity_out(to_integer(unsigned(osel2)))(0);
	
	mux3 : multiplexer generic map(X => 8, Y => 16) 
							 port map(output => output3(15 downto 0),
										 input  => data_out,
										 sel	  => osel3);
	
	output3(16) <= validity_out(to_integer(unsigned(osel3)))(0);
	
	mux4 : multiplexer generic map(X => 8, Y => 16) 
							 port map(output => output4(15 downto 0),
										 input  => data_out,
										 sel	  => osel4);
										 
	output4(16) <= validity_out(to_integer(unsigned(osel4)))(0);
										 
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@--
	
	-------------------------- DECODER LOGIC -----------------------------
	----------------------- FOR DATA-REGISTERS ---------------------------
	
	
	process(in_sel1,in_sel2,in_sel3,in_sel4,input1,input2,input3,input4,wren1,wren2,wren3,wren4)
		variable inp : main_array(0 to 7)(15 downto 0) := ((others => (others => '0')));
		begin
		-- It will be ensured by the WRITE-BACK STAGE that in_sel1 and in_sel2 are different
		inp(to_integer(unsigned(in_sel1))) := input1;
		inp(to_integer(unsigned(in_sel2))) := input2;
		inp(to_integer(unsigned(in_sel3))) := input3;
		inp(to_integer(unsigned(in_sel4))) := input4;
		inp := ((others => (others => '0')));
		input <= inp;
		
		----------------------- CONTROLLING DATA WRITE -----------------------
	
		enable_data(to_integer(unsigned(in_sel1)))(0) <= wren1;
		enable_data(to_integer(unsigned(in_sel2)))(0) <= wren2;
		enable_data(to_integer(unsigned(in_sel3)))(0) <= wren3;
		enable_data(to_integer(unsigned(in_sel4)))(0) <= wren4;
		enable_data <= ((others => (others => '0')));
		
		----------------------------------------------------------------------
		end process;
	
	-------------------------------------------------------------------------
	
	
	
end files;