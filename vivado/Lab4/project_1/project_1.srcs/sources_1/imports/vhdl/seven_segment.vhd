-------------------------------------------------------------------------------
-- Title      : seven segment display driver
-- Project    : 
-------------------------------------------------------------------------------
-- File       : SevenSegment.vhd
-- Author     : 
-- Company    : 
-- Created    : 2011-09-07
-- Last update: 2014-07-12
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: seven segment display driver
-------------------------------------------------------------------------------
-- Copyright (c) 2011 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2011-09-07  1.0      chm	Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SevenSegment is
  
  port (
    clk                    : in  std_logic;  -- clock
    nRST                   : in  std_logic;  -- asynchronous low active reset
    seg0, seg1, seg2, seg3 : in  std_logic_vector(3 downto 0);  -- 4 segment inputs
    --dot                    : in  std_logic_vector(1 downto 0);  -- decimal dot
    anode                  : out std_logic_vector(3 downto 0);  -- anode data
    Seven_Seg              : out std_logic_vector(6 downto 0));  -- segment output

end SevenSegment;

architecture segmentDriver of SevenSegment is

  signal counter : std_logic_vector(17 downto 0);

  signal seg : std_logic_vector(3 downto 0);
  signal segment_led : std_logic_vector(7 downto 0);
  signal cur_segment : std_logic_vector(1 downto 0);
  
  
begin  -- segmentDriver

  cur_segment <= counter(17 downto 16);
  
  -- purpose: count to switch between the segments
  -- type   : sequential
  -- inputs : clk, nRST
  -- outputs: counter
  segment_counter: process (clk, nRST)
  begin  -- process segment_counter
    if nRST = '0' then                  -- asynchronous reset (active low)
      counter <= (others => '0');
    elsif clk'event and clk = '1' then  -- rising clock edge
      counter <= std_logic_vector(unsigned(counter) + 1);
    end if;
  end process segment_counter;

  -- purpose: set anode and segment for current segment
  -- type   : combinational
  -- inputs : cur_segment, dot
  -- outputs: anode, seg
  segment_switch: process (cur_segment, seg0, seg1, seg2, seg3)
  begin  -- process segment_logic
    case cur_segment is
      when "00" => seg <= seg0; anode <= "0111";
      when "01" => seg <= seg1; anode <= "1011";
      when "10" => seg <= seg2; anode <= "1101";
      when "11" => seg <= seg3; anode <= "1110";
      when others => seg <= seg0; anode <= "1000";
    end case;
  end process segment_switch;

  -- purpose: translate BCD to 7Segment
  -- type   : combinational
  -- inputs : seg
  -- outputs: Seven_Seg
  segment_encode: process (seg)
  begin  -- process segment_encode
    case seg is
      when "0000" => Seven_Seg <= "1000000";  -- 0
      when "0001" => Seven_Seg <= "1111001";  -- 1
      when "0010" => Seven_Seg <= "0100100";  -- 2
      when "0011" => Seven_Seg <= "0110000";  -- 3
      when "0100" => Seven_Seg <= "0011001";  -- 4
      when "0101" => Seven_Seg <= "0010010";  -- 5
      when "0110" => Seven_Seg <= "0000010";  -- 6
      when "0111" => Seven_Seg <= "1111000";  -- 7
      when "1000" => Seven_Seg <= "0000000";  -- 8
      when "1001" => Seven_Seg <= "0010000";  -- 9 
      when "1010" => Seven_Seg <= "0001000";  -- A
      when "1011" => Seven_Seg <= "0000011";  -- b
      when "1100" => Seven_Seg <= "1000110";  -- C
      when "1101" => Seven_Seg <= "1111111";  -- 
      when "1110" => Seven_Seg <= "0111111";  -- -
      when "1111" => Seven_Seg <= "0001110";  -- F
      when others => Seven_Seg <= "1111111";  -- .
    end case;
  end process segment_encode;

end segmentDriver;
