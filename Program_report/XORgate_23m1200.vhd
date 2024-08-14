library ieee;
use ieee.std_logic_1164.all;

entity XORgate_23m1200 is
	port ( A, B : in std_logic;
		    uneq : out std_logic);
end entity;

architecture ar1 of XORgate_23m1200 is 

begin
	uneq <= A xor B after 600 ps; -- delay = 600 + 2*00 ps = 600ps (23m1200)
end architecture;