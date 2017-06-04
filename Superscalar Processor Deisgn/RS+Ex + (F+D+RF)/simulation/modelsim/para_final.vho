-- Copyright (C) 2017  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel MegaCore Function License Agreement, or other 
-- applicable license agreement, including, without limitation, 
-- that your use is for the sole purpose of programming logic 
-- devices manufactured by Intel and sold by Intel or its 
-- authorized distributors.  Please refer to the applicable 
-- agreement for further details.

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 17.0.0 Build 595 04/25/2017 SJ Lite Edition"

-- DATE "06/04/2017 07:17:43"

-- 
-- Device: Altera EP4CE6F17C6 Package FBGA256
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY CYCLONEIVE;
LIBRARY IEEE;
USE CYCLONEIVE.CYCLONEIVE_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	hard_block IS
    PORT (
	devoe : IN std_logic;
	devclrn : IN std_logic;
	devpor : IN std_logic
	);
END hard_block;

-- Design Ports Information
-- ~ALTERA_ASDO_DATA1~	=>  Location: PIN_C1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_FLASH_nCE_nCSO~	=>  Location: PIN_D2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_DCLK~	=>  Location: PIN_H1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_DATA0~	=>  Location: PIN_H2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_nCEO~	=>  Location: PIN_F16,	 I/O Standard: 2.5 V,	 Current Strength: 8mA


ARCHITECTURE structure OF hard_block IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL \~ALTERA_ASDO_DATA1~~padout\ : std_logic;
SIGNAL \~ALTERA_FLASH_nCE_nCSO~~padout\ : std_logic;
SIGNAL \~ALTERA_DATA0~~padout\ : std_logic;
SIGNAL \~ALTERA_ASDO_DATA1~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_FLASH_nCE_nCSO~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_DATA0~~ibuf_o\ : std_logic;

BEGIN

ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
END structure;


LIBRARY CYCLONEIVE;
LIBRARY IEEE;
USE CYCLONEIVE.CYCLONEIVE_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	para_final IS
    PORT (
	clk : IN std_logic;
	reset : IN std_logic;
	in_sel1 : IN std_logic_vector(2 DOWNTO 0);
	in_sel2 : IN std_logic_vector(2 DOWNTO 0);
	input1 : IN std_logic_vector(15 DOWNTO 0);
	input2 : IN std_logic_vector(15 DOWNTO 0);
	wren1 : IN std_logic;
	wren2 : IN std_logic;
	complete1 : OUT std_logic_vector(37 DOWNTO 0);
	complete2 : OUT std_logic_vector(37 DOWNTO 0)
	);
END para_final;

