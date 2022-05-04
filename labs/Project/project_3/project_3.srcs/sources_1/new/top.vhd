library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port ( CLK100MHZ : in STD_LOGIC;
           SW : in STD_LOGIC;
           CA : out STD_LOGIC;
           CB : out STD_LOGIC;
           CC : out STD_LOGIC;
           CD : out STD_LOGIC;
           CE : out STD_LOGIC;
           CF : out STD_LOGIC;
           CG : out STD_LOGIC;
           DP : out STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           BTNC : in STD_LOGIC);
end top;

architecture Behavioral of top is
  -- No internal signals are needed today:)
  
  
begin

  --------------------------------------------------------
  -- Instance (copy) of driver_7seg_4digits entity
  morse_main : entity work.main
      port map(
          clk        => CLK100MHZ,
          reset      => BTNC,
          en_i       => SW,
          -- MAP DECIMAL POINT AND DISPLAY SEGMENTS
          seg_o (6) => CA,
          seg_o (5) => CB,
          seg_o (4) => CC,
          seg_o (3) => CD,
          seg_o (2) => CE,
          seg_o (1) => CF,
          seg_o (0) => CG
      );

  -- Disconnect the top four digits of the 7-segment display
    AN <= b"1111_0111";

end architecture Behavioral;