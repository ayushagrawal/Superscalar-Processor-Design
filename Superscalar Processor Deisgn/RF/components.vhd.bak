library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

package components is
	
	type main_array is array(natural range <>) of std_logic_vector;
	
	component registers is
		generic(N  : integer);
		port(input : in std_logic_vector(N-1 downto 0);
			  enable: in std_logic;
			  output: out std_logic_vector(N-1 downto 0);
			  clk   : in std_logic;
			  reset : in std_logic);
	end component;
	
	component multiplexer is
	
		generic(X : integer;
				  Y : integer);
		port(output : out std_logic_vector(Y-1 downto 0);
			  input  : in main_array(0 to X-1)(Y-1 downto 0);
			  sel		: in std_logic_vector(natural(log2(real(X)))-1 downto 0));

	end component;
	
	component demux is
	
		generic(X : integer;			-- NUMBER OF PORTS IN THE DEMUX
				  Y : integer);		-- DATA WIDTH OF THE DEMUX
		port(input : in std_logic_vector(Y-1 downto 0);
			  output  : out main_array(0 to X-1)(Y-1 downto 0);
			  sel		: in std_logic_vector(natural(log2(real(X)))-1 downto 0));
			  
	end component;
	
	component reorder_buffer is
	
		generic(N : integer);		-- Represets total number of entries
		port(input			: in std_logic_vector(21 downto 0);
			  wr_en			: in std_logic;								-- When writing to ROB
			  
			  clk				: in std_logic;
			  reset			: in std_logic;
			  stall			: out std_logic;
			  output			: out std_logic_vector(21 downto 0));

	end component;
	
	component ARF is
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
		
	end component;

	
end package;