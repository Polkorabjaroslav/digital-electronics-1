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

------------------------------------------------------------
-- Entity declaration for n-bit counter
------------------------------------------------------------
entity cnt_up_down is
    generic(
        g_CNT_WIDTH : natural := 4 -- Number of bits for counter
    );
    port(
        clk      : in  std_logic;  -- Main clock
        reset    : in  std_logic;  -- Synchronous reset
        en_i     : in  std_logic;  -- Enable input
        cnt_up_i : in  std_logic;  -- Direction of the counter
 --       cnt_o    : out std_logic_vector(g_CNT_WIDTH - 4 downto 0)
 cnt_o    : out std_logic_vector(4 downto 0)
    );
end entity cnt_up_down;

------------------------------------------------------------
-- Architecture body for n-bit counter
------------------------------------------------------------
architecture behavioral of cnt_up_down is

    -- Local counter
    signal s_cnt_local : unsigned(g_CNT_WIDTH - 1 downto 0);
    signal s_cnt_loc_loopUP: natural;
    signal s_cnt_loc_loopDOWN: natural;
    signal s_cnt_num: std_logic;
    signal s_buffer : std_logic_vector(4 downto 0);
    signal s_hold_buffer: std_logic;
    signal s_hold_out: std_logic;

begin

    p_cnt_up_down : process(clk)
    begin
        if rising_edge(clk) then
        
            if (reset = '1') then               -- Synchronous reset
                s_cnt_local <= (others => '0'); -- Clear 
                s_cnt_loc_loopUP <= 0;
                s_buffer <= "00000";

            elsif (en_i = '1') then             -- Test if counter is enabled
                
                   if (cnt_up_i = '1') then
                   s_cnt_loc_loopDOWN  <= 0;     
                   s_cnt_loc_loopUP <= s_cnt_loc_loopUP + 1;         
                   
                       if (s_cnt_loc_loopUP > 6) then        --dash
                            s_cnt_num <= '1';
                            s_hold_buffer <= '1';
                            s_hold_out <= '1'; 
                       elsif (s_cnt_loc_loopUP > 3) then       --dot
                            s_cnt_num <= '0';
                            s_hold_buffer <= '1';
                            s_hold_out <= '1'; 
    
                   elsif (cnt_up_i = '0') then
                        s_cnt_loc_loopDOWN <= s_cnt_loc_loopDOWN + 1;  
                        s_cnt_loc_loopUP <= 0;
                        

                            
                        if (s_cnt_loc_loopDOWN > 6) then        --big space
                                                                        
                            if (s_hold_out = '1') then
                                cnt_o <= s_buffer; 
                                s_hold_out <= '0';           
                             end if;
                             
                            s_hold_buffer <= '0'; 
                            s_buffer <= "00000";
                            s_cnt_loc_loopDOWN <= 0;
                            
                            
                        elsif (s_cnt_loc_loopDOWN > 3) then     --small space
                             if (s_hold_buffer = '1') then
                                s_buffer <= s_buffer & s_cnt_num;
                                s_hold_buffer <= '0';              
                             end if;
                        end if;
                    end if;    
            end if;
        end if;
       end if;
    end process p_cnt_up_down;
   -- cnt_o <= std_logic_vector(s_cnt_local);

end architecture behavioral;