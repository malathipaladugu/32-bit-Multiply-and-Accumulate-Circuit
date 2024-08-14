library ieee;
use ieee.std_logic_1164.all;
use work.ANDgate_23m1200_package.all;
use work.XORgate_23m1200_package.all;
use work.ABCgate_23m1200_package.all;
use work.Cin_map_G_23m1200_package.all;

entity FA is
  port( A,B,Cin : in std_logic;
        Sum, Cout: out std_logic);
end entity;

architecture ar1 of FA is
 signal Tmp_P : std_logic;
begin
  i1 : XORgate_23m1200 port map(A, B, Tmp_P);
  i2 : XORgate_23m1200 port map(Tmp_P, Cin, Sum); -- sum 
  i3 : Cin_map_G_23m1200 port map(A, B, Cin, Cout); -- Carry out
end architecture;