library ieee;
use ieee.std_logic_1164.all;

entity Cin_map_G_23m1200 is
	port ( A, B, Cin : in std_logic;
		    Bit0_G : out std_logic);
end entity;

architecture ar1 of Cin_map_G_23m1200 is 

begin
	Bit0_G <= (A and B) or (Cin and (A or B)) after 600 ps; -- delay = 600 + 2*00 ps = 600ps (23m1200)
end architecture;