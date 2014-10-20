-- synthesis VHDL_INPUT_VERSION VHDL_2008

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

package shifter_declarations is
	component shifter is
		port(shifterIn : in std_logic_vector (15 downto 0);
		shift : in std_logic_vector(1 downto 0);
		shifterOut : out std_logic_vector (15 downto 0));
	end component;
end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

--shifter to take 16 bit input from register B and then output 
--

entity shifter is
	port(shifterIn : in std_logic_vector (15 downto 0);
		shift : in std_logic_vector(1 downto 0);
		shifterOut : out std_logic_vector (15 downto 0));
end shifter;

architecture impl of shifter is
begin
	process(all)
	begin
		case shift is
			when "00" => shifterOut <= shifterIn;
			when "01" => shifterOut <= to_stdlogicvector(to_bitvector(shifterIn) sll 1);
			when "10" => shifterOut <= to_stdlogicvector(to_bitvector(shifterIn) srl 1);
			when others => shifterOut <= to_stdlogicvector(to_bitvector(shifterIn) sra 1);
		end case;
	end process;
end;