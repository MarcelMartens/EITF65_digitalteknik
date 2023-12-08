-------------------------------------------------------------------------------
-- Title      : Counter
-- Project    : 
-------------------------------------------------------------------------------
-- File       : counter.vhd
-- Author     : Steffen Malkowsky  <Steffen@Steffens-MacBook-Air.local>
-- Company    : 
-- Created    : 2014-06-14
-- Last update: 2014-07-12
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Counter for the stop watch
-------------------------------------------------------------------------------
-- Copyright (c) 2014 Lund University
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014-06-14  1.0      Steffen Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fast_counter is
  
  port (
    clk      : in  std_logic;
    n_rst    : in  std_logic;
    run      : in  std_logic;
    set0     : in  std_logic;
    sec_int  : out std_logic_vector(6 downto 0);
    sec_frac : out std_logic_vector(6 downto 0));

end entity fast_counter;

architecture Counter_arch of fast_counter is

  signal cnt_q, cnt_in : std_logic_vector(14 downto 0);
  signal cnt_int_in, cnt_int_q : std_logic_vector(6 downto 0);
  signal cnt_frac_in, cnt_frac_q : std_logic_vector(6 downto 0);

begin  -- architecture Counter_arch

  -- purpose: This process implements registers for saving the counter values
  -- type   : sequential
  -- inputs : clk, n_rst, cnt_in, cnt_int_in, cnt_frac_in
  -- outputs: cnt_q, cnt_int_q, cnt_frac_q
  reg : process (clk, n_rst) is
  begin  -- process reg
    if n_rst = '0' then                 -- asynchronous reset (active low)
      cnt_q      <= (others => '0');
      cnt_int_q  <= (others => '0');            
      cnt_frac_q <= (others => '0');
    elsif clk'event and clk = '1' then  -- rising clock edge
      cnt_q      <= cnt_in;
      cnt_int_q  <= cnt_int_in;
      cnt_frac_q <= cnt_frac_in;
    end if;
  end process reg;

-- purpose: Implement the combinational part of the circuit.
-- type   : combinational
-- inputs : cnt_q, cnt_int_q, cnt_frac_q, run, set0
-- outputs: cnt_in, cnt_int_in, cnt_frac_in
  comb : process (cnt_q, cnt_int_q, cnt_frac_q, run, set0) is
  begin  -- process comb
    -- Default values
    cnt_in      <= cnt_q;
    cnt_int_in  <= cnt_int_q;
    cnt_frac_in <= cnt_frac_q;

    -- If set0 is set, clear all counter values
    if set0 = '1' then
      cnt_in      <= (others => '0');
      cnt_int_in  <= (others => '0');
      cnt_frac_in <= (others => '0');
    -- If run is set, count values
    elsif run = '1' then
      cnt_in <= std_logic_vector(unsigned(cnt_q)+1);
      -- Counted 1/100s
      if to_integer(unsigned(cnt_q)) = 9999 then
        cnt_frac_in <= std_logic_vector(unsigned(cnt_frac_q)+1);
        cnt_in      <= (others => '0');
        -- Counted 1s
        if to_integer(unsigned(cnt_frac_q)) = 99 then
          if to_integer(unsigned(cnt_int_q)) < 99 then
            cnt_int_in <= std_logic_vector(unsigned(cnt_int_q)+1);
          else
            cnt_int_in <= (others => '0');
          end if;
          cnt_frac_in <= (others => '0');
        end if;
      end if;
    end if;
  end process comb;

  -- Assign counter registers to output
  sec_int <= cnt_int_q;
  sec_frac <= cnt_frac_q;
  
end architecture Counter_arch;
