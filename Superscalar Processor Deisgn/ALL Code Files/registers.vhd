library ieee;
use ieee.std_logic_1164.all;

entity registers is
		generic(N  : integer);
		port(input : in std_logic_vector(N-1 downto 0);
			  enable: in std_logic;
			  output: out std_logic_vector(N-1 downto 0);
			  clk   : in std_logic;
			  reset : in std_logic);
	end entity;

architecture reg of registers is
begin
	process(clk,enable,reset)
		variable data: std_logic_vector(N-1 downto 0);
	begin
		if(reset = '1') then
			data := (others => '0');
		elsif(clk'event and clk = '1' and enable = '1') then
			data := input;
		end if;
		output <= data;
	end process;
end;