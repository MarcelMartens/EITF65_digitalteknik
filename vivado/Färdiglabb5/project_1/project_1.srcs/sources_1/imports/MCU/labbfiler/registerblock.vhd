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
signal r0_out, r1_out : std_logic_vector(7 downto 0);
signal ena0, ena1 : std_logic;
    
begin
--Digital logik
ena0 <= RegEna and not(Dest);

ena1 <= RegEna and Dest;


 -- entities:
    r0: entity REG8 port map(
        CLK => clk,
        CLR => n_rst,
        D => F,
        Q => r0_out,
        ENA => ena0
    );
    
    r1: entity REG8 port map(
        CLK => clk,
        CLR => n_rst,
        D => F,
        Q => r1_out,
        ENA => ena1
    );
    
    mux: entity MUX2x8 port map(
    IN0 => r0_out,
    IN1 => r1_out,
    SEL => DEST,
    O => RegOut
    );

end architecture;