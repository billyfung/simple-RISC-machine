library ieee;
use ieee.std_logic_1164.all;
use work.datapath_declarations.all;
use std.env.all; -- for stop(0)

entity datapath_tb is
end datapath_tb;

architecture test of datapath_tb is
  constant word_size : integer := 16;

  signal clk          : std_logic;
  signal reset        : std_logic;
  signal datapath_in  : std_logic_vector(7 downto 0);
  signal write        : std_logic;
  signal readnum      : std_logic_vector(2 downto 0);
  signal writenum     : std_logic_vector(2 downto 0);
  signal vsel         : std_logic;
  signal loada        : std_logic;
  signal loadb        : std_logic;
  signal shift        : std_logic_vector(1 downto 0);
  signal asel         : std_logic;
  signal bsel         : std_logic;
  signal ALUop        : std_logic_vector(1 downto 0);
  signal loadc        : std_logic;
  signal loads        : std_logic;
  signal status       : std_logic;
  signal datapath_out : std_logic_vector(word_size-1 downto 0);

  type reg_type is array(7 downto 0) of std_logic_vector(word_size-1 downto 0);
begin
  DUT: datapath generic map(word_size) port map( clk=>clk,
          reset => reset,
          datapath_in => datapath_in,
          write  => write,
          readnum => readnum,
          vsel   => vsel,
          loada  => loada,
          loadb  => loadb,
          shift  => shift,
          asel   => asel,
          bsel   => bsel,
          ALUop  => ALUop,
          loadc  => loadc,
          loads  => loads,
          writenum => writenum,
          status => status,
          datapath_out => datapath_out );

  -- The following process "script" generates a clock signal with a rising
  -- edge ever 10 ns with the first rising edge at 5 ns (the process repeats
  -- once it gets to "end process" because there is no sensitivity list).
  process begin
    clk <= '0'; wait for 5 ns;
    clk <= '1'; wait for 5 ns;
  end process;

  process begin
    -- Initialize all inputs at time 0ns; start with reset asserted
    reset <= '1';
    datapath_in <= 8d"0";
    write <= '0';
    readnum <= 3d"0";
    writenum <= 3d"0";
    vsel <= '0';
    loada <= '0';
    loadb <= '0';
    shift <= "00";
    asel <= '0';
    bsel <= '0';
    ALUop <= 2b"0";
    loadc <= '0';
    loads <= '0';
    wait for 10 ns;

    -- Set reset to 0
    reset <= '0';
    wait for 10 ns;


    --------------------------------------------------------------------------------
    -- Add your testbench VHDL below this line.

    -- See hint on using VHDL-2008 "external name" syntax, <<signal ...>>,
    -- and the reserved words "force", "release" and "assert" to enable testing.

    -- example test case

    -- Regs[R5] = 7
    vsel <= '1';
    datapath_in <= 8d"7";
    writenum <= 3d"5";
    write <= '1';
    wait for 10 ns;
    --r0 = 7
    writenum <= 3d"0";

    wait for 10 ns;
    -- R1 = 2
    datapath_in <= 8d"2";
    writenum <= 3d"1";

    wait for 10 ns;

    --ADD R2, R1, R0, LSL#1 ; this means R2 = R1 + (R0 shifted left by 1) = 2+14=16
    write <= '0';
    readnum <= 3d"0";
    loada <= '1';

    wait for 10 ns;

    loada <= '0';
    loadb <= '1';
    readnum <= 3d"1";
    shift <= "01"; -- shift left regB by 1 

    wait for 10 ns;

    loadb <= '0';
    loadc <= '1'; -- store into regC
    ALUop <= "00"; -- addition of regA and regB 

    wait for 10 ns;
    loadc<= '0';
    write <= '1';
    vsel <= '0';
    writenum <= 3d"2";
    readnum <= 3d"2";

    wait for 10 ns; 
    --datapath out should read 16 on the 7segment display
  --  report "The HEX display reads " +& to_string(datapath_out);
   -- assert datapath_out = (3d"2" + 3d"7") report "datapath_out wrong" severity failure;
    write <= '0';
 

    -- See "hints" in lab 5 handout for a discussion of how you can check the value 7 
    -- was written into R5 (using "external name" syntax in VHDL-2008)

    -- Keep your testbench code above this line.
    --------------------------------------------------------------------------------

    report "Simulation Done";

    -- stop() is declared inside std.env.all; when called it stops the simulation.
    -- A simple "wait;" will not suffice in testbenches with a separate process for clk.
    stop(0); 
  end process;
end test;
