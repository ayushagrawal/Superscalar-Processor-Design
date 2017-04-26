library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.components.all;

entity ARF is
	port(reset : in std_logic;
		  clk   : in std_logic;
		  in_sel1: in std_logic_vector(2 downto 0);
		  in_sel2 : in std_logic_vector(2 downto 0);
		  input1 : in std_logic_vector(15 downto 0);
		  input2 : in std_logic_vector(15 downto 0);
		  wren1 : in std_logic;
		  wren2 : in std_logic;
		  
		  validity_in : in main_array(0 to 7)(0 downto 0);
		  validity_out : out main_array(0 to 7)(0 downto 0);
		  
		  val_en_ch : in main_array(0 to 7)(0 downto 0);	-- DEFAULT is '1' ;change to 0 indicate action to be performed
		  
		  output1 : out std_logic_vector(15 downto 0);
		  output2 : out std_logic_vector(15 downto 0);
		  output3 : out std_logic_vector(15 downto 0);
		  output4 : out std_logic_vector(15 downto 0);
		  osel1	 : in std_logic_vector(2 downto 0);
		  osel2	 : in std_logic_vector(2 downto 0);
		  osel3	 : in std_logic_vector(2 downto 0);
		  osel4	 : in std_logic_vector(2 downto 0));
	
end entity;

architecture files of ARF is
	
	signal data_out : main_array(0 to 7)(15 downto 0);	-- CONTAINS OUTPUT OF EACH REGISTER
	signal input : main_array(0 to 7)(15 downto 0);		-- CONTAINS INPUT FOR EACH REGISTER
	signal enable_data : main_array(0 to 7)(0 downto 0);
	
	signal valid_out : main_array(0 to 7)(0 downto 0);
	signal valid_in : main_array(0 to 7)(0 downto 0);
	signal enable_vld : main_array(0 to 7)(0 downto 0);

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
													input => valid_in(I),
													output => valid_out(I),
													enable => enable_vld(I)(0));
				end generate;
	----------------------------------------------------------------------
	
	-------------	DEFINING THE 4 OUTPUT PORTS' LOGIC --------------------
	
	mux1 : multiplexer generic map(X => 8, Y => 16) 
							 port map(output => output1,
										 input  => data_out,
										 sel	  => osel1);
	
	mux2 : multiplexer generic map(X => 8, Y => 16) 
							 port map(output => output2,
										 input  => data_out,
										 sel	  => osel2);
	
	mux3 : multiplexer generic map(X => 8, Y => 16) 
							 port map(output => output3,
										 input  => data_out,
										 sel	  => osel3);
	
	mux4 : multiplexer generic map(X => 8, Y => 16) 
							 port map(output => output4,
										 input  => data_out,
										 sel	  => osel4);
	----------------------------------------------------------------------
	
	-------------------------- DECODER LOGIC -----------------------------
	----------------------- FOR DATA-REGISTERS ---------------------------
	
	
	process(in_sel1,in_sel2,input1,input2,wren1,wren2)
		variable inp : main_array(0 to 7)(15 downto 0) := ((others => (others => '0')));
		begin
		-- It will be ensured by the WRITE-BACK STAGE that in_sel1 and in_sel2 are different
		inp(to_integer(unsigned(in_sel1))) := input1;
		inp(to_integer(unsigned(in_sel2))) := input2;
		inp := ((others => (others => '0')));
		input <= inp;
		
		----------------------- CONTROLLING DATA WRITE -----------------------
	
		enable_data(to_integer(unsigned(in_sel1)))(0) <= wren1;
		enable_data(to_integer(unsigned(in_sel2)))(0) <= wren2;
		enable_data <= ((others => (others => '0')));
		
		----------------------------------------------------------------------
		end process;
	
	----------------------------------------------------------------------
	
	-------------- TRACKING THE VALIDITY OF THE REGISTERS ----------------
	
	-- 1. It will be ensured by the WRITE-BACK STAGE that in_sel1 and in_sel2 are different
	-- 2. Validity does not change if a register is read
	-- 3. Validity changes from:
	--		(i)  1 -> 0 if there is pending register write to it
	--		(ii) 0 -> 1 if the register write is completed
	
	-- 4. Priority is given to external write on validity => This is beacuse external write is latest
	
	process(wren1, wren2,validity_in,in_sel1,in_sel2,valid_out,val_en_ch)
		variable temp_val_in : main_array(0 to 7)(0 downto 0);
		variable en_vld : main_array(0 to 7)(0 downto 0);
		begin
			temp_val_in := ((others => (others => '0')));
			temp_val_in(to_integer(unsigned(in_sel1)))(0) := wren1 or validity_in(to_integer(unsigned(in_sel1)))(0);		-- ON WRITING TO A REGISTER IT BECOMES VALID
			--valid_in <= temp_val_in;
			en_vld(to_integer(unsigned(in_sel1)))(0) := wren1;
			
			
			temp_val_in(to_integer(unsigned(in_sel2)))(0) := wren2 or validity_in(to_integer(unsigned(in_sel2)))(0);		-- ON WRITING TO A REGISTER IT BECOMES VALID
			valid_in(0) <= temp_val_in(0) and val_en_ch(0);		-- PRIORITY IS AUTOMATICALLY IMPLEMENTED
			valid_in(1) <= temp_val_in(1) and val_en_ch(1);		-- PRIORITY IS AUTOMATICALLY IMPLEMENTED
			valid_in(2) <= temp_val_in(2) and val_en_ch(2);		-- PRIORITY IS AUTOMATICALLY IMPLEMENTED
			valid_in(3) <= temp_val_in(3) and val_en_ch(3);		-- PRIORITY IS AUTOMATICALLY IMPLEMENTED
			valid_in(4) <= temp_val_in(4) and val_en_ch(4);		-- PRIORITY IS AUTOMATICALLY IMPLEMENTED
			valid_in(5) <= temp_val_in(5) and val_en_ch(5);		-- PRIORITY IS AUTOMATICALLY IMPLEMENTED
			valid_in(6) <= temp_val_in(6) and val_en_ch(6);		-- PRIORITY IS AUTOMATICALLY IMPLEMENTED
			valid_in(7) <= temp_val_in(7) and val_en_ch(7);		-- PRIORITY IS AUTOMATICALLY IMPLEMENTED
			
			en_vld(to_integer(unsigned(in_sel2)))(0) := wren2;
			
			validity_out <= valid_out;
			
			
			en_vld := ((others => (others => '0')));
			-- JUST A WAY TO MANAGE MULTI-DIMENSIONAL ARRAYS
			enable_vld(0) <= en_vld(0) or (not val_en_ch(0));
			enable_vld(1) <= en_vld(1) or (not val_en_ch(1));
			enable_vld(2) <= en_vld(2) or (not val_en_ch(2));
			enable_vld(3) <= en_vld(3) or (not val_en_ch(3));
			enable_vld(4) <= en_vld(4) or (not val_en_ch(4));
			enable_vld(5) <= en_vld(5) or (not val_en_ch(5));
			enable_vld(6) <= en_vld(6) or (not val_en_ch(6));
			enable_vld(7) <= en_vld(7) or (not val_en_ch(7));
		end process;

	----------------------------------------------------------------------
	
	
	
end files;