-- Copyright (C) Tor M. Aamodt, UBC
-- synthesis VHDL_INPUT_VERSION VHDL_2008
-- Ensure your CAD synthesis tool/compiler is configured for VHDL-2008.

library ieee;
use ieee.std_logic_1164.all;

package ff is
  component vDFF is -- (vector) n-bit D Flip-Flop 
    generic( n: integer := 1 );
    port( clk: in std_logic;
          D: in std_logic_vector( n-1 downto 0 );
          Q: out std_logic_vector( n-1 downto 0 ) );
  end component;

  component sDFF is -- (scalar) D Flip-Flop
    port( clk: in std_logic;
          D: in std_logic;
          Q: out std_logic );
  end component;

  component vDFFE is -- n-bit Register with Load Enable (use sDFFE for std_logic)
    generic( n: integer := 1 );
    port( clk, en: in std_logic;
          D: in std_logic_vector( n-1 downto 0 );
          Q: buffer std_logic_vector( n-1 downto 0 ) );
  end component;

  component sDFFE is
    port( clk, en: in std_logic;
          D: in std_logic;
          Q: buffer std_logic );
  end component;

  component vDFFRE is -- (vector) n-bit DFF w/ synchronous reset and load enable
    generic( n: integer := 1 );
    port( clk, rst, en: in std_logic;
          D: in std_logic_vector( n-1 downto 0 );
          Q: buffer std_logic_vector( n-1 downto 0 ) );
  end component;

  component RAM is -- Read-Write Memory
    generic( data_width: integer := 32; 
             addr_width: integer := 4;
             modelsim_filename: string := "data.bin";
             quartus_filename: string := "data.mif" );
    port( clk: in std_logic;
          addr: in std_logic_vector(addr_width-1 downto 0);
          write: in std_logic;
          din: in std_logic_vector(data_width-1 downto 0);
          dout: out std_logic_vector(data_width-1 downto 0) );
  end component;
end package;

-------------------------------------------------------------------------------
-- Flip-flop
library ieee;
use ieee.std_logic_1164.all;

entity vDFF is
  generic( n: integer := 1 );
  port( clk: in std_logic;
        D: in std_logic_vector( n-1 downto 0 );
        Q: out std_logic_vector( n-1 downto 0 ) );
end vDFF;

architecture impl of vDFF is
begin
  process(clk) begin
    if rising_edge(clk) then
      Q <= D;
    end if;
  end process;
end impl;

library ieee;
use ieee.std_logic_1164.all;

entity sDFF is
  port( clk: in std_logic;
        D: in std_logic;
        Q: out std_logic );
end sDFF;

architecture impl of sDFF is
begin
  process(clk) begin
    if rising_edge(clk) then
      Q <= D;
    end if;
  end process;
end impl;

-------------------------------------------------------------------------------
-- Flip-flop with load enable input (following 259 coding style)

library ieee;
use ieee.std_logic_1164.all;

entity vDFFE is -- n-bit register with load enable (use sDFFE for std_logic)
  generic( n: integer := 1 ); 
  port( clk, en: in std_logic;
        D: in std_logic_vector( n-1 downto 0 );
        Q: buffer std_logic_vector( n-1 downto 0 ) );
end vDFFE;

architecture impl of vDFFE is
  signal Q_next: std_logic_vector(n-1 downto 0);
begin
  Q_next <= D when en else Q;

  process(clk) begin
    if rising_edge(clk) then
      Q <= Q_next;
    end if;
  end process;
end impl;

--

library ieee;
use ieee.std_logic_1164.all;

entity sDFFE is
  port( clk, en: in std_logic;
        D: in std_logic;
        Q: buffer std_logic );
end sDFFE;

architecture impl of sDFFE is
  signal Q_next: std_logic;
begin
  Q_next <= D when en else Q;

  process(clk) begin
    if rising_edge(clk) then
      Q <= Q_next;
    end if;
  end process;
end impl;

-------------------------------------------------------------------------------
-- Flip-flop with (synchronous) reset and enable (following 259 coding style)
library ieee;
use ieee.std_logic_1164.all;

entity vDFFRE is
  generic( n: integer := 1 ); -- width
  port( clk, rst, en: in std_logic;
        D: in std_logic_vector( n-1 downto 0 );
        Q: buffer std_logic_vector( n-1 downto 0 ) );
end vDFFRE;

architecture impl of vDFFRE is
  signal Q_next, Q_next_reset: std_logic_vector(n-1 downto 0);
begin
  process(clk) begin
    if rising_edge(clk) then
      Q <= Q_next_reset;
    end if;
  end process;

  Q_next <= D when en else Q;
  Q_next_reset <= Q_next when not rst else (others => '0');
end impl;

-------------------------------------------------------------------------------
-- To ensure Quartus uses the embedded MLAB memory blocks inside the Cyclone II
-- on your DE2 we follow the coding style from "Example 12-12: VHDL Single-
-- Clock Simple Dual-Port Synchronous RAM with Old Data Read-During-Write 
-- Behavior" in Altera's PDF document "Recommended HDL Coding Styles" QII51007,
-- 2014.06.30

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use work.ff.all;

entity RAM is
  generic( data_width: integer := 32; 
           addr_width: integer := 4;
           modelsim_filename: string := "data.bin";
           quartus_filename: string := "data.mif" );
  port( clk: in std_logic;
        addr: in std_logic_vector(addr_width-1 downto 0);
        write: in std_logic;
        din: in std_logic_vector(data_width-1 downto 0);
        dout: out std_logic_vector(data_width-1 downto 0) );
end RAM;

architecture impl of RAM is
  subtype word_t is std_logic_vector(data_width-1 downto 0); 
  type mem_t is array((2**addr_width-1) downto 0) of word_t;

  -- ModelSim will initialize RAM using the following function
  impure function init_ram (filename: in string) return mem_t is
    file init_file: text open read_mode is filename; 
    variable init_line: line;
    variable result_mem: mem_t;
  begin
    for i in result_mem'reverse_range loop
      readline(init_file,init_line);
      read(init_line, result_mem(i));
    end loop; 
    return result_mem;
  end init_ram;

  signal data: mem_t := init_ram(modelsim_filename);
  
  -- Quartus initializes RAM/ROMs via ram_init_file synthesis attribute
  -- filename must be in MIF format 
  attribute ram_init_file : string;
  attribute ram_init_file of data : signal is quartus_filename;
        
  signal ra, wa: std_logic_vector(addr_width-1 downto 0); -- read address; write address
begin
  ra <= addr; -- We only need to read or write at any one time so we set both "ra"
  wa <= addr; -- and "wa" to "addr". When using full custom design, rather than an 
              -- FPGA, a single address "port" uses less wire and fewer gates; we 
              -- use two address ports below because the RAM blocks on the Cyclone II
              -- have to address ports.

  -- NOTE the following process does NOT follow the EECE 259 style guidelines!
  -- Do NOT use this "style" for other VHDL you write in EECE 259.  
  -- See "note" above entity declaration for explanation of why we use it here.
  process(clk) begin
    if rising_edge(clk) then
      if write = '1' then
        data(to_integer(unsigned(wa))) <= din;
      end if;
      dout <= data(to_integer(unsigned(ra)));
    end if;
  end process;

end impl;
