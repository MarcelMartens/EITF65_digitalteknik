----------------------------------------------------------------------------------
-- Namn:        stack
-- Filnamn:     stack.vhd
-- Testbench:   stack_tb.vhd
--
-- Insignaler:
--      clk     - klocksignal, all uppdatering av register sker vid stigande flank
--      n_rst   - synkron resetsignal, aktiv låg
--      D       - data in till stacken
--      StackOp - styr stackens beteende
--
-- Utsignaler:
--      ToS     - värdet av stackens översta element
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;
use work.cpu_pkg.all;

entity stack is
    port(
        D : in std_logic_vector(5 downto 0);
        ToS : out std_logic_vector(5 downto 0);
        clk, n_rst : in std_logic;
        StackOp : in std_logic_vector(1 downto 0)
    );
end entity;

architecture structural of stack is
    
    
begin

    -- Tips: för att instansiera en komponent används följande syntax
    -- label_of_component: entity component_name port map(
    --      component_signal_a => signal_in_this_architectiure_a,
    --      component_signal_b => signal_in_this_architectiure_b
    -- );

end architecture;