-- Design Ports Information
-- clk	=>  Location: PIN_R14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- reset	=>  Location: PIN_R9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_sel1[0]	=>  Location: PIN_F6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_sel1[1]	=>  Location: PIN_N6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_sel1[2]	=>  Location: PIN_L4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_sel2[0]	=>  Location: PIN_R3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_sel2[1]	=>  Location: PIN_B16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_sel2[2]	=>  Location: PIN_D8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input1[0]	=>  Location: PIN_E11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input1[1]	=>  Location: PIN_P9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input1[2]	=>  Location: PIN_F10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input1[3]	=>  Location: PIN_K10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input1[4]	=>  Location: PIN_M8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input1[5]	=>  Location: PIN_A8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input1[6]	=>  Location: PIN_F1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input1[7]	=>  Location: PIN_E10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input1[8]	=>  Location: PIN_N5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input1[9]	=>  Location: PIN_A15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input1[10]	=>  Location: PIN_B11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input1[11]	=>  Location: PIN_C3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input1[12]	=>  Location: PIN_J13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input1[13]	=>  Location: PIN_R11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input1[14]	=>  Location: PIN_A10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input1[15]	=>  Location: PIN_F13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input2[0]	=>  Location: PIN_P15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input2[1]	=>  Location: PIN_F5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input2[2]	=>  Location: PIN_D14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input2[3]	=>  Location: PIN_P3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input2[4]	=>  Location: PIN_L3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input2[5]	=>  Location: PIN_P6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input2[6]	=>  Location: PIN_E9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input2[7]	=>  Location: PIN_T6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input2[8]	=>  Location: PIN_C6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input2[9]	=>  Location: PIN_D12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input2[10]	=>  Location: PIN_D11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input2[11]	=>  Location: PIN_A11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input2[12]	=>  Location: PIN_J15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input2[13]	=>  Location: PIN_R16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input2[14]	=>  Location: PIN_F7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- input2[15]	=>  Location: PIN_T13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- wren1	=>  Location: PIN_B8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- wren2	=>  Location: PIN_L12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[0]	=>  Location: PIN_J12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[1]	=>  Location: PIN_N1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[2]	=>  Location: PIN_K9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[3]	=>  Location: PIN_T12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[4]	=>  Location: PIN_C8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[5]	=>  Location: PIN_N2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[6]	=>  Location: PIN_R10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[7]	=>  Location: PIN_A14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[8]	=>  Location: PIN_B9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[9]	=>  Location: PIN_T11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[10]	=>  Location: PIN_M6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[11]	=>  Location: PIN_M7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[12]	=>  Location: PIN_K16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[13]	=>  Location: PIN_F8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[14]	=>  Location: PIN_N8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[15]	=>  Location: PIN_D15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[16]	=>  Location: PIN_E6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[17]	=>  Location: PIN_B14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[18]	=>  Location: PIN_J16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[19]	=>  Location: PIN_L10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[20]	=>  Location: PIN_A2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[21]	=>  Location: PIN_A7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[22]	=>  Location: PIN_R12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[23]	=>  Location: PIN_T10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[24]	=>  Location: PIN_K15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[25]	=>  Location: PIN_D1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[26]	=>  Location: PIN_B4,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[27]	=>  Location: PIN_N15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[28]	=>  Location: PIN_N14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[29]	=>  Location: PIN_D6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[30]	=>  Location: PIN_B1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[31]	=>  Location: PIN_N9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[32]	=>  Location: PIN_N16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[33]	=>  Location: PIN_B13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[34]	=>  Location: PIN_T7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[35]	=>  Location: PIN_K12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[36]	=>  Location: PIN_N11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete1[37]	=>  Location: PIN_P2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[0]	=>  Location: PIN_K6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[1]	=>  Location: PIN_N13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[2]	=>  Location: PIN_R13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[3]	=>  Location: PIN_P11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[4]	=>  Location: PIN_B6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[5]	=>  Location: PIN_P1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[6]	=>  Location: PIN_F15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[7]	=>  Location: PIN_L9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[8]	=>  Location: PIN_L8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[9]	=>  Location: PIN_M12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[10]	=>  Location: PIN_B5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[11]	=>  Location: PIN_F9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[12]	=>  Location: PIN_K8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[13]	=>  Location: PIN_T8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[14]	=>  Location: PIN_M10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[15]	=>  Location: PIN_L2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[16]	=>  Location: PIN_A6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[17]	=>  Location: PIN_R5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[18]	=>  Location: PIN_T2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[19]	=>  Location: PIN_L6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[20]	=>  Location: PIN_D5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[21]	=>  Location: PIN_T9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[22]	=>  Location: PIN_E5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[23]	=>  Location: PIN_J6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[24]	=>  Location: PIN_F11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[25]	=>  Location: PIN_L11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[26]	=>  Location: PIN_K5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[27]	=>  Location: PIN_E7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[28]	=>  Location: PIN_P14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[29]	=>  Location: PIN_K1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[30]	=>  Location: PIN_B7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[31]	=>  Location: PIN_J2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[32]	=>  Location: PIN_D3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[33]	=>  Location: PIN_A9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[34]	=>  Location: PIN_L1,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[35]	=>  Location: PIN_C2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[36]	=>  Location: PIN_T5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- complete2[37]	=>  Location: PIN_T3,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF para_final IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_clk : std_logic;
SIGNAL ww_reset : std_logic;
SIGNAL ww_in_sel1 : std_logic_vector(2 DOWNTO 0);
SIGNAL ww_in_sel2 : std_logic_vector(2 DOWNTO 0);
SIGNAL ww_input1 : std_logic_vector(15 DOWNTO 0);
SIGNAL ww_input2 : std_logic_vector(15 DOWNTO 0);
SIGNAL ww_wren1 : std_logic;
SIGNAL ww_wren2 : std_logic;
SIGNAL ww_complete1 : std_logic_vector(37 DOWNTO 0);
SIGNAL ww_complete2 : std_logic_vector(37 DOWNTO 0);
SIGNAL \clk~input_o\ : std_logic;
SIGNAL \reset~input_o\ : std_logic;
SIGNAL \in_sel1[0]~input_o\ : std_logic;
SIGNAL \in_sel1[1]~input_o\ : std_logic;
SIGNAL \in_sel1[2]~input_o\ : std_logic;
SIGNAL \in_sel2[0]~input_o\ : std_logic;
SIGNAL \in_sel2[1]~input_o\ : std_logic;
SIGNAL \in_sel2[2]~input_o\ : std_logic;
SIGNAL \input1[0]~input_o\ : std_logic;
SIGNAL \input1[1]~input_o\ : std_logic;
SIGNAL \input1[2]~input_o\ : std_logic;
SIGNAL \input1[3]~input_o\ : std_logic;
SIGNAL \input1[4]~input_o\ : std_logic;
SIGNAL \input1[5]~input_o\ : std_logic;
SIGNAL \input1[6]~input_o\ : std_logic;
SIGNAL \input1[7]~input_o\ : std_logic;
SIGNAL \input1[8]~input_o\ : std_logic;
SIGNAL \input1[9]~input_o\ : std_logic;
SIGNAL \input1[10]~input_o\ : std_logic;
SIGNAL \input1[11]~input_o\ : std_logic;
SIGNAL \input1[12]~input_o\ : std_logic;
SIGNAL \input1[13]~input_o\ : std_logic;
SIGNAL \input1[14]~input_o\ : std_logic;
SIGNAL \input1[15]~input_o\ : std_logic;
SIGNAL \input2[0]~input_o\ : std_logic;
SIGNAL \input2[1]~input_o\ : std_logic;
SIGNAL \input2[2]~input_o\ : std_logic;
SIGNAL \input2[3]~input_o\ : std_logic;
SIGNAL \input2[4]~input_o\ : std_logic;
SIGNAL \input2[5]~input_o\ : std_logic;
SIGNAL \input2[6]~input_o\ : std_logic;
SIGNAL \input2[7]~input_o\ : std_logic;
SIGNAL \input2[8]~input_o\ : std_logic;
SIGNAL \input2[9]~input_o\ : std_logic;
SIGNAL \input2[10]~input_o\ : std_logic;
SIGNAL \input2[11]~input_o\ : std_logic;
SIGNAL \input2[12]~input_o\ : std_logic;
SIGNAL \input2[13]~input_o\ : std_logic;
SIGNAL \input2[14]~input_o\ : std_logic;
SIGNAL \input2[15]~input_o\ : std_logic;
SIGNAL \wren1~input_o\ : std_logic;
SIGNAL \wren2~input_o\ : std_logic;
SIGNAL \complete1[0]~output_o\ : std_logic;
SIGNAL \complete1[1]~output_o\ : std_logic;
SIGNAL \complete1[2]~output_o\ : std_logic;
SIGNAL \complete1[3]~output_o\ : std_logic;
SIGNAL \complete1[4]~output_o\ : std_logic;
SIGNAL \complete1[5]~output_o\ : std_logic;
SIGNAL \complete1[6]~output_o\ : std_logic;
SIGNAL \complete1[7]~output_o\ : std_logic;
SIGNAL \complete1[8]~output_o\ : std_logic;
SIGNAL \complete1[9]~output_o\ : std_logic;
SIGNAL \complete1[10]~output_o\ : std_logic;
SIGNAL \complete1[11]~output_o\ : std_logic;
SIGNAL \complete1[12]~output_o\ : std_logic;
SIGNAL \complete1[13]~output_o\ : std_logic;
SIGNAL \complete1[14]~output_o\ : std_logic;
SIGNAL \complete1[15]~output_o\ : std_logic;
SIGNAL \complete1[16]~output_o\ : std_logic;
SIGNAL \complete1[17]~output_o\ : std_logic;
SIGNAL \complete1[18]~output_o\ : std_logic;
SIGNAL \complete1[19]~output_o\ : std_logic;
SIGNAL \complete1[20]~output_o\ : std_logic;
SIGNAL \complete1[21]~output_o\ : std_logic;
SIGNAL \complete1[22]~output_o\ : std_logic;
SIGNAL \complete1[23]~output_o\ : std_logic;
SIGNAL \complete1[24]~output_o\ : std_logic;
SIGNAL \complete1[25]~output_o\ : std_logic;
SIGNAL \complete1[26]~output_o\ : std_logic;
SIGNAL \complete1[27]~output_o\ : std_logic;
SIGNAL \complete1[28]~output_o\ : std_logic;
SIGNAL \complete1[29]~output_o\ : std_logic;
SIGNAL \complete1[30]~output_o\ : std_logic;
SIGNAL \complete1[31]~output_o\ : std_logic;
SIGNAL \complete1[32]~output_o\ : std_logic;
SIGNAL \complete1[33]~output_o\ : std_logic;
SIGNAL \complete1[34]~output_o\ : std_logic;
SIGNAL \complete1[35]~output_o\ : std_logic;
SIGNAL \complete1[36]~output_o\ : std_logic;
SIGNAL \complete1[37]~output_o\ : std_logic;
SIGNAL \complete2[0]~output_o\ : std_logic;
SIGNAL \complete2[1]~output_o\ : std_logic;
SIGNAL \complete2[2]~output_o\ : std_logic;
SIGNAL \complete2[3]~output_o\ : std_logic;
SIGNAL \complete2[4]~output_o\ : std_logic;
SIGNAL \complete2[5]~output_o\ : std_logic;
SIGNAL \complete2[6]~output_o\ : std_logic;
SIGNAL \complete2[7]~output_o\ : std_logic;
SIGNAL \complete2[8]~output_o\ : std_logic;
SIGNAL \complete2[9]~output_o\ : std_logic;
SIGNAL \complete2[10]~output_o\ : std_logic;
SIGNAL \complete2[11]~output_o\ : std_logic;
SIGNAL \complete2[12]~output_o\ : std_logic;
SIGNAL \complete2[13]~output_o\ : std_logic;
SIGNAL \complete2[14]~output_o\ : std_logic;
SIGNAL \complete2[15]~output_o\ : std_logic;
SIGNAL \complete2[16]~output_o\ : std_logic;
SIGNAL \complete2[17]~output_o\ : std_logic;
SIGNAL \complete2[18]~output_o\ : std_logic;
SIGNAL \complete2[19]~output_o\ : std_logic;
SIGNAL \complete2[20]~output_o\ : std_logic;
SIGNAL \complete2[21]~output_o\ : std_logic;
SIGNAL \complete2[22]~output_o\ : std_logic;
SIGNAL \complete2[23]~output_o\ : std_logic;
SIGNAL \complete2[24]~output_o\ : std_logic;
SIGNAL \complete2[25]~output_o\ : std_logic;
SIGNAL \complete2[26]~output_o\ : std_logic;
SIGNAL \complete2[27]~output_o\ : std_logic;
SIGNAL \complete2[28]~output_o\ : std_logic;
SIGNAL \complete2[29]~output_o\ : std_logic;
SIGNAL \complete2[30]~output_o\ : std_logic;
SIGNAL \complete2[31]~output_o\ : std_logic;
SIGNAL \complete2[32]~output_o\ : std_logic;
SIGNAL \complete2[33]~output_o\ : std_logic;
SIGNAL \complete2[34]~output_o\ : std_logic;
SIGNAL \complete2[35]~output_o\ : std_logic;
SIGNAL \complete2[36]~output_o\ : std_logic;
SIGNAL \complete2[37]~output_o\ : std_logic;

