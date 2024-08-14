library ieee;
use ieee.std_logic_1164.all;
use work.ANDgate_23m1200_package.all;
use work.XORgate_23m1200_package.all;
use work.ABCgate_23m1200_package.all;
use work.Cin_map_G_23m1200_package.all;

entity HA is
  port( A,B : in std_logic;
        Sum, Cout: out std_logic);
end entity;

architecture ar1 of HA is
begin
  i1 : XORgate_23m1200 port map(A, B, Sum); -- sum 
  i2 : ANDgate_23m1200 port map(A, B, Cout); -- Carry out
end architecture;