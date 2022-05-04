------------------------------------------------------------
--
-- N-bit Up/Down binary counter.
-- Nexys A7-50T, Vivado v2020.1.1, EDA Playground
--
-- Copyright (c) 2019-Present Tomas Fryza
-- Dept. of Radio Electronics, Brno Univ. of Technology, Czechia
-- This work is licensed under the terms of the MIT license.
--
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned;

------------------------------------------------------------
-- Entity declaration for n-bit counter
------------------------------------------------------------
entity main is
    generic(
        g_CNT_WIDTH : natural := 4 -- Number of bits for counter
    );
    port(
        clk      : in  std_logic;  -- Main clock
        reset    : in  std_logic;  -- Synchronous reset
        en_i     : in  std_logic;  -- Enable input
        seg_o : out STD_LOGIC_VECTOR (6 downto 0);
        loopup_o: out natural;
        loopdown_o: out natural;
        hold_buff_o: out STD_LOGIC_VECTOR (9 downto 0);
        ce_o:out std_logic;
        enable_slow:out std_logic
    );
end entity main;

------------------------------------------------------------
-- Architecture body for n-bit counter
------------------------------------------------------------
architecture behavioral of main is

    -- Local counter
 
    signal s_cnt_loc_loopUP: natural;
    signal s_cnt_loc_loopDOWN: natural;
    signal s_cnt_num: integer;
    signal s_buffer : std_logic_vector(9 downto 0);
    signal s_hold_out: std_logic;
    signal s_buffer_o: std_logic_vector(9 downto 0);
    signal s_enable  : std_logic;

begin
    clk_en0 : entity work.clock_enable
        generic map(
            -- FOR SIMULATION, CHANGE THIS VALUE TO 4
            -- FOR IMPLEMENTATION, KEEP THIS VALUE TO 400,000
            g_MAX => 100
        )
        port map(
            clk   => clk,
            reset => reset,
            ce_o  => s_enable
            
        ); 
    
    p_cnt_up_down : process(clk)
    begin
    enable_slow <= s_enable;
        if rising_edge(clk) then
        
           if (s_enable = '1')then
           
            if (reset = '1') then               -- Synchronous reset
                s_cnt_loc_loopUP <= 0;
                s_cnt_loc_loopDOWN <= 0;
                s_buffer_o <= "0000000000";
                s_buffer<="0000000000";
                end if;
                
                if (en_i = '1') then             -- Test if counter is enabled
                   s_cnt_loc_loopDOWN  <= 0;
                   s_cnt_loc_loopUP <= s_cnt_loc_loopUP + 1;
                   loopup_o <= s_cnt_loc_loopUP;                         
 
                   
                     if (s_cnt_loc_loopUP > 6) then        --dash
                        s_cnt_num <= 11;
                        s_hold_out <= '1';  
                     elsif (s_cnt_loc_loopUP > 2) then       --dot
                        s_cnt_num <= 01;
                        s_hold_out <= '1'; 
                     end if;

                elsif (en_i = '0') then
                  s_cnt_loc_loopDOWN <= s_cnt_loc_loopDOWN + 1;  
                  s_cnt_loc_loopUP <= 0;
                  loopdown_o <= s_cnt_loc_loopDOWN;
                        if (s_hold_out = '1') then
                           s_buffer <= std_logic_vector(shift_left(unsigned(s_buffer), 2));
                         
                             if (s_cnt_num = 11) then 
                                s_buffer(0)<= '1';
                                s_buffer(1)<='1';
                            
                             else
                               s_buffer(0)<= '1';
                               s_buffer(1)<='0';
                             end if;
                         
                             s_hold_out <= '0';
                             end if;  
                                        
                        if (s_cnt_loc_loopDOWN > 6) then        --big space     
                            s_buffer_o<=s_buffer;
                            if(s_cnt_loc_loopDOWN > 20) then  
                                s_buffer <= "0000000000";
                                s_cnt_loc_loopDOWN <= 0;
                           end if;
                        end if;
                    end if;    
            end if;
        end if;
    end process p_cnt_up_down;
    
    p_7seg_decoder : process(s_buffer_o)
    begin
        case s_buffer_o is
            when "0000000111" =>
                seg_o <= "0001000"; -- a
            when "0011010101" =>
                seg_o <= "1100000"; -- b 
            when "0011011101" =>    --c
                seg_o <= "0110001";
            when "0000110101" =>
                seg_o <= "1000010"; --d
            when "0000000001" =>
                seg_o <= "0110000"; --e
            when "0001011101" =>
                seg_o <= "0111000"; --f
            when "0000111101" =>
                seg_o <= "0000100"; --g
            when "0001010101" =>
                seg_o <= "1001000"; --h
            when "0000000101" =>
                seg_o <= "1111011"; --i
            when "0001111111" =>
                seg_o <= "1000000"; --j
            when "0000110111" =>
                seg_o <= "1111000"; --k
            when "0001110101" =>
                seg_o <= "1110001"; --l
            when "0000001111" =>
                seg_o <= "0011101"; --m
            when "0000001101" =>
                seg_o <= "0010101"; --n
            when "0000111111" =>
                seg_o <= "1100010"; --o
            when "0001111101" =>
                seg_o <= "0011000"; --p
            when "0011110111" =>
                seg_o <= "0001100"; --q
            when "0000011101" =>
                seg_o <= "1111010"; --r
            when "0000010101" =>
                seg_o <= "0100100"; --s
            when "0000000011" =>
                seg_o <= "0111001"; --t
            when "0000010111" =>
                seg_o <= "1000001"; --u
            when "0001010111" =>
                seg_o <= "0011100"; --v
            when "0000011111" =>
                seg_o <= "1001001"; --w
            when "0011010111" =>
                seg_o <= "1100011"; --x
            when "0011011111" =>
                seg_o <= "1000100"; --y
            when "0011110101" =>
                seg_o <= "1011010"; --z
          ---------numbers-------------
            when "1111111111" =>
                seg_o <= "0000001"; --0
            when "0111111111" =>
                seg_o <= "1001111"; --1
            when "0101111111" =>
                seg_o <= "0010010"; --2
            when "0101011111" =>
                seg_o <= "0000110"; --3
            when "0101010111" =>
                seg_o <= "1001100"; --4
            when "0101010101" =>
                seg_o <= "0100100"; --5
            when "1101010101" =>
                seg_o <= "0100000"; --6
            when "1111010101" =>
                seg_o <= "0001111"; --7
            when "1111110101" =>
                seg_o <= "0000000"; --8
            when "1111111101" =>
                seg_o <= "0000100"; --9
             
            when others =>
                seg_o <= "0110110"; -- unknown
        end case;
    end process p_7seg_decoder;
end architecture behavioral;