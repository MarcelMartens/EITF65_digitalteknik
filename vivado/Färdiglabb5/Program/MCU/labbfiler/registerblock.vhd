----------------------------------------------------------------------------------
-- Namn:        registerblock
-- Filnamn:     registerblock.vhd
-- Testbench:   registerblock_tb.vhd
--
-- Insignaler:
--      clk     - klocksignal, all uppdatering av register sker vid stigande flank
--      n_rst   - synkron resetsignal, aktiv låg
--      F       - resultatet från ALU
--      DEST    - bestämmer vilket av registerna R0 och R1 som ska vara aktivt
--      RegEna  - laddsignal till det aktiva registret
--
-- Utsignaler:
--      RegOut  - det aktiva registrets innehåll
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;
use work.cpu_pkg.all;

entity registerblock is
    port(
        clk : in std_logic;
        n_rst : in std_logic;
        F : in std_logic_vector(7 downto 0);
        DEST : in std_logic;
        RegEna : in std_logic;
        RegOut : out std_logic_vector(7 downto 0)
    );
end entity;

architecture structural of registerblock is
    
begin

end architecture;