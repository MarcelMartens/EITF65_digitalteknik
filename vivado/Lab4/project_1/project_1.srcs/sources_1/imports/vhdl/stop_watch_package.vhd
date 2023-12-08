-------------------------------------------------------------------------------
-- Title      : Package with supplement circuitry
-- Project    : 
-------------------------------------------------------------------------------
-- File       : stop_watch_package.vhd
-- Author     : Steffen Malkowsky  <Steffen@Steffens-MacBook-Air.local>
-- Company    : 
-- Created    : 2014-06-14
-- Last update: 2014-08-27
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Package with supplement elements to be instantiated in structural descriptions
-------------------------------------------------------------------------------
-- Copyright (c) 2014 Lund University
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014-06-14  1.0      Steffen Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package stop_watch_package is

    component debouncer is
    port(
        n_rst, clk   : in  std_logic;
        button_in  : in  std_logic;
        button_out : out std_logic
        );
    end component;

    component sub10 is
    port (
        sub_in : in  std_logic_vector(4 downto 0);
        sub_out : out std_logic_vector(3 downto 0);
        geq : out std_logic);
    end component;

end package stop_watch_package;

-------------------------------------------------------------------------------
-- sub10
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sub10 is
    port (
        sub_in : in  std_logic_vector(4 downto 0);
        sub_out : out std_logic_vector(3 downto 0);
        geq : out std_logic
    );
end sub10;

architecture sub10_arch of sub10 is
    
begin

    sub_if_geq_10 : process (sub_in)
    begin
    
        case sub_in is
            when "01010" =>
                sub_out <= "0000";
                geq <= '1';
            when "01011" =>
                sub_out <= "0001";
                geq <= '1';
            when "01100" =>
                sub_out <= "0010";
                geq <= '1';
            when "01101" =>
                sub_out <= "0011";
                geq <= '1';
            when "01110" =>
                sub_out <= "0100";
                geq <= '1';
            when "01111" =>
                sub_out <= "0101";
                geq <= '1';
            when "10000" =>
                sub_out <= "0110";
                geq <= '1';
            when "10001" =>
                sub_out <= "0111";
                geq <= '1';
            when "10010" =>
                sub_out <= "1000";
                geq <= '1';
            when "10011" =>
                sub_out <= "1001";
                geq <= '1';
            when others =>
                sub_out <= sub_in(3 downto 0);
                geq <= '0';
        end case;
    end process sub_if_geq_10;
end sub10_arch;


-------------------------------------------------------------------------------
-- Debouncer
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debouncer is

  port (
    n_rst, clk   : in  std_logic;
    button_in  : in  std_logic;
    button_out : out std_logic);

end entity debouncer;

architecture debouncer_arch of debouncer is

  signal count_in, count_q : integer range 0 to 2000000;  -- range to count for debouncing

begin  -- architecture debouncer_arch

  -- purpose: Counter registers 
  -- type   : sequential
  -- inputs : clk, n_rst, count_in
  -- outputs: count_q
  reg: process (clk, n_rst) is
  begin  -- process reg
    if n_rst = '0' then                 -- asynchronous reset (active low)
      count_q <= 0;
    elsif clk'event and clk = '1' then  -- rising clock edge
      count_q <= count_in;
    end if;
  end process reg;

  -- purpose: Combinational process for counter
  -- type   : combinational
  -- inputs : button_in, count_q
  -- outputs: button_out, count_in
  comb: process (button_in, count_q) is
  begin  -- process comb
    -- Default values
    count_in <= count_q;
    button_out <= '0';

    if button_in = '1' then
      if count_q < 2000000 then
        count_in <= count_q + 1;
      else
        count_in <= 2000000;
      end if;
    else
      count_in <= 0;
    end if;

    if count_q = 2000000 then
      button_out <= '1';
    end if;
  end process comb;

end architecture debouncer_arch;

