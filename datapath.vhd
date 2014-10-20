-- synthesis VHDL_INPUT_VERSION VHDL_2008
library ieee;
use ieee.std_logic_1164.all;
use work.alu_declarations.all;
use work.shifter_declarations.all;
use work.register_file_declarations.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

package datapath_declarations is
  component datapath is
    generic( word_size : integer := 16; 
             data_width: integer := 32; 
             addr_width: integer := 4);
    port (clk          : in std_logic;
          reset        : in std_logic;
          datapath_in  : in std_logic_vector(7 downto 0);
          write        : in std_logic;
          readnum      : in std_logic_vector(2 downto 0);
          vsel         : in std_logic;
          loada        : in std_logic;
          loadb        : in std_logic;
          shift        : in std_logic_vector(1 downto 0);
          asel         : in std_logic;
          bsel         : in std_logic;
          ALUop        : in std_logic_vector(1 downto 0);
          loadc        : in std_logic;
          loads        : in std_logic;
          writenum     : in std_logic_vector(2 downto 0);
          status       : buffer std_logic;
          datapath_out : out std_logic_vector(word_size-1 downto 0) );
  end component;
end package;

library ieee;
use ieee.std_logic_1164.all;
use work.register_file_declarations.all;
use work.ff.all;
use work.shifter_declarations.all;
use work.alu_declarations.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity datapath is
  generic( word_size : integer := 16 );
  port (clk          : in std_logic;
        reset        : in std_logic;
        datapath_in  : in std_logic_vector(7 downto 0);
        write        : in std_logic;
        readnum      : in std_logic_vector(2 downto 0);
        vsel         : in std_logic_vector(1 downto 0);
        loada        : in std_logic;
        loadb        : in std_logic;
        shift        : in std_logic_vector(1 downto 0);
        asel         : in std_logic;
        bsel         : in std_logic;
        ALUop        : in std_logic_vector(1 downto 0);
        loadc        : in std_logic;
        loads        : in std_logic;
        writenum     : in std_logic_vector(2 downto 0);
        status       : buffer std_logic;
        datapath_out : out std_logic_vector(word_size-1 downto 0) );
end datapath;

architecture impl of datapath is
signal read_value, write_value, ainbsel, binbshft, binbsel, ain, bin, aluout, cout, dout: std_logic_vector (word_size-1 downto 0);
signal addr, pcout, pcin, IRout, loadpcOUT, resetOUT: std_logic_vector(addr_width-1 downto 0);
signal sximm5,sximm8: std_logic_vector(word_size-1 downto 0);
signal Z, N, V :  std_logic;
--signal binbshft, binbsel: bit_vector (15 downto 0);
begin
  
  REGA:		vDFFE generic map(word_size) port map(clk, loada, read_value, ainbsel );
  SHIFTR:	shifter port map(binbshft, shift, binbsel);
  REGB:		vDFFE generic map(word_size) port map(clk, loadb, read_value, binbshft );
  ALUDP:		alu 	port map(ain, bin, ALUop, aluout, status);
  REGC:		vDFFE generic map(word_size) port map(clk, loadc, aluout, cout );
  REGFIL:	register_file generic map(word_size) port map(clk, readnum, writenum, write_value, write, read_value);
  RAM: RAM generic map(addr_width) port map(clk, addr, write, din, dout);
  PC: vDFF generic map(word_size) port map(clk, PCin, PCout);
  IR: vDFFe generic map(word_size) port map(clk, loadir, IRout)
  
 -- bin <= (11b"0" & datapath_in(4 downto 0)) when bsel = '1' else binbsel;
 -- ain <=	(16b"0") when asel = '1' else ainbsel;
 -- write_value <= (8b"0" & datapath_in) when vsel = '1' else cout;
  datapath_out <= cout;
  
  process(all) begin
		case bsel is
			when '1' => bin <= sximm5;
			when others => bin <= binbsel;
		end case;
  end process;
  
  process(all) begin
		case asel is
			when '1' => ain <= (16b"0");
			when others => ain <= ainbsel;
		end case;
  end process;
  
  process(all) begin
		case vsel is
			when "11" => write_value <= mdata;
			when "10" => write_value <= sximm8;
			when "01" => write_value <= PCout;
			when others => write_value <= cout;
		end case;
  end process;

  process(all) begin
    case loadpc is
      when '1' => loadpcOUT <= PCout + 1;
      when others => loadpcOUT <= PCout;
    end case;
  end process;

  process(all) begin
    case reset is
      when '1' => resetOUT <= (others=>'0');
      when others => resetOUT <= loadpcOUT;
    end case;
  end process;
  
  --figure 7 instruction decoder
  opcode <= IRout(15 down to 13);
  op <= IRout(12 downto 11);
  ALUOp<= IRout(12 downto 11);
  sximm5 <= std_logic_vector(resize(signed(IRout(4 downto 0)), 16));
  sximm8 <= std_logic_vector(resize(signed(IRout(7 downto 0)), 16));
  shift <= IROut(4 downto 3);
  
  process(all) begin
  case nsel is
	when "11" => readnum <= IRout(10 downto 8); writenum <= IRout(10 downto 8); --Rn
	when "10" => readnum <= IRout(7 downto 5); writenum <= IRout(7 downto 5); --Rd
	when "01" => readnum <= IRout(2 downto 0); writenum <= IRout(2 downto 0); --Rm
	when others => readnum <= '-'; writenum <= '-';
	end case;
  end process;
  
end impl;
