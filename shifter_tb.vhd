library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity	shifter_tb	is
--	no	inputs	or	outputs,	because	it	is	a	testbench
end	shifter_tb;

architecture test of shifter_tb is

signal simshifterIn, simshifterout:  bit_vector (15 downto 0);
signal simshift : std_logic_vector(1 downto 0);

begin
DUT: entity work.shifter(impl) port map(
	shifterin=>simshifterin,
	shifterout=>simshifterout,
	shift=>simshift
	);
	
	process begin
	simshift<="00";
	simshifterIn<="1111000011001111";
	--report "Output is " & to_string(simshifterout) & ", we expected " & to_string(1111000011001111);
	
	wait for 5 ps;
	
	simshift<="01";
	--report "Output is " & to_string(simshifterout) & ", we expected " & to_string(1110000110011110);
	
	wait for 5 ps;
	
	simshift<="10";
	--report "Output is " & to_string(simshifterout) & ", we expected " & to_string(0111100001100111);
	wait for 5 ps;
	simshift<="11";
	--report "Output is " & to_string(simshifterout) & ", we expected " & to_string(1111100001100111);
	wait for 5 ps;
	
	wait;
	end process;
end test;
	

	