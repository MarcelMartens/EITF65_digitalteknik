-------------------------------------------------------------------------------
-- Title      : Testbench for design "edge_det"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : edge_det_tb.vhd
-- Author     : Steffen Malkowsky  <Steffen@ip227-103.wireless.lu.se>
-- Company    : 
-- Created    : 2014-08-27
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
-- 2014-08-27  1.0      Steffen	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity edge_det_tb is

end entity edge_det_tb;

-------------------------------------------------------------------------------

architecture edge_det_tb_arch of edge_det_tb is

	-- component ports
	signal n_rst		: std_logic;
	signal inp			: std_logic;
	signal det_edge		: std_logic;

	-- clock
	signal clk : std_logic := '1';

begin  -- architecture edge_det_tb_arch

	-- component instantiation
	DUT: entity work.edge_det
	port map (
		clk			=> clk,
		n_rst		=> n_rst,
		inp			=> inp,
		det_edge	=> det_edge);

	-- clock generation
	clk <= not clk after 50 ns;

	-- waveform generation
	WaveGen_Proc: process
	begin
		-- insert signal assignments here
		inp <= '0';
        n_rst <= '0';
        wait until clk'event and clk='1';
		n_rst <= '1';
		
		wait until clk'event and clk='1';
		inp <= '1';
		wait for 300 ns;
    
		wait until clk'event and clk='1';
		inp <= '0';
		wait for 300 ns;
	
		wait until clk'event and clk='1';
		inp <= '1';
		wait for 300 ns;
    
		wait until clk'event and clk='1';
		inp <= '0';
		wait;
	
	end process WaveGen_Proc;
  
end architecture edge_det_tb_arch;
