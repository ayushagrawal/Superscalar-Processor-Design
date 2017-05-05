library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
library work;
use work.components.all;


entity dispatch_unit is
		generic(N : integer := 4;				-- Number of registers in the reservation station
				  X : integer := 16);			-- Size of each register
		port(clk : in std_logic;
			  reset : in std_logic;
			  -- FROM THE RESERVATION SYSTEM
			  reg_data : in main_array(0 to N-1)(X-1 downto 0);
			  -- FROM THE UPDATE UNIT
			  index_out : in main_array(0 to 4)(natural(log2(real(X)))-1 downto 0);
			  index_val : in main_array(0 to 4)(0 downto 0);
			  
			  -- TO EXECUTE
			  execute1 : out std_logic_vector(X downto 0);		-- 1 extra bit for validity
			  execute2 : out std_logic_vector(X downto 0)
			  );
	end entity;

architecture DU of dispatch_unit is
	
	signal index_inp,index_oup : main_array(0 to N-1)(natural(log2(real(N)))-1 downto 0);
	signal index_en,valid_inp,valid_oup,valid_en : main_array(0 to N-1)(0 downto 0);
	signal top_in,top_out,bottom_in,bottom_out,bottom_out_add : std_logic_vector(natural(log2(real(N)))-1 downto 0);
	signal top_en,bottom_en : std_logic;
	
begin	
	
	GEN_REG : for I in 0 to N-1
				 generate
				 BUFF_INDEX : registers generic map(N => natural(log2(real(N))))
												port map (reset => reset,
															 clk	 => clk,
															 input => index_inp(I),
															 output=> index_oup(I),
															 enable=> index_en(I)(0));
				 BUFF_VALID : registers generic map(N => 1)
												port map (reset => reset,
															 clk	 => clk,
															 input => valid_inp(I),
															 output=> valid_oup(I),
															 enable=> valid_en(I)(0));
				 end generate;
	
	top_pointer 	: registers generic map(N => natural(log2(real(N))))
										port map(reset => reset,
													clk   => clk,
													input => top_in,
													output=> top_out,
													enable=> top_en);
												
	bottom_pointer : registers generic map(N => natural(log2(real(N))))
										port map(reset => reset,
													clk   => clk,
													input => bottom_in,
													output=> bottom_out,
													enable=> bottom_en);

	---------------------------------------------------------------------------------------------
	
	adder0 : adds generic map(N => natural(log2(real(N)))) port map(data1 => bottom_out,
																						 data2 => (0 => '1',others => '0'),
																						 output => bottom_out_add);
	
	--_____________ LOGIC FOR 'TO EXECUTE' _______________--
	
	process(top_out,bottom_out,valid_oup,reg_data,index_oup)
	
	begin
		if(not((top_out = bottom_out) and valid_oup(to_integer(unsigned(bottom_out)))(0) = '0')) then
			execute1(X) <= '1';
			execute1(X-1 downto 0) <= reg_data(to_integer(unsigned(index_oup(to_integer(unsigned(bottom_out))))));
			execute2(X) <= '1';
			execute2(X-1 downto 0) <= reg_data(to_integer(unsigned(index_oup(to_integer(unsigned(bottom_out_add))))));
		else
			execute1 <= (others => '0');
			execute2 <= (others => '0');
		end if;
	end process;
	
	--------------------------------------------------------
	
end;