COMPONENT hard_block
    PORT (
	devoe : IN std_logic;
	devclrn : IN std_logic;
	devpor : IN std_logic);
END COMPONENT;

BEGIN

ww_clk <= clk;
ww_reset <= reset;
ww_in_sel1 <= in_sel1;
ww_in_sel2 <= in_sel2;
ww_input1 <= input1;
ww_input2 <= input2;
ww_wren1 <= wren1;
ww_wren2 <= wren2;
complete1 <= ww_complete1;
complete2 <= ww_complete2;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
auto_generated_inst : hard_block
PORT MAP (
	devoe => ww_devoe,
	devclrn => ww_devclrn,
	devpor => ww_devpor);

-- Location: IOOBUF_X34_Y11_N9
\complete1[0]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[0]~output_o\);

-- Location: IOOBUF_X0_Y7_N23
\complete1[1]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[1]~output_o\);

-- Location: IOOBUF_X18_Y0_N9
\complete1[2]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[2]~output_o\);

-- Location: IOOBUF_X25_Y0_N23
\complete1[3]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[3]~output_o\);

-- Location: IOOBUF_X13_Y24_N2
\complete1[4]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[4]~output_o\);

-- Location: IOOBUF_X0_Y7_N16
\complete1[5]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[5]~output_o\);

