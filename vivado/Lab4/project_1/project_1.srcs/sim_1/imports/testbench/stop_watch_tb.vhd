-------------------------------------------------------------------------------
-- Title      : Testbench for design "stop_watch"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : stop_watch_tb.vhd
-- Author     : 
-- Company    : 
-- Created    : 2014-07-12
-- Last update: 2014-08-27
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
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity stop_watch_tb is

end stop_watch_tb;

-------------------------------------------------------------------------------

architecture stop_watch_tb_arch of stop_watch_tb is

	component stop_watch_sim
		port (
			clk, rst		: in  std_logic;
			start, stop		: in  std_logic;
			integer_tens	: out std_logic_vector(3 downto 0);
			integer_ones	: out std_logic_vector(3 downto 0);
			decimal_tens	: out std_logic_vector(3 downto 0);
			decimal_ones	: out std_logic_vector(3 downto 0)
			);
	end component;

	-- component ports
	signal rst				: std_logic;
	signal start, stop		: std_logic := '0';
	signal integer_tens		: std_logic_vector(3 downto 0);
	signal integer_ones		: std_logic_vector(3 downto 0);
	signal decimal_tens		: std_logic_vector(3 downto 0);
	signal decimal_ones		: std_logic_vector(3 downto 0);

	-- clock
	signal clk : std_logic := '1';

begin  -- stop_watch_tb_arch

	-- component instantiation
	DUT: stop_watch_sim
		port map (
		clk				=> clk,
		rst				=> rst,
		start			=> start,
		stop			=> stop,
		integer_tens	=> integer_tens,
		integer_ones	=> integer_ones,
		decimal_tens	=> decimal_tens,
		decimal_ones	=> decimal_ones
		);

	-- clock generation
	clk <= not clk after 5 ns;

	-- waveform generation
	WaveGen_Proc: process
	begin
		-- insert signal assignments here
		rst <= '1';
		wait for 1 ms;
		rst <= '0';

		-- stop button should not trigger anything in init mode
		wait until clk'event and clk='1';
		stop <= '1';
		wait for 1 ms;
		
		wait until clk'event and clk='1';
		stop <= '0';
		wait for 1 ms;

		-- start the stop watch
		wait until clk'event and clk='1';
		start <= '1';
		wait for 10 ms;
		
		wait until clk'event and clk='1';
		start <= '0';
		wait for 1 ms;

		-- in run mode nothing should happen if start is pressed again
		wait until clk'event and clk='1';
		start <= '1';
		wait for 1 ms;
		
		wait until clk'event and clk='1';
		start <= '0';
		wait for 10 ms;

		-- press stop button (current value should be hold constant)
		wait until clk'event and clk='1';
		stop <= '1';
		wait for 1 ms;
		
		wait until clk'event and clk='1';
		stop <= '0';
		wait for 10 ms;

		-- press start to continue counting
		wait until clk'event and clk='1';
		start <= '1';
		wait for 10 ms;
		
		wait until clk'event and clk='1';
		start <= '0';
		wait for 10 ms;

		-- press stop to stop again
		wait until clk'event and clk='1';
		stop <= '1';
		wait for 10 ms;
		
		wait until clk'event and clk='1';
		stop <= '0';
		wait for 1 ms;

		-- pressing stop again should bring stop watch to reset
		wait until clk'event and clk='1';
		stop <= '1';
		wait for 1 ms;
		
		wait until clk'event and clk='1';
		stop <= '0';
		wait for 1 ms;

		-- wait forever
		wait;
		
	end process WaveGen_Proc;
	
end stop_watch_tb_arch;
