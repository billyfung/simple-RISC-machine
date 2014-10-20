library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity	regfile_tb	is
--	no	inputs	or	outputs,	because	it	is	a	testbench
end	regfile_tb;

architecture test of regfile_tb is

signal simclk, simwe : std_logic;
signal simreadnum, simwritenum: std_logic_vector( 2 downto 0);
signal simwrite_value, simread_value: std_logic_vector(15 downto 0);

begin

DUT: entity work.register_file(impl) port map(
	clk=>simclk, 
	we=>simwe, 
	readnum=>simreadnum,
	writenum=>simwritenum,
	write_value=>simwrite_value,
	read_value=>simread_value);
	
	process begin
	--initial starting values, check to see if output is read correctly when we not on
	simclk<='0';
	simwe<='0';
	simreadnum<="000";
	simwritenum<="000";
	simwrite_value<="1111000011001111";
	report "Output of register " & to_string(simreadnum) & " is  " & to_string(simread_value);
	wait for 5 ps;
	--clock rises, but we is not 1
	simclk<='1';
	report "Output of register " & to_string(simreadnum) & " is  " & to_string(simread_value);
	wait for 2 ps;
	--output should stay the same
	simwe<='1';
	
	wait for 5 ps;
	
	simreadnum<="001";
	
	wait for 1 ps;
	
	simwritenum<="001";
	simwrite_value<="1111111100000000";
	simclk<='0';
	wait for 5 ps;
	simclk<='1';
	report "Output of register " & to_string(simreadnum) & " is  " & to_string(simread_value);
	wait for 5 ps;
	
	simreadnum<="000";
	wait for 2 ps;
	
	simclk<='0';
	simwritenum<="000";
    simwrite_value<="1111000011001111";
	wait for 2 ps;
	
	simclk<='1';
	report "Output of register " & to_string(simreadnum) & " is  " & to_string(simread_value);
	wait for 1 ps;
	
	simclk<='0';
	simwritenum<="110";
	simwrite_value<="1111001111001111";
	simreadnum<="001";
	wait for 2 ps;
	
	simclk<='1';
	wait for 1 ps;
	
	simreadnum<="110";
	report "Output of register " & to_string(simreadnum) & " is  " & to_string(simread_value);
	simclk<='0';
	simwe<='0';
	wait for 5 ps;
	simreadnum<="000";
	wait for 5 ps;
	simreadnum<="001";
	simwe<='1';
	simwritenum<="000";
	simwrite_value<="1111111111111111";
	simclk<='1';
	report "Output of register " & to_string(simreadnum) & " is  " & to_string(simread_value);
	wait for 5 ps;
	simreadnum<="010";
	report "Output of register " & to_string(simreadnum) & " is  " & to_string(simread_value);
	simclk<='0';
	wait for 5 ps;
	simreadnum<="110";
	report "Output of register " & to_string(simreadnum) & " is  " & to_string(simread_value);
	wait for 5 ps;
	
	wait;
	

end	process;
end	test;
	
	