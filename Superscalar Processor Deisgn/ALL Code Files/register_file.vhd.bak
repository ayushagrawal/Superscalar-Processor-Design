library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.components.all;

entity register_file is

	port(reset : in std_logic;
		  clk   : in std_logic;
		  stall_out : out std_logic;
		  -- From Decode
		  write_back_check1 	: in std_logic;
		  write_back_check2 	: in std_logic;
		  r1_validity_1	  	: in std_logic;
		  r2_validity_1	  	: in std_logic;
		  r1_validity_2	  	: in std_logic;
		  r2_validity_2	  	: in std_logic;
		  r1_1					: in std_logic_vector(2 downto 0);
		  r2_1					: in std_logic_vector(2 downto 0);
		  r3_1					: in std_logic_vector(2 downto 0);
		  r1_2					: in std_logic_vector(2 downto 0);
		  r2_2					: in std_logic_vector(2 downto 0);
		  r3_2					: in std_logic_vector(2 downto 0);
		  data_dep_1			: in std_logic;
		  data_dep_2			: in std_logic;
		  -- To Decode
		  out_data1				: out std_logic_vector(16 downto 0);		-- MSB is the validity bit
		  out_data2				: out std_logic_vector(16 downto 0);
		  out_data3				: out std_logic_vector(16 downto 0);
		  out_data4				: out std_logic_vector(16 downto 0);
		  
		  -- From Write Back for ARF
		  in_sel1				: in std_logic_vector(2 downto 0);
		  in_sel2				: in std_logic_vector(2 downto 0);
		  
		  input1					: in std_logic_vector(15 downto 0);
		  input2					: in std_logic_vector(15 downto 0);
		  
		  wren1					: in std_logic;
		  wren2					: in std_logic;
		  
		  -- From Execute Complete for RRF
		  broadcast				: in main_array(0 to 4)(21 downto 0)	-- Max of 5 units can return
																						-- Data 		= 16 bits
																						-- Tag  		= 5  bits (RRF size)
																						-- Validity = 1 bit
																						-- (In the above order) --
		  );
	
end entity;

architecture rFile of register_file is
	signal out3_arf,out4_arf : std_logic_vector(15 downto 0);
	signal validity_in,validity_out,val_en_ch : main_array(0 to 7)(0 downto 0);
	signal rrf_valid_in,rrf_valid_out,rrf_valid_en  : main_array(0 to 31)(0 downto 0);
	signal temp : std_logic_vector(31 downto 0);
	signal tag1,tag2 : std_logic_vector(15 downto 0);		-- Because tag size has to be equal to data size
	signal only_one : std_logic := '0';		-- Indicates that only one renamed register is available
begin
	
	tag1(15 downto 3) <= (others => '0');
	tag2(15 downto 3) <= (others => '0');
	
	ar_file : ARF port map(reset => reset,
								  clk => clk,
								  in_sel1 => in_sel1,	-- From write back
								  in_sel2 => in_sel2,	-- From write back
								  in_sel3 => r3_1,		-- From decode
								  in_sel4 => r3_2,		-- From deocde
								  
								  input1 => input1,					-- From write back
								  input2 => input2,					-- From write back
								  input3 => tag1,						-- From RRF
								  input4 => tag2,						-- From RRF
								  
								  wren1 => wren1,						-- From write back
								  wren2 => wren2,						-- From write back
								  wren3 => write_back_check1,		-- From decode (Indicates whether there is a need for renaming)
								  wren4 => write_back_check2,		-- From decode (Indicates whether there is a need for renaming)
								  
								  validity_in => validity_in,
								  validity_out => validity_out,
								  val_en_ch => val_en_ch,
								  
								  output1 => out_data1(15 downto 0),
								  output2 => out_data2(15 downto 0),
								  output3 => out3_arf,
								  output4 => out4_arf,
								  osel1 => r1_1,
								  osel2 => r2_1,
								  osel3 => r1_2,
								  osel4 => r2_2);
	
	out_data1(16) <= validity_out(to_integer(unsigned(r1_1)))(0);
	out_data2(16) <= validity_out(to_integer(unsigned(r2_1)))(0);
	
	process(out3_arf,tag1,data_dep_1,validity_out,r1_2,r2_2,broadcast,write_back_check1,write_back_check2)
		
	begin
	if(data_dep_1 = '0') then
		out_data3(15 downto 0) <= out3_arf;
		out_data3(16) <= validity_out(to_integer(unsigned(r1_2)))(0);
	else
		out_data3(15 downto 0) <= tag1;
		out_data3(16) <= '0';
	end if;
	end process;
	
	process(out4_arf,tag2,data_dep_2,validity_out,r2_2,broadcast)
	
	begin
	if(data_dep_2 = '0') then
		out_data4(15 downto 0) <= out4_arf;
		out_data4(16) <= validity_out(to_integer(unsigned(r2_2)))(0);
	else
		out_data4(15 downto 0) <= tag2;
		out_data4(16) <= '0';
	end if;
	end process;
	
	------------------------------ REORDER BUFFER ---------------------------------
	
	------------ INTERFACING ---------------
	
	reorder : ROB generic map() port map();
	
	--________ END INTERFACING ___________--
	
	--_________________________ END REORDER BUFFER ______________________________--
	
end architecture;