-- Location: IOOBUF_X21_Y0_N9
\complete1[6]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[6]~output_o\);

-- Location: IOOBUF_X28_Y24_N2
\complete1[7]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[7]~output_o\);

-- Location: IOOBUF_X16_Y24_N9
\complete1[8]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[8]~output_o\);

-- Location: IOOBUF_X23_Y0_N9
\complete1[9]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[9]~output_o\);

-- Location: IOOBUF_X7_Y0_N9
\complete1[10]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[10]~output_o\);

-- Location: IOOBUF_X9_Y0_N23
\complete1[11]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[11]~output_o\);

-- Location: IOOBUF_X34_Y9_N16
\complete1[12]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[12]~output_o\);

-- Location: IOOBUF_X13_Y24_N23
\complete1[13]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[13]~output_o\);

-- Location: IOOBUF_X16_Y0_N23
\complete1[14]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[14]~output_o\);

-- Location: IOOBUF_X34_Y19_N2
\complete1[15]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[15]~output_o\);

-- Location: IOOBUF_X7_Y24_N9
\complete1[16]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[16]~output_o\);

-- Location: IOOBUF_X28_Y24_N9
\complete1[17]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[17]~output_o\);

-- Location: IOOBUF_X34_Y9_N2
\complete1[18]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[18]~output_o\);

