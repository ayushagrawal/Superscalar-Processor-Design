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
		  
		  -- From Write Back
		  in_sel1				: in std_logic_vector(2 downto 0);
		  in_sel2				: in std_logic_vector(2 downto 0);
		  in_sel3				: in std_logic_vector(2 downto 0);
		  in_sel4				: in std_logic_vector(2 downto 0);
		  input1					: in std_logic_vector(15 downto 0);
		  input2					: in std_logic_vector(15 downto 0);
		  input3					: in std_logic_vector(15 downto 0);
		  input4					: in std_logic_vector(15 downto 0);
		  wren1					: in std_logic;
		  wren2					: in std_logic;
		  wren3					: in std_logic;
		  wren4					: in std_logic
		  );
	
end entity;

architecture rFile of register_file is
	signal out3_arf,out4_arf,rrf_tag1,rrf_tag2 : std_logic_vector(15 downto 0);
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
								  in_sel1 => in_sel1,
								  in_sel2 => in_sel2,
								  in_sel3 => in_sel3,
								  in_sel4 => in_sel4,
								  input1 => input1,
								  input2 => input2,
								  input3 => input3,
								  input4 => input4,
								  wren1 => wren1,
								  wren2 => wren2,
								  wren3 => wren3,
								  wren4 => wren4,
								  
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
	
	process(out3_arf,rrf_tag1,data_dep_1)
	
	begin
	if(data_dep_1 = '0') then
		out_data3(15 downto 0) <= out3_arf;
		out_data3(16) <= validity_out(to_integer(unsigned(r1_2)))(0);
	else
		out_data3(15 downto 0) <= rrf_tag1;
		out_data3(16) <= '0';
	end if;
	end process;
	
	process(out4_arf,rrf_tag2,data_dep_2)
	
	begin
	if(data_dep_2 = '0') then
		out_data4(15 downto 0) <= out4_arf;
		out_data4(16) <= validity_out(to_integer(unsigned(r2_2)))(0);
	else
		out_data4(15 downto 0) <= rrf_tag2;
		out_data4(16) <= '0';
	end if;
	end process;
	
	-------------------------------- RENAMED REGISTER FILE -----------------------------------
	-- 1. Validity bit of a register is not changed to '0' until we receive a corresponding broadcast
	-- 2. If all the valid bits are '1' then we need to stall FETCH and DECODE
	
	
	--------------------- INTERFACING -------------------------
	rr_file : RRF  generic map(N => 32) 
						port map(reset 	 		=> reset,
									clk   	 		=> clk,										  
									validity_in  	=> rrf_valid_in,
									validity_out 	=> rrf_valid_out,
														  
									val_en_ch 		=> rrf_valid_en);
	--_________________ END INTERFACING _____________________--
	
	process(rrf_valid_out)
		variable count : integer := 0;
		variable stall,one : std_logic := '0';
	begin
		for i in 0 to 31 loop
			if(rrf_valid_out(i)(0) = '0') then		-- Implying that the entry is free
				if(count = 0) then
					count := 1;
					tag1(2 downto 0) <= std_logic_vector(to_unsigned(i,3));
				elsif(count = 1) then
					count := 2;
					tag2(2 downto 0) <= std_logic_vector(to_unsigned(i,3));
				end if;
			end if;
		end loop;
		----------- STALL LOGIC -----------
		
		if(count = 0) then
			stall := '1';
		elsif(count = 1) then
			one := '1';
		else
			one := '0';
			stall := '0';
		end if;
		stall_out <= stall;
		only_one <= one;
		
		--_______ END STALL LOGIC _______--
		
	end process;
	
	--____________________________ END RENAMED REGISTER FILE _______________________________--
	
end architecture;