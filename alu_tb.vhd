library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity	alu_tb	is
--	no	inputs	or	outputs,	because	it	is	a	testbench
end	alu_tb;

architecture test of alu_tb is
  
  signal  ain   : std_logic_vector( 15 downto 0);
  signal  bin   : std_logic_vector( 15 downto 0);
  signal  aluop : std_logic_vector( 1 downto 0 );
  signal  aluout : std_logic_vector( 15 downto 0);
  signal  status : std_logic;
  
begin
  DUT: entity work.ALU(impl) port map( ALUain => ain,
        ALUbin => bin,
        aluop => aluop,
        aluresult => aluout,
        status => status);
        --1111111100000000
  process begin
    ain <= "1111111100000000";
    bin <= "0000000011111111";
    aluop <= "00";
    wait for 10 ns;
    aluop <= "01";
    wait for 10 ns;
    aluop <= "01";
    wait for 10 ns;
    aluop <= "11";
    wait for 10 ns;
    
    ain <= "0000111111000000";
    bin <= "0000001111110000";
    aluop <= "10";
    wait for 10 ns;
    aluop <= "11";
    wait for 10 ns;
    
    ain <= "1111111111111111";
    bin <= "1111111111111111";
    aluop <= "01";
    wait for 10 ns;
  
    wait;
  end process;
end test;