-- Location: IOOBUF_X25_Y0_N9
\complete1[19]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[19]~output_o\);

-- Location: IOOBUF_X5_Y24_N2
\complete1[20]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[20]~output_o\);

-- Location: IOOBUF_X11_Y24_N2
\complete1[21]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[21]~output_o\);

-- Location: IOOBUF_X23_Y0_N2
\complete1[22]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[22]~output_o\);

-- Location: IOOBUF_X21_Y0_N2
\complete1[23]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[23]~output_o\);

-- Location: IOOBUF_X34_Y9_N9
\complete1[24]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[24]~output_o\);

-- Location: IOOBUF_X0_Y21_N23
\complete1[25]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[25]~output_o\);

-- Location: IOOBUF_X5_Y24_N23
\complete1[26]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[26]~output_o\);

-- Location: IOOBUF_X34_Y7_N16
\complete1[27]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[27]~output_o\);

-- Location: IOOBUF_X34_Y4_N23
\complete1[28]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[28]~output_o\);

-- Location: IOOBUF_X3_Y24_N9
\complete1[29]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[29]~output_o\);

-- Location: IOOBUF_X0_Y22_N2
\complete1[30]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[30]~output_o\);

-- Location: IOOBUF_X21_Y0_N16
\complete1[31]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[31]~output_o\);

-- Location: IOOBUF_X34_Y7_N23
\complete1[32]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[32]~output_o\);

-- Location: IOOBUF_X30_Y24_N23
\complete1[33]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[33]~output_o\);

-- Location: IOOBUF_X13_Y0_N23
\complete1[34]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[34]~output_o\);

-- Location: IOOBUF_X34_Y3_N16
\complete1[35]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[35]~output_o\);

-- Location: IOOBUF_X30_Y0_N23
\complete1[36]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[36]~output_o\);

-- Location: IOOBUF_X0_Y4_N16
\complete1[37]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete1[37]~output_o\);

-- Location: IOOBUF_X0_Y9_N2
\complete2[0]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[0]~output_o\);

-- Location: IOOBUF_X34_Y2_N23
\complete2[1]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[1]~output_o\);

-- Location: IOOBUF_X28_Y0_N16
\complete2[2]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[2]~output_o\);

-- Location: IOOBUF_X28_Y0_N23
\complete2[3]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[3]~output_o\);

-- Location: IOOBUF_X9_Y24_N23
\complete2[4]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[4]~output_o\);

-- Location: IOOBUF_X0_Y4_N23
\complete2[5]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[5]~output_o\);

-- Location: IOOBUF_X34_Y18_N16
\complete2[6]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[6]~output_o\);

-- Location: IOOBUF_X18_Y0_N2
\complete2[7]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[7]~output_o\);

-- Location: IOOBUF_X13_Y0_N16
\complete2[8]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[8]~output_o\);

-- Location: IOOBUF_X34_Y2_N16
\complete2[9]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[9]~output_o\);

