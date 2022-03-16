------------------------------------------------------------
--
-- Testbench for 2-bit binary comparator.
-- EDA Playground
--
-- Copyright (c) 2020-Present Tomas Fryza
-- Dept. of Radio Electronics, Brno Univ. of Technology, Czechia
-- This work is licensed under the terms of the MIT license.
--
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------
-- Entity declaration for testbench
------------------------------------------------------------
entity tb_mux_3bit_4to1 is
    -- Entity of testbench is always empty
end entity tb_mux_3bit_4to1;

------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------
architecture testbench of tb_mux_3bit_4to1 is

    -- Local signals
    signal s_a           : std_logic_vector(2 - 1 downto 0);
    signal s_b           : std_logic_vector(2 - 1 downto 0);
    signal s_c           : std_logic_vector(2 - 1 downto 0);
    signal s_d           : std_logic_vector(2 - 1 downto 0);
    signal s_sel         : std_logic_vector(1 - 1 downto 0);
    signal s_f           : std_logic_vector(2 - 1 downto 0);
begin
    -- Connecting testbench signals with comparator_2bit
    -- entity (Unit Under Test)
    uut_comparator_4bit : entity work.mux_3bit_4to1
        port map(
            a_i           => s_a,
            b_i           => s_b,
            c_i           => s_c,
            d_i           => s_d,
            sel_i         => s_sel,
            f_o           => s_f
         );

    --------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------
    p_stimulus : process
    begin
        -- Report a note at the beginning of stimulus process

        -- First test case
        s_a <= "100"; 		  -- Such as "0101" if ID = xxxx56
        s_b <= "101";        -- Such as "0110" if ID = xxxx56
        s_c <= "110";
        s_d <= "111";
         
        s_f <= s_a when (s_sel = "00" ) else
               s_b when (s_sel = "01" ) else
               s_c when (s_sel = "10" ) else
               s_d when (s_sel = "11" );     
    
    end process p_stimulus;

end architecture testbench;

