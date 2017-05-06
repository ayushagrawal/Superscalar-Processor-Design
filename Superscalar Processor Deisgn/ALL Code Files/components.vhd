library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

package components is
	
	type main_array is array(natural range <>) of std_logic_vector;
	
	component adds is
		generic(N : integer := 32);			-- Arbit number
		port(data1 : in std_logic_vector(N-1 downto 0);
			  data2 : in std_logic_vector(N-1 downto 0);
			  output : out std_logic_vector(N-1 downto 0));
			 
	end component;
	
	component comparator is
		generic (tag_size : integer := 5;
					tag_num : integer := 16);
		port (to_match : in main_array(0 to 4)(tag_size downto 0);
				tag_data : in main_array(0 to tag_num-1)(tag_size-1 downto 0);
				busy		: in main_array(0 to tag_num-1)(0 downto 0);
				index		: out main_array(0 to 4)(natural(log2(real(tag_num)))-1 downto 0);
				valid		: out main_array(0 to 4)(0 downto 0));		
	end component;
	
	component dispatch_unit is
		generic(N : integer := 4;				-- Number of registers in the reservation station
				  X : integer := 62);			-- Size of each register
		port(clk : in std_logic;
			  reset : in std_logic;
			  -- FROM THE RESERVATION SYSTEM
			  reg_data : in main_array(0 to N-1)(X-1 downto 0);
			  
			  -- FROM THE UPDATE UNIT
			  index_out : in main_array(0 to 4)(natural(log2(real(N)))-1 downto 0);
			  index_val : in main_array(0 to 4)(0 downto 0);
			  
			  -- TO ALLOCATE
			  index_allocate : out main_array(0 to 1)(natural(log2(real(N)))-1 downto 0);
			  valid_allocate : out main_array(0 to 1)(0 downto 0);
			  
			  -- TO EXECUTE
			  execute1 : out std_logic_vector(62 downto 0);		-- 1 extra bit for validity
			  execute2 : out std_logic_vector(62 downto 0)
			  );
	end component;	
	
	component instruction_memory IS
		PORT
		(
			address_a		: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
			address_b		: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
			clock		: IN STD_LOGIC  := '1';
			data_a		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			data_b		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			wren_a		: IN STD_LOGIC  := '0';
			wren_b		: IN STD_LOGIC  := '0';
			q_a		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
			q_b		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
		);
	END component;
	
	component mux2 is 
		generic (N : integer);
		port( in0,in1 : in std_logic_vector(N-1 downto 0); 
				sel : in std_logic; 
				output : out std_logic_vector(N-1 downto 0));
	end component;
	
	component inc IS
		PORT
		(
			data0x		: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
			data1x		: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
			result		: OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
		);
	END component;
	
	component branch_predictor is
		port(pc		: in std_logic_vector(6 downto 0);
			  clk		: in std_logic;
			  bp_out : out std_logic_vector(6 downto 0);
			  sel 	: out std_logic);
	end component;
	
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
			  in_sel3: in std_logic_vector(2 downto 0);
			  in_sel4 : in std_logic_vector(2 downto 0);
			  input1 : in std_logic_vector(15 downto 0);
			  input2 : in std_logic_vector(15 downto 0);
			  input3 : in std_logic_vector(15 downto 0);
			  input4 : in std_logic_vector(15 downto 0);
			  wren1 : in std_logic;
			  wren2 : in std_logic;
			  wren3 : in std_logic;
			  wren4 : in std_logic;
			  
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