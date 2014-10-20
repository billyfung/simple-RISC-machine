-- synthesis VHDL_INPUT_VERSION VHDL_2008

library ieee;
use ieee.std_logic_1164.all;

package register_file_declarations is
  component register_file is
    generic( word_size: integer := 16; addr_size: integer := 3 );
    port( clk: in std_logic;
          readnum: in std_logic_vector(addr_size-1 downto 0);
          writenum: in std_logic_vector(addr_size-1 downto 0);
          write_value: in std_logic_vector(word_size-1 downto 0);
          we : in std_logic;
          read_value: out std_logic_vector(word_size-1 downto 0) );
  end component;
  
 /* component reg is
		generic( word_size: int := 16);
		port(	i: in std_logic_vector (word_size-1 downto 0);
				o: out std_logic_vector (word_size-1 downto 0));
	end component; */
end package;

--------------------------------------------------------------------------------
/*
library ieee;
use ieee.std_logic_1164.all;
use work.register_file_declarations.all;
use ieee.numeric_std.all;

entity reg is
	generic( word_size: int := 16);
	port(	i: in std_logic_vector (word_size-1 downto 0);
			o: out std_logic_vector (word_size-1 downto 0));
end reg;


architecture impl of reg is
*/


library ieee;
use ieee.std_logic_1164.all;
use work.register_file_declarations.all;
use ieee.numeric_std.all;

entity register_file is
 generic( word_size: integer := 16; addr_size: integer := 3 );
  port( clk: in std_logic;
        readnum: in std_logic_vector(addr_size-1 downto 0);
        writenum: in std_logic_vector(addr_size-1 downto 0);
        write_value: in std_logic_vector(word_size-1 downto 0);
        we : in std_logic;
        read_value: out std_logic_vector(word_size-1 downto 0) );
end register_file;

architecture impl of register_file is
	signal reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7 : std_logic_vector ( word_size-1 downto 0 );
begin
  -------------\p
	process(all) begin
		case readnum is
			when "000" => read_value <= reg0;
			when "001" => read_value <= reg1;
			when "010" => read_value <= reg2;
			when "011" => read_value <= reg3;
			when "100" => read_value <= reg4;
			when "101" => read_value <= reg5;
			when "110" => read_value <= reg6;
			when "111" => read_value <= reg7;
			when others => read_value <= reg0;
		end case;
	end process;
	
	process(clk) begin
		if rising_edge(clk) then
			case? we & writenum is
				when "0---" => reg0 <= reg0;
				when "1000" => reg0 <= write_value;
				when "1001" => reg1 <= write_value;
				when "1010" => reg2 <= write_value;
				when "1011" => reg3 <= write_value;
				when "1100" => reg4 <= write_value;
				when "1101" => reg5 <= write_value;
				when "1110" => reg6 <= write_value;
				when "1111" => reg7 <= write_value;
			  when others => reg0 <= write_value;
			end case?;
		end if;
	end process;				
end impl;
