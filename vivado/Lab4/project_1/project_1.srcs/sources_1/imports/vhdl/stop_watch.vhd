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

entity stop_watch is
  
  port (
    clk, rst      : in  std_logic;
    start, stop   : in  std_logic;
    anode         : out std_logic_vector(7 downto 0);
    seven_segment : out std_logic_vector(6 downto 0));

end stop_watch;

architecture stop_watch_structal of stop_watch is

  component FSM
    port (
      clk     : in  std_logic;
      n_rst   : in  std_logic;
      start   : in  std_logic;
      stop    : in  std_logic;
      run_cnt : out std_logic;
      set0    : out std_logic);
  end component;

  component Counter
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

  component debouncer
    port (
      n_rst, clk : in  std_logic;
      button_in  : in  std_logic;
      button_out : out std_logic);
  end component;

  component edge_det
    port (
      clk, n_rst : in  std_logic;
      inp        : in  std_logic;
      det_edge   : out std_logic);
  end component;

  component SevenSegment
    port (
      clk                    : in  std_logic;
      nRST                   : in  std_logic;
      seg0, seg1, seg2, seg3 : in  std_logic_vector(3 downto 0);
      --dot                    : in  std_logic_vector(1 downto 0);
      anode                  : out std_logic_vector(3 downto 0);
      Seven_Seg              : out std_logic_vector(6 downto 0));
  end component;

  signal run_cnt_int                              : std_logic;
  signal set0_int                                 : std_logic;
  signal sec_int_int                              : std_logic_vector(6 downto 0);
  signal sec_frac_int                             : std_logic_vector(6 downto 0);
  signal nbcd_int_in, nbcd_frac_in                  : std_logic_vector(6 downto 0);
  signal start_det, start_deb, stop_det, stop_deb : std_logic;
  signal tens_int_int, ones_int_int               : std_logic_vector(3 downto 0);
  signal tens_frac_int, ones_frac_int             : std_logic_vector(3 downto 0);
  --signal dot                                      : std_logic_vector(1 downto 0);
  signal n_rst                                    : std_logic;
  signal anode_int                                : std_logic_vector(3 downto 0);
  
  
begin  -- stop_watch_structal

  nbcd_frac_in <= sec_frac_int;
  nbcd_int_in  <= sec_int_int;
  --dot         <= "11";
  n_rst       <= not rst;
  --anode       <= "1111" & anode_int;
  anode       <= n_rst & n_rst & n_rst & n_rst & anode_int;
	
  debouncer_1 : debouncer
    port map (
      n_rst      => n_rst,
      clk        => clk,
      button_in  => start,
      button_out => start_deb);

  debouncer_2 : debouncer
    port map (
      n_rst      => n_rst,
      clk        => clk,
      button_in  => stop,
      button_out => stop_deb);

  edge_det_1 : edge_det
    port map (
      clk      => clk,
      n_rst    => n_rst,
      inp      => start_deb,
      det_edge => start_det);

  edge_det_2 : edge_det
    port map (
      clk      => clk,
      n_rst    => n_rst,
      inp      => stop_deb,
      det_edge => stop_det);

  FSM_1 : FSM
    port map (
      clk     => clk,
      n_rst   => n_rst,
      start   => start_det,
      stop    => stop_det,
      run_cnt => run_cnt_int,
      set0    => set0_int);

  Counter_1 : Counter
    port map (
      clk      => clk,
      n_rst    => n_rst,
      run      => run_cnt_int,
      set0     => set0_int,
      sec_int  => sec_int_int,
      sec_frac => sec_frac_int);

  nbcd_1 : nbcd
    port map (
      binary  => nbcd_int_in,
      tens => tens_int_int,
      ones => ones_int_int);

  nbcd_2 : nbcd
    port map (
      binary  => nbcd_frac_in,
      tens => tens_frac_int,
      ones => ones_frac_int);

  SevenSegment_1 : SevenSegment
    port map (
      clk       => clk,
      nRST      => n_rst,
      seg0      => ones_frac_int,
      seg1      => tens_frac_int,
      seg2      => ones_int_int,
      seg3      => tens_int_int,
      --dot       => dot,
      anode     => anode_int,
      Seven_Seg => seven_segment);

end stop_watch_structal;