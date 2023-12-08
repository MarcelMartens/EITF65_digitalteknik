-------------------------------------------------------------------------------
-- Title      : Top Level file for Stop Watch
-- Project    : 
-------------------------------------------------------------------------------
-- File       : stop_watch.vhd
-- Author     : 
-- Company    : 
-- Created    : 2014-07-11
-- Last update: 2015-06-01
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: This file is the top level of the developed stop watch and used
-- to wire all the different components together.
-------------------------------------------------------------------------------
-- Copyright (c) 2014 Lund University
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014-07-11  1.0      Steffen Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity stop_watch_sim is
  
  port (
    clk, rst      : in  std_logic;
    start, stop   : in  std_logic;
	integer_tens  : out std_logic_vector(3 downto 0);
	integer_ones  : out std_logic_vector(3 downto 0);
	decimal_tens  : out std_logic_vector(3 downto 0);
	decimal_ones  : out std_logic_vector(3 downto 0)
    );

end stop_watch_sim;

architecture stop_watch_structal of stop_watch_sim is

  component FSM
    port (
      clk     : in  std_logic;
      n_rst   : in  std_logic;
      start   : in  std_logic;
      stop    : in  std_logic;
      run_cnt : out std_logic;
      set0    : out std_logic);
  end component;

  component fast_counter
    port (
      clk      : in  std_logic;
      n_rst    : in  std_logic;
      run      : in  std_logic;
      set0     : in  std_logic;
      sec_int  : out std_logic_vector(6 downto 0);
      sec_frac : out std_logic_vector(6 downto 0));
  end component;

  component nbcd
    port (
      binary  : in  std_logic_vector(6 downto 0);
      tens : out std_logic_vector(3 downto 0);
      ones : out std_logic_vector(3 downto 0));
  end component;

  component edge_det
    port (
      clk, n_rst : in  std_logic;
      inp        : in  std_logic;
      det_edge   : out std_logic);
  end component;

  signal run_cnt_int                    : std_logic;
  signal set0_int                       : std_logic;
  signal sec_int_int                    : std_logic_vector(6 downto 0);
  signal sec_frac_int                   : std_logic_vector(6 downto 0);
  signal nbcd_int_in, nbcd_frac_in      : std_logic_vector(6 downto 0);
  signal start_det, stop_det            : std_logic;
  signal n_rst                          : std_logic;
  
  
begin  -- stop_watch_structal

  nbcd_frac_in <= sec_frac_int;
  nbcd_int_in  <= sec_int_int;
  n_rst       <= not rst;

  edge_det_1 : edge_det
    port map (
      clk      => clk,
      n_rst    => n_rst,
      inp      => start,
      det_edge => start_det);

  edge_det_2 : edge_det
    port map (
      clk      => clk,
      n_rst    => n_rst,
      inp      => stop,
      det_edge => stop_det);

  FSM_1 : FSM
    port map (
      clk     => clk,
      n_rst   => n_rst,
      start   => start_det,
      stop    => stop_det,
      run_cnt => run_cnt_int,
      set0    => set0_int);

  Counter_1 : fast_counter
    port map (
      clk      => clk,
      n_rst    => n_rst,
      run      => run_cnt_int,
      set0     => set0_int,
      sec_int  => sec_int_int,
      sec_frac => sec_frac_int);

  nbcd_integer_part : nbcd
    port map (
      binary  => nbcd_int_in,
      tens => integer_tens,
      ones => integer_ones);

  nbcd_decimal_part : nbcd
    port map (
      binary  => nbcd_frac_in,
      tens => decimal_tens,
      ones => decimal_ones);

end stop_watch_structal;
