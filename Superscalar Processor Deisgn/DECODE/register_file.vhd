library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.components.all;

entity register_file is

	port(reset : in std_logic;
		  clk   : in std_logic;
		  in_sel1: in std_logic_vector(2 downto 0);
		  in_sel2 : in std_logic_vector(2 downto 0);
		  input1 : in std_logic_vector(15 downto 0);
		  input2 : in std_logic_vector(15 downto 0);
		  wren1 : in std_logic;
		  wren2 : in std_logic;
		  
		  out_val1 : out std_logic;
		  out_val2 : out std_logic;
		  out_val3 : out std_logic;
		  out_val4 : out std_logic;
		  
		  out1	 : out std_logic_vector(15 downto 0);
		  out2	 : out std_logic_vector(15 downto 0);
		  out3	 : out std_logic_vector(15 downto 0);
		  out4	 : out std_logic_vector(15 downto 0);
		  
		  osel1	 : in std_logic_vector(2 downto 0);
		  osel2	 : in std_logic_vector(2 downto 0);
		  osel3	 : in std_logic_vector(2 downto 0);
		  osel4	 : in std_logic_vector(2 downto 0);
		  
		  rden1	 : in std_logic;
		  rden2	 : in std_logic;
		  rden3	 : in std_logic;
		  rden4	 : in std_logic;
		  
		  toWrite1 : in std_logic_vector(2 downto 0);
		  toWrite2 : in std_logic_vector(2 downto 0);
		  wr1		  : in std_logic;			-- Tells if toWrite1 is valid or not
		  wr2		  : in std_logic			-- Tells if toWrite2 is valid or not
		  );
	
end entity;

architecture rFile of register_file is
	signal out3_arf,out4_arf : std_logic_vector(15 downto 0);
	signal validity_in,validity_out,val_en_ch : main_array(0 to 7)(0 downto 0);
begin
	
	ar_file : ARF port map(reset => reset,
								  clk => clk,
								  in_sel1 => in_sel1,
								  in_sel2 => in_sel2,
								  input1 => input1,
								  input2 => input2,
								  wren1 => wren1,
								  wren2 => wren2,
								  
								  validity_in => validity_in,
								  validity_out => validity_out,
								  val_en_ch => val_en_ch,
								  
								  output1 => out1,
								  output2 => out2,
								  output3 => out3_arf,
								  output4 => out4_arf,
								  osel1 => osel1,
								  osel2 => osel2,
								  osel3 => osel3,
								  osel4 => osel4);
	
	process(wr1,wr2,rden1,rden2,rden3,rden4,toWrite1,toWrite2,out3_arf,out4_arf,osel3,osel4)
	variable out3v,out4v : std_logic_vector(15 downto 0);
	begin
		-- 1. OUTPUT registers for the first instructions are independent
		-- 2. Need to compare the select pins of 2nd instruction input registers to output register of 1st instruction
		
		if(wr1 = '1') then	-- This means that the 1st instruction needs to write back
			if(rden3 = '1' and osel3 = toWrite1) then
				-- dependency code
			else
				out3v := out3_arf;
			end if;
			if(rden4 = '1' and osel4 = toWrite1) then
				-- dependency code
			else
				out4v := out4_arf;
			end if;
			validity_in(to_integer(unsigned(toWrite1))) <= "0";
			val_en_ch(to_integer(unsigned(toWrite1))) <= "0";
		end if;
		
		if(wr2 = '1') then
			validity_in(to_integer(unsigned(toWrite2))) <= "0";
			val_en_ch(to_integer(unsigned(toWrite2))) <= "0";
		end if;
		
		out3 <= out3v;
		out4 <= out4v;
		validity_in <= ((others => (others => '1')));
		val_en_ch <= ((others => (others => '1')));
	end process;

end architecture;