-- Location: IOOBUF_X5_Y24_N9
\complete2[10]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[10]~output_o\);

-- Location: IOOBUF_X23_Y24_N16
\complete2[11]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[11]~output_o\);

-- Location: IOOBUF_X9_Y0_N16
\complete2[12]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[12]~output_o\);

-- Location: IOOBUF_X16_Y0_N2
\complete2[13]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[13]~output_o\);

-- Location: IOOBUF_X28_Y0_N2
\complete2[14]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[14]~output_o\);

-- Location: IOOBUF_X0_Y8_N16
\complete2[15]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[15]~output_o\);

-- Location: IOOBUF_X9_Y24_N16
\complete2[16]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[16]~output_o\);

-- Location: IOOBUF_X9_Y0_N9
\complete2[17]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[17]~output_o\);

-- Location: IOOBUF_X3_Y0_N2
\complete2[18]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[18]~output_o\);

-- Location: IOOBUF_X0_Y9_N9
\complete2[19]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[19]~output_o\);

-- Location: IOOBUF_X3_Y24_N2
\complete2[20]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[20]~output_o\);

-- Location: IOOBUF_X18_Y0_N16
\complete2[21]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[21]~output_o\);

-- Location: IOOBUF_X0_Y23_N9
\complete2[22]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[22]~output_o\);

-- Location: IOOBUF_X0_Y10_N23
\complete2[23]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[23]~output_o\);

-- Location: IOOBUF_X23_Y24_N23
\complete2[24]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[24]~output_o\);

-- Location: IOOBUF_X32_Y0_N16
\complete2[25]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[25]~output_o\);

-- Location: IOOBUF_X0_Y6_N16
\complete2[26]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[26]~output_o\);

-- Location: IOOBUF_X7_Y24_N2
\complete2[27]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[27]~output_o\);

-- Location: IOOBUF_X32_Y0_N23
\complete2[28]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[28]~output_o\);

-- Location: IOOBUF_X0_Y8_N9
\complete2[29]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[29]~output_o\);

-- Location: IOOBUF_X11_Y24_N9
\complete2[30]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[30]~output_o\);

-- Location: IOOBUF_X0_Y10_N2
\complete2[31]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[31]~output_o\);

-- Location: IOOBUF_X1_Y24_N9
\complete2[32]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[32]~output_o\);

-- Location: IOOBUF_X16_Y24_N2
\complete2[33]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[33]~output_o\);

-- Location: IOOBUF_X0_Y8_N23
\complete2[34]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[34]~output_o\);

-- Location: IOOBUF_X0_Y22_N16
\complete2[35]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[35]~output_o\);

-- Location: IOOBUF_X9_Y0_N2
\complete2[36]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[36]~output_o\);

-- Location: IOOBUF_X1_Y0_N2
\complete2[37]~output\ : cycloneive_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => \complete2[37]~output_o\);

-- Location: IOIBUF_X30_Y0_N1
\clk~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clk,
	o => \clk~input_o\);

-- Location: IOIBUF_X18_Y0_N22
\reset~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_reset,
	o => \reset~input_o\);

-- Location: IOIBUF_X11_Y24_N15
\in_sel1[0]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_sel1(0),
	o => \in_sel1[0]~input_o\);

-- Location: IOIBUF_X7_Y0_N15
\in_sel1[1]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_sel1(1),
	o => \in_sel1[1]~input_o\);

-- Location: IOIBUF_X0_Y6_N22
\in_sel1[2]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_sel1(2),
	o => \in_sel1[2]~input_o\);

-- Location: IOIBUF_X1_Y0_N8
\in_sel2[0]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_sel2(0),
	o => \in_sel2[0]~input_o\);

-- Location: IOIBUF_X34_Y18_N1
\in_sel2[1]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_sel2(1),
	o => \in_sel2[1]~input_o\);

-- Location: IOIBUF_X13_Y24_N8
\in_sel2[2]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_sel2(2),
	o => \in_sel2[2]~input_o\);

-- Location: IOIBUF_X28_Y24_N15
\input1[0]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input1(0),
	o => \input1[0]~input_o\);

-- Location: IOIBUF_X25_Y0_N1
\input1[1]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input1(1),
	o => \input1[1]~input_o\);

-- Location: IOIBUF_X23_Y24_N8
\input1[2]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input1(2),
	o => \input1[2]~input_o\);

