-- synthesis VHDL_INPUT_VERSION VHDL_2008

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

package alu_declarations is
	component alu is
		port(
		aluAin, aluBin : in std_logic_vector(15 downto 0);
		aluOp : in std_logic_vector(1 downto 0);
		aluResult : out std_logic_vector(15 downto 0);
		status: 	out std_logic);
	end component;
end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity alu is
	port(
		aluAin, aluBin : in std_logic_vector(15 downto 0);
		aluOp : in std_logic_vector(1 downto 0);
		aluResult : buffer std_logic_vector(15 downto 0);
		status: 	out std_logic);
end alu;

architecture impl of alu is
begin

process(all)
	begin
		case aluOp is
			when "00" => aluResult <= aluAIn + aluBIn;
			when "01" => aluResult <= aluAIn - aluBIn;
			when "10" => aluResult <= aluAin and aluBin;
			when others => aluResult <= not aluBin;
		end case;
	end process;	
	
	process(all) begin
	  case aluresult is
	    when "0000000000000000" => status <= '1';
	    when others => status <= '0';
	  end case;
	end process;
end;
