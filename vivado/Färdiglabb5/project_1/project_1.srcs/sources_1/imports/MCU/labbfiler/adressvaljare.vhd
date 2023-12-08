----------------------------------------------------------------------------------
-- Namn:        adressvaljare
-- Filnamn:     adressvaljare.vhd
-- Testbench:   adressvaljare_tb.vhd
--
-- Insignaler:
--      clk     - klocksignal, all uppdatering av register sker vid stigande flank
--      n_rst   - synkron resetsignal, aktiv låg
--      DATA    - de 6 minst signifikanta bitarna från instruktionen, används då 
--                nästa adress anges av instruktionen
--      AddrSrc - bestämmer varifrån nästa adress ska hämtas
--      StackOp - styr stacken i adressväljaren
--
-- Utsignaler:
--      A           - nästa adress
--      pc_debug    - nuvarande adress, används för att visa adressen på 
--                    Nexys4 display
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;
use work.cpu_pkg.all;

entity adressvaljare is
    port(
        clk, n_rst : in std_logic;
        DATA : in std_logic_vector(5 downto 0);
        A : out std_logic_vector(5 downto 0);
        AddrSrc : in std_logic_vector(1 downto 0);
        StackOp : in std_logic_vector(1 downto 0);
        pc_debug : out std_logic_vector(5 downto 0)
    );
end entity;

architecture structural of adressvaljare is

 signal Tos, pc_reg, pc_plus, mux_out : std_logic_vector(5 downto 0);
 signal alu_out, alu_in : std_logic_vector(7 downto 0);
   
begin

    alu_in <= "00" & pc_reg;
    pc_plus <= alu_out(5 downto 0);
    pc_debug <= pc_reg;
    A <= mux_out;

    stack1: entity stack port map(
        StackOp => Stackop,
        clk => clk,
        n_rst => n_rst,
        D => pc_plus,
        ToS => ToS
    );
    
    mux: entity MUX3x6 port map(
    O => mux_out,
    IN0 => pc_plus,
    IN1 => Tos,
    IN2 => DATA,
    SEL => AddrSrc
    );
    
    alu: entity ALU8 port map(
    Z => open,
    A => alu_in,
    B => "00000001",
    S => "010",
    F => alu_out
    );
    
    reg: entity REG6 port map(
    CLR => n_rst,
    CLK => clk,
    ENA => '1',
    D => mux_out,
    Q => pc_reg
    ); 
    
end architecture;