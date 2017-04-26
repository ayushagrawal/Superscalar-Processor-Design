library ieee;
use ieee.std_logic_1164.all;

entity branch_predictor is
	port(pc		: in std_logic_vector(6 downto 0);
		  clk    : in std_logic;
		  bp_out : out std_logic_vector(6 downto 0);
		  sel		: out std_logic);
end entity;

architecture BP of branch_predictor is
begin

	-- Without any prediction
	bp_out <= "0000000";
	sel <= '0';
	-------------------------

end architecture;