-- Location: IOIBUF_X25_Y0_N15
\input1[3]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input1(3),
	o => \input1[3]~input_o\);

-- Location: IOIBUF_X13_Y0_N1
\input1[4]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input1(4),
	o => \input1[4]~input_o\);

-- Location: IOIBUF_X16_Y24_N15
\input1[5]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input1(5),
	o => \input1[5]~input_o\);

-- Location: IOIBUF_X0_Y19_N22
\input1[6]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input1(6),
	o => \input1[6]~input_o\);

-- Location: IOIBUF_X28_Y24_N22
\input1[7]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input1(7),
	o => \input1[7]~input_o\);

-- Location: IOIBUF_X7_Y0_N22
\input1[8]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input1(8),
	o => \input1[8]~input_o\);

-- Location: IOIBUF_X21_Y24_N1
\input1[9]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input1(9),
	o => \input1[9]~input_o\);

-- Location: IOIBUF_X25_Y24_N22
\input1[10]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input1(10),
	o => \input1[10]~input_o\);

-- Location: IOIBUF_X1_Y24_N1
\input1[11]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input1(11),
	o => \input1[11]~input_o\);

-- Location: IOIBUF_X34_Y11_N1
\input1[12]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input1(12),
	o => \input1[12]~input_o\);

-- Location: IOIBUF_X23_Y0_N15
\input1[13]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input1(13),
	o => \input1[13]~input_o\);

-- Location: IOIBUF_X21_Y24_N8
\input1[14]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input1(14),
	o => \input1[14]~input_o\);

-- Location: IOIBUF_X34_Y17_N1
\input1[15]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input1(15),
	o => \input1[15]~input_o\);

-- Location: IOIBUF_X34_Y4_N15
\input2[0]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input2(0),
	o => \input2[0]~input_o\);

-- Location: IOIBUF_X0_Y23_N15
\input2[1]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input2(1),
	o => \input2[1]~input_o\);

-- Location: IOIBUF_X32_Y24_N15
\input2[2]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input2(2),
	o => \input2[2]~input_o\);

-- Location: IOIBUF_X1_Y0_N15
\input2[3]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input2(3),
	o => \input2[3]~input_o\);

-- Location: IOIBUF_X0_Y7_N1
\input2[4]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input2(4),
	o => \input2[4]~input_o\);

-- Location: IOIBUF_X7_Y0_N1
\input2[5]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input2(5),
	o => \input2[5]~input_o\);

-- Location: IOIBUF_X18_Y24_N22
\input2[6]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input2(6),
	o => \input2[6]~input_o\);

-- Location: IOIBUF_X11_Y0_N15
\input2[7]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input2(7),
	o => \input2[7]~input_o\);

-- Location: IOIBUF_X9_Y24_N8
\input2[8]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input2(8),
	o => \input2[8]~input_o\);

-- Location: IOIBUF_X30_Y24_N1
\input2[9]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input2(9),
	o => \input2[9]~input_o\);

-- Location: IOIBUF_X32_Y24_N22
\input2[10]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input2(10),
	o => \input2[10]~input_o\);

-- Location: IOIBUF_X25_Y24_N15
\input2[11]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input2(11),
	o => \input2[11]~input_o\);

-- Location: IOIBUF_X34_Y10_N8
\input2[12]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input2(12),
	o => \input2[12]~input_o\);

-- Location: IOIBUF_X34_Y5_N15
\input2[13]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input2(13),
	o => \input2[13]~input_o\);

-- Location: IOIBUF_X11_Y24_N22
\input2[14]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input2(14),
	o => \input2[14]~input_o\);

-- Location: IOIBUF_X28_Y0_N8
\input2[15]~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_input2(15),
	o => \input2[15]~input_o\);

-- Location: IOIBUF_X16_Y24_N22
\wren1~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_wren1,
	o => \wren1~input_o\);

-- Location: IOIBUF_X34_Y3_N22
\wren2~input\ : cycloneive_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_wren2,
	o => \wren2~input_o\);

ww_complete1(0) <= \complete1[0]~output_o\;

ww_complete1(1) <= \complete1[1]~output_o\;

ww_complete1(2) <= \complete1[2]~output_o\;

ww_complete1(3) <= \complete1[3]~output_o\;

ww_complete1(4) <= \complete1[4]~output_o\;

ww_complete1(5) <= \complete1[5]~output_o\;

ww_complete1(6) <= \complete1[6]~output_o\;

