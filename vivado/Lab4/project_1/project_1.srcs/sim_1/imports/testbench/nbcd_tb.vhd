-------------------------------------------------------------------------------
-- Title      : Testbench for design "nbcd"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : nbcd_tb.vhd
-- Author     : 
-- Company    : 
-- Created    : 2014-07-12
-- Last update: 2014-07-13
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2014 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014-07-12  1.0      Steffen	Created
-- 2015-06-01  1.1      Andreas Johansson
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity nbcd_tb is

end nbcd_tb;

-------------------------------------------------------------------------------

architecture nbcd_tb_arch of nbcd_tb is

	component nbcd
	port (
		binary : in  std_logic_vector(6 downto 0);
        tens : out std_logic_vector(3 downto 0);
        ones : out std_logic_vector(3 downto 0));
	end component;
    
	-- component ports
	signal binary	: std_logic_vector(6 downto 0) := (others => '0');
	signal tens, ones	: std_logic_vector(3 downto 0);

begin  -- nbcd_tb_arch

	-- component instantiation
	DUT: nbcd
		port map (
			binary => binary,
            tens => tens,
            ones => ones);


	-- waveform generation
	WaveGen_Proc: process
	begin
		-- insert signal assignments here
		for i in 0 to 9 loop
			wait for 10 ns;
			binary <= std_logic_vector(unsigned(binary) + 1);
		end loop;  -- i
		wait for 10 ns;
	end process WaveGen_Proc;

end nbcd_tb_arch;
