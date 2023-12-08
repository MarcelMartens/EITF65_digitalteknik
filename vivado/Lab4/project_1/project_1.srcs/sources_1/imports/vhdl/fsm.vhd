-------------------------------------------------------------------------------
-- Title      : FSM
-- Project    : 
-------------------------------------------------------------------------------
-- File       : FSM.vhd
-- Author     : Steffen Malkowsky  <Steffen@Steffens-MacBook-Air.local>
-- Company    : 
-- Created    : 2014-06-14
-- Last update: 2014-07-19
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: implementation of the FSM used to control the stop watch.
-------------------------------------------------------------------------------
-- Copyright (c) 2014 Lund University
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014-06-14  1.0      Steffen Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity FSM is
  
  port (
    clk     : in  std_logic;
    n_rst   : in  std_logic;
    start   : in  std_logic;
    stop    : in  std_logic;
    run_cnt : out std_logic;
    set0    : out std_logic);

end entity FSM;

architecture FSM_arch of FSM is

  -----------------------------------------------------------------------------
  -- TODO:
  -----------------------------------------------------------------------------
  type state_type is (state_running, state_pause, state_reset);                -- Add your states of the FSM
  signal  current_state, next_state : state_type;
  
  
begin  -- architecture FSM_arch

  reg : process (clk, n_rst) is
  begin  
    ---------------------------------------------------------------------------
    -- TODO:
    -- Implement the register holding the current_state using signals
    -- current_state and next_state 
    if n_rst = '0' then
    current_state <= state_reset;
    elsif rising_edge(clk) then
    current_state <= next_state;
    end if;
    ---------------------------------------------------------------------------
  end process reg;

  comb : process (current_state, start, stop) is
  begin  
    ---------------------------------------------------------------------------
    -- TODO:
    -- Implement your transition logic based on your FSM graph and set the
    -- outputs.
    next_state <= current_state;
    run_cnt <= '0';
    set0 <= '0';
    case current_state is
    when state_pause =>
    if (start = '1') then
    next_state <= state_running;
    elsif (stop = '1') then
    next_state <= state_reset;
    end if;
    
    when state_running =>
    if (stop = '1') then
    next_state <= state_pause;
    end if;
    
    when state_reset =>
    if (start = '1') then
    next_state <= state_running;
    else 
    next_state <= state_pause;
    end if;
    end case;
    
    case (current_state) is
    when state_pause =>
    run_cnt <= '0';
    set0 <= '0';
    
    when state_running =>
    run_cnt <= '1';
    set0 <= '0';
    when state_reset =>
    run_cnt <= '0';
    set0 <= '1';
    end case;
    
    ---------------------------------------------------------------------------
  end process comb;
    

  end architecture FSM_arch;
