-- Copyright (C) Tor M. Aamodt, UBC
-- synthesis VHDL_INPUT_VERSION VHDL_2008
-- Ensure your CAD synthesis tool/compiler is configured for VHDL-2008.

library ieee;
use ieee.std_logic_1164.all;

package ff is
  component vDFF is -- (vector) n-bit D Flip-Flop (use sDFF for std_logic)
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
end package;

-------------------------------------------------------------------------------
-- Flip-flop

library ieee;
use ieee.std_logic_1164.all;

entity vDFF is -- n-bit register (use sDFF for std_logic)
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
