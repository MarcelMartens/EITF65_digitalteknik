-------------------------------------------------------------------------------
-- Title      : Binary to Natural Binary Coded Decimal decoder
-- Project    : 
-------------------------------------------------------------------------------
-- File       : nbcd.vhd
-- Author     : Steffen Malkowsky  <Steffen@Steffens-MacBook-Air.local>
-- Company    : 
-- Created    : 2014-06-14
-- Last update: 2015-06-01
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Converts the input signal from the counter into NBCD format.
-------------------------------------------------------------------------------
-- Copyright (c) 2014 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2014-06-14  1.0      Steffen	Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity nbcd is
  
  port (
    binary : in  std_logic_vector(6 downto 0);
    tens : out std_logic_vector(3 downto 0);
    ones : out std_logic_vector(3 downto 0));

end entity nbcd;

architecture nbcd_structural of nbcd is

    -----------------------------------------------------------------------------
    -- TODO:
    -- Declare all internal signals of the NBCD decoder here, i.e. all the signals 
    -- needed between the sub10 blocks
    -----------------------------------------------------------------------------
    signal zero : std_logic;
    signal sub_in1 : std_logic_vector(4 downto 0);
    signal sub_out1 : std_logic_vector(3 downto 0);
    signal sub_in2 : std_logic_vector(4 downto 0);
    signal sub_out2 : std_logic_vector(3 downto 0);
    signal sub_in3 : std_logic_vector(4 downto 0);
    signal sub_out3 : std_logic_vector(3 downto 0);
    signal sub_in4 : std_logic_vector(4 downto 0);
    signal sub_out4 : std_logic_vector(3 downto 0);
    signal geq1 : std_logic;
    signal geq2 : std_logic;
    signal geq3 : std_logic;
    signal geq4 : std_logic;

    
    
begin
    zero <= '0';

    -- Wire signals
    sub_in1 <= zero & binary(6 downto 3);

    sub10_1: entity sub10 port map (
        sub_in => sub_in1,
        sub_out => sub_out1,
        geq => geq1
    );

    -----------------------------------------------------------------------------
    -- TODO:
    -- Add additional sub10 blocks to implement the division algorithm
    -----------------------------------------------------------------------------    
        sub_in2 <= sub_out1 & binary(2);

    sub10_2: entity sub10 port map (
        sub_in => sub_in2,
        sub_out => sub_out2,
        geq => geq2
    );
        sub_in3 <= sub_out2 & binary(1);

    sub10_3: entity sub10 port map (
        sub_in => sub_in3,
        sub_out => sub_out3,
        geq => geq3
    );
        sub_in4 <= sub_out3 & binary(0);

    sub10_4: entity sub10 port map (
        sub_in => sub_in4,
        sub_out => sub_out4,
        geq => geq4
    );
    
    -----------------------------------------------------------------------------
    -- TODO:
    -- Route the output signals
    -----------------------------------------------------------------------------      
    tens <= (geq1,geq2,geq3,geq4);
    ones <= sub_out4;
     
end architecture nbcd_structural;
