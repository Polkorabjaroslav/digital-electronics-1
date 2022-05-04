----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.04.2022 12:51:42
-- Design Name: 
-- Module Name: Morse_base - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Morse_base is
    Port ( sw_1 : in STD_LOGIC_VECTOR (0 to 1);
           sw_2 : in STD_LOGIC_VECTOR (0 to 1);
           reset : in STD_LOGIC_VECTOR (0 to 1);
           space : in STD_LOGIC_VECTOR (0 to 1);
           word_out : out STD_LOGIC_VECTOR (0 to 8));
end Morse_base;

architecture Behavioral of Morse_base is

begin


end Behavioral;
