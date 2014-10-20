-- Copyright (C) Tor M. Aamodt, UBC
-- synthesis VHDL_INPUT_VERSION VHDL_2008
-- Ensure your CAD synthesis tool/compiler is configured for VHDL-2008.
/*******************************************************************************
Copyright (c) 2012, Stanford University
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. All advertising materials mentioning features or use of this software
   must display the following acknowledgement:
   This product includes software developed at Stanford University.
4. Neither the name of Stanford Univerity nor the
   names of its contributors may be used to endorse or promote products
   derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY STANFORD UNIVERSITY ''AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL STANFORD UNIVERSITY BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*******************************************************************************/

------------------------------------------------------------------------
-- Seven Segment Decoder
------------------------------------------------------------------------
-- Figure 7.20
-- define segment codes
-- seven bit code - one bit per segment, segment is illuminated when
-- bit is low.  Bits 6543210 correspond to: 
--
--         0000
--        5    1
--        5    1
--         6666
--        4    2
--        4    2
--         3333
--
------------------------------------------------------------------------

library ieee;

package sseg_constants is
  use ieee.std_logic_1164.all;
  subtype sseg_type is std_logic_vector(6 downto 0);

  constant SS_0 : sseg_type := 7b"1000000"; 
  constant SS_1 : sseg_type := 7b"1111001"; 
  constant SS_2 : sseg_type := 7b"0100100";
  constant SS_3 : sseg_type := 7b"0110000"; 
  constant SS_4 : sseg_type := 7b"0011001"; 
  constant SS_5 : sseg_type := 7b"0010010"; 
  constant SS_6 : sseg_type := 7b"0000010";
  constant SS_7 : sseg_type := 7b"1111000";
  constant SS_8 : sseg_type := 7b"0000000";
  constant SS_9 : sseg_type := 7b"0010000"; 
  constant SS_A : sseg_type := 7b"0001000"; 
  constant SS_B : sseg_type := 7b"0000011"; 
  constant SS_C : sseg_type := 7b"1000110"; 
  constant SS_D : sseg_type := 7b"0100001"; 
  constant SS_E : sseg_type := 7b"0000110"; 
  constant SS_F : sseg_type := 7b"0001110"; 
  constant SOFF : sseg_type := 7b"1111111"; 

  component sseg is
    port( bin : in std_logic_vector(3 downto 0); 
          segs : out sseg_type );  
  end component;
end package;

------------------------------------------------------------------------
-- Figure 7.21
-- sseg - converts a 4-bit binary number to seven segment code
--
-- bin  - 4-bit binary input
-- segs - 7-bit output, defined above
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.sseg_constants.all;

entity sseg is
  port( bin : in std_logic_vector(3 downto 0); 
        segs : out sseg_type );  
end sseg;
architecture impl of sseg is
begin
  process(all) begin
    case bin is
      when x"0" => segs <= SS_0;
      when x"1" => segs <= SS_1;
      when x"2" => segs <= SS_2;
      when x"3" => segs <= SS_3;
      when x"4" => segs <= SS_4;
      when x"5" => segs <= SS_5;
      when x"6" => segs <= SS_6;
      when x"7" => segs <= SS_7;
      when x"8" => segs <= SS_8;
      when x"9" => segs <= SS_9;
      when x"A" => segs <= SS_A;
      when x"B" => segs <= SS_B;
      when x"C" => segs <= SS_C;
      when x"D" => segs <= SS_D;
      when x"E" => segs <= SS_E;
      when x"F" => segs <= SS_F;
      when others => segs <= SOFF;
    end case;
  end process;
end impl;

------------------------------------------------------------------------
-- Figure 7.22
-- invsseg - converts seven segment code to binary - signals if valid
--
-- segs  - seven segment code in
-- bin   - binary code out
-- valid - true if input is a valid seven segment code
--
--      segs = legal code (0-9) ==> valid = 1, bin = binary
--      segs = zero ==> valid = 0, bin = 0
--      segs = any other code ==> valid = 0, bin = 1
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sseg_constants.all;

entity invsseg is
  port( segs : in sseg_type; 
        bin : out std_logic_vector(3 downto 0); 
        valid : out std_logic );
end invsseg;

architecture impl of invsseg is
begin
  process(all) begin
    case segs is
      when SS_0 =>  valid <= '1'; bin <= x"0";
      when SS_1 =>  valid <= '1'; bin <= x"1";
      when SS_2 =>  valid <= '1'; bin <= x"2";
      when SS_3 =>  valid <= '1'; bin <= x"3";
      when SS_4 =>  valid <= '1'; bin <= x"4";
      when SS_5 =>  valid <= '1'; bin <= x"5";
      when SS_6 =>  valid <= '1'; bin <= x"6";
      when SS_7 =>  valid <= '1'; bin <= x"7";
      when SS_8 =>  valid <= '1'; bin <= x"8";
      when SS_9 =>  valid <= '1'; bin <= x"9";
      when SS_A =>  valid <= '1'; bin <= x"A";
      when SS_B =>  valid <= '1'; bin <= x"B";
      when SS_C =>  valid <= '1'; bin <= x"C";
      when SS_D =>  valid <= '1'; bin <= x"D";
      when SS_E =>  valid <= '1'; bin <= x"E";
      when SS_F =>  valid <= '1'; bin <= x"F";
      when SOFF =>  valid <= '0'; bin <= x"0";
      when others =>valid <= '0'; bin <= x"1";
    end case;
  end process;
end impl; 


------------------------------------------------------------------------
-- Figure 7.23
-- test seven segment decoder - using inverse decoder for a check
--      note that both coders use the same set of defines so an 
--      error in the defines will not be caught.
------------------------------------------------------------------------
-- pragma translate_off
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.sseg_constants.all;

entity test_sseg is
end test_sseg;

architecture test of test_sseg is
  signal bin_in: std_logic_vector(3 downto 0);  -- binary code in
  signal segs: sseg_type;                       -- segment code
  signal bin_out: std_logic_vector(3 downto 0); -- binary code out of inverse coder
  signal valid: std_logic;                      -- valid out of inverse coder
  signal err: std_logic;
begin
  -- instantiate decoder and checker
  SS:  entity work.sseg(impl) port map(bin_in,segs);
  ISS: entity work.invsseg(impl) port map(segs,bin_out,valid);

  process begin
    err <= '0';
    for i in 0 to 15 loop
      bin_in <= conv_std_logic_vector(i,4);
      wait for 10 ns;
      report to_hstring(bin_in) & " " & to_string(segs) & " " & 
             to_hstring(bin_out) & " " & to_string(valid);
      if (bin_in /= bin_out) or (valid /= '1') then 
        report "ERROR"; err <= '1';
      end if;
    end loop;
    if err = '0' then report "TEST PASSED"; 
    else report "TEST FAILED"; end if;
    wait;
  end process;
end test;
-- pragma translate_on
