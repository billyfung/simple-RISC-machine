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
		status: 	out std_logic_vector(2 downto 0));
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
		status: 	out std_logic_vector(2 downto 0));
end alu;

architecture impl of alu is
begin

	process(all) begin
		case aluop & aluAin(15) & aluBin(15) & aluResult(15) is
			when "00110" | "00001" | "01100" | "01011" => status(2) <= '1';
			when others => status(2) <= '0';
		end case;
	end process;
	
	process(all) begin
		case aluResult(15) is
			when '1' => status(1) <= '1';
			when others => status(1) <= '0';
		end case;
	end process;

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
	    when "0000000000000000" => status(0) <= '1';
	    when others => status(0) <= '0';
	  end case;
	end process;
end;