ww_complete1(7) <= \complete1[7]~output_o\;

ww_complete1(8) <= \complete1[8]~output_o\;

ww_complete1(9) <= \complete1[9]~output_o\;

ww_complete1(10) <= \complete1[10]~output_o\;

ww_complete1(11) <= \complete1[11]~output_o\;

ww_complete1(12) <= \complete1[12]~output_o\;

ww_complete1(13) <= \complete1[13]~output_o\;

ww_complete1(14) <= \complete1[14]~output_o\;

ww_complete1(15) <= \complete1[15]~output_o\;

ww_complete1(16) <= \complete1[16]~output_o\;

ww_complete1(17) <= \complete1[17]~output_o\;

ww_complete1(18) <= \complete1[18]~output_o\;

ww_complete1(19) <= \complete1[19]~output_o\;

ww_complete1(20) <= \complete1[20]~output_o\;

ww_complete1(21) <= \complete1[21]~output_o\;

ww_complete1(22) <= \complete1[22]~output_o\;

ww_complete1(23) <= \complete1[23]~output_o\;

ww_complete1(24) <= \complete1[24]~output_o\;

ww_complete1(25) <= \complete1[25]~output_o\;

ww_complete1(26) <= \complete1[26]~output_o\;

ww_complete1(27) <= \complete1[27]~output_o\;

ww_complete1(28) <= \complete1[28]~output_o\;

ww_complete1(29) <= \complete1[29]~output_o\;

ww_complete1(30) <= \complete1[30]~output_o\;

ww_complete1(31) <= \complete1[31]~output_o\;

ww_complete1(32) <= \complete1[32]~output_o\;

ww_complete1(33) <= \complete1[33]~output_o\;

ww_complete1(34) <= \complete1[34]~output_o\;

ww_complete1(35) <= \complete1[35]~output_o\;

ww_complete1(36) <= \complete1[36]~output_o\;

ww_complete1(37) <= \complete1[37]~output_o\;

ww_complete2(0) <= \complete2[0]~output_o\;

ww_complete2(1) <= \complete2[1]~output_o\;

ww_complete2(2) <= \complete2[2]~output_o\;

ww_complete2(3) <= \complete2[3]~output_o\;

ww_complete2(4) <= \complete2[4]~output_o\;

ww_complete2(5) <= \complete2[5]~output_o\;

ww_complete2(6) <= \complete2[6]~output_o\;

ww_complete2(7) <= \complete2[7]~output_o\;

ww_complete2(8) <= \complete2[8]~output_o\;

ww_complete2(9) <= \complete2[9]~output_o\;

ww_complete2(10) <= \complete2[10]~output_o\;

ww_complete2(11) <= \complete2[11]~output_o\;

ww_complete2(12) <= \complete2[12]~output_o\;

ww_complete2(13) <= \complete2[13]~output_o\;

ww_complete2(14) <= \complete2[14]~output_o\;

ww_complete2(15) <= \complete2[15]~output_o\;

ww_complete2(16) <= \complete2[16]~output_o\;

ww_complete2(17) <= \complete2[17]~output_o\;

ww_complete2(18) <= \complete2[18]~output_o\;

ww_complete2(19) <= \complete2[19]~output_o\;

ww_complete2(20) <= \complete2[20]~output_o\;

ww_complete2(21) <= \complete2[21]~output_o\;

ww_complete2(22) <= \complete2[22]~output_o\;

ww_complete2(23) <= \complete2[23]~output_o\;

ww_complete2(24) <= \complete2[24]~output_o\;

ww_complete2(25) <= \complete2[25]~output_o\;

ww_complete2(26) <= \complete2[26]~output_o\;

ww_complete2(27) <= \complete2[27]~output_o\;

ww_complete2(28) <= \complete2[28]~output_o\;

ww_complete2(29) <= \complete2[29]~output_o\;

ww_complete2(30) <= \complete2[30]~output_o\;

ww_complete2(31) <= \complete2[31]~output_o\;

ww_complete2(32) <= \complete2[32]~output_o\;

ww_complete2(33) <= \complete2[33]~output_o\;

ww_complete2(34) <= \complete2[34]~output_o\;

ww_complete2(35) <= \complete2[35]~output_o\;

ww_complete2(36) <= \complete2[36]~output_o\;

ww_complete2(37) <= \complete2[37]~output_o\;
END structure;


