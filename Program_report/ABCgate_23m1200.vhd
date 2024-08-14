library ieee;
use ieee.std_logic_1164.all;

entity ABCgate_23m1200 is
	port ( A, B, C : in std_logic;
		    ABC : out std_logic);
end entity;

architecture ar1 of ABCgate_23m1200 is 

begin
	ABC <= A or (B and C) after 400 ps; -- delay = 400 + 00 ps = 400ps (23m1200)
end architecture;