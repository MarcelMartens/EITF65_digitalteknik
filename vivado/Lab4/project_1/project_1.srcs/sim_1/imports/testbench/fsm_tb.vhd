-------------------------------------------------------------------------------
-- Title      : Testbench for design "FSM_Mealy"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : FSM_Mealy_tb.vhd
-- Author     : Steffen Malkowsky  <Steffen@Steffens-MacBook-Air.local>
-- Company    : 
-- Created    : 2014-07-19
-- Last update: 2014-08-27
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2014 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014-07-19  1.0      Steffen	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity FSM_tb is

end entity FSM_tb;

-------------------------------------------------------------------------------

architecture FSM_tb of FSM_tb is

	-- component ports
	signal n_rst	: std_logic;
	signal start	: std_logic := '0';
	signal stop		: std_logic := '0';
	signal run_cnt	: std_logic;
	signal set0		: std_logic;

	-- clock
	signal clk : std_logic := '1';

begin  -- architecture FSM_tb

	-- component instantiation
	DUT: entity work.FSM
		port map (
		clk		=> clk,
		n_rst	=> n_rst,
		start	=> start,
		stop	=> stop,
		run_cnt	=> run_cnt,
		set0	=> set0);

	-- clock generation
	Clk <= not Clk after 50 ns;

	-- waveform generation
	WaveGen_Proc: process
	begin
		-- insert signal assignments here
		-- reset design
		n_rst <= '0';
        
        wait until clk'event and clk='0';
        start <= '1';
        
        wait until clk'event and clk='0';
        start <= '0';
        
		wait for 100 ns;
		n_rst <= '1';

		-- stop button should not trigger anything in init mode
		wait until clk'event and clk='1';
		stop <= '1';
		wait until clk'event and clk='1';
		stop <= '0';
		wait for 100 ns;

		-- start the stop watch
		wait until clk'event and clk='1';
		start <= '1';
		wait until clk'event and clk='1';
		start <= '0';
		wait for 100 ns;

		-- in run mode nothing should happen if start is pressed again
		wait until clk'event and clk='1';
		start <= '1';
		wait until clk'event and clk='1';
		start <= '0';
		wait for 100 ns;

		-- press stop button (current value should be hold constant)
		wait until clk'event and clk='1';
		stop <= '1';
		wait until clk'event and clk='1';
		stop <= '0';
        wait for 10 ns;
        stop <= '1';
        wait for 10 ns;
        stop <= '0';
		wait for 100 ns;

		-- press start to continue counting
		wait until clk'event and clk='1';
		start <= '1';
		wait until clk'event and clk='1';
		start <= '0';
		wait for 100 ns;

		-- press stop to stop again
		wait until clk'event and clk='1';
		stop <= '1';
		wait until clk'event and clk='1';
		stop <= '0';
		wait for 100 ns;

		-- pressing stop again should bring stop watch to reset
		wait until clk'event and clk='1';
		stop <= '1';
		wait until clk'event and clk='1';
		stop <= '0';
		wait for 100 ns;

		-- wait forever
		wait;
		
		wait until Clk = '1';
	end process WaveGen_Proc;
	
end architecture FSM_tb;
