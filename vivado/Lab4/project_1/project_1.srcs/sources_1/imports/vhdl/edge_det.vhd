library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity edge_det is

  port (
    clk, n_rst : in  std_logic;
    inp        : in  std_logic;
    det_edge   : out std_logic);

end entity edge_det;

architecture edge_det_arch of edge_det is

  signal reg_q : std_logic;
  signal reg_q_next : std_logic;

begin  -- architecture edge_det_arch


  -- purpose: register
  -- type   : sequential
  -- inputs : clk, n_rst, reg_in
  -- outputs: reg_q
  reg : process (clk, n_rst) is
  begin
  -----------------------------------------------------------------------------
  -- TODO:
  -- Implement register if necessary
  if n_rst = '0' then
    reg_q <= '0';
  elsif rising_edge(clk) then
    reg_q <= reg_q_next;
  end if;
  -----------------------------------------------------------------------------
  end process reg;
  
------------------------------------------------------------------------
  -- TODO:
  -- Implement the combinational logic to detect the rising edge as drawn in
  -- the home exercise

  
  reg_q_next <= inp;
  det_edge <= (not reg_q) and inp;
  
  -----------------------------------------------------------------------------

end architecture edge_det_arch;
