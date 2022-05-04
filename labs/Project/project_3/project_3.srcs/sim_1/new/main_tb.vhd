library ieee;
use ieee.std_logic_1164.all;

------------------------------------------------------------
-- Entity declaration for testbench
------------------------------------------------------------
entity main_tb is
    -- Entity of testbench is always empty
end entity main_tb; 

------------------------------------------------------------
-- Architecture body for testbench
------------------------------------------------------------
architecture testbench of main_tb is

    -- Number of bits for testbench counter
    constant c_CNT_WIDTH         : natural := 5;
    constant c_CLK_100MHZ_PERIOD : time    := 10 ns;

    --Local signals
    signal s_clk_100MHz : std_logic;
    signal s_enable_slow:std_logic;
    signal s_reset      : std_logic;
    signal s_en         : std_logic;
    signal s_seg_o    : std_logic_vector(6 downto 0);
    signal s_loopup_o : natural;
    signal s_loopdown_o: natural;
    
begin
    -- Connecting testbench signals with cnt_up_down entity
    -- (Unit Under Test)
    uut_cnt_o : entity work.main
        generic map(
            g_CNT_WIDTH  => c_CNT_WIDTH
        )
        port map(
            clk      => s_clk_100MHz,
            enable_slow => s_enable_slow,
            reset    => s_reset,
            en_i     => s_en,
            seg_o   => s_seg_o,
            loopup_o => s_loopup_o,
            loopdown_o => s_loopdown_o
            
        );

            
    --------------------------------------------------------
    -- Clock generation process
    --------------------------------------------------------
    p_clk_gen : process
    begin
        while now < 10000000 ns loop -- 75 periods of 100MHz clock
            s_clk_100MHz <= '0';
            wait for c_CLK_100MHZ_PERIOD / 2;
            s_clk_100MHz <= '1';
            wait for c_CLK_100MHZ_PERIOD / 2;
        end loop;
        wait;
    end process p_clk_gen;

    --------------------------------------------------------
    -- Reset generation process
    --------------------------------------------------------
    p_reset_gen : process
    begin
        s_reset <= '0'; wait for 75000 ns;
        s_reset <= '1'; wait for 3000 ns;
        s_reset <= '0';
        -- Reset activated
       
        wait;
    end process p_reset_gen;

    --------------------------------------------------------
    -- Data generation process
    --------------------------------------------------------
    p_stimulus : process
    begin
        report "Stimulus process started" severity note;

        -- Enable counting
        s_en     <= '0';
        wait for 25000 ns;
        s_en     <= '1';
        wait for 9000 ns;
        s_en     <= '0';
        wait for 3000 ns;
        s_en     <= '1';
        wait for 4000 ns;
        s_en     <= '0';
        wait for 3000 ns;
        s_en     <= '1';
        wait for 4000 ns;
        s_en     <= '0';
        wait for 3000 ns;
        s_en     <= '1';
        wait for 9000 ns;
        s_en     <= '0';
        wait for 20000ns;
        
        s_en     <= '1';
        wait for 4000 ns;
        s_en     <= '0';
        wait for 3000 ns;
        s_en     <= '1';
        wait for 4000 ns;
        s_en     <= '0';
        wait for 3000 ns;
        s_en     <= '1';
        wait for 4000 ns;
        s_en     <= '0';
        wait for 3000 ns;
        s_en     <= '1';
        wait for 9000 ns;
        s_en     <= '0';
        wait for 60000 ns;
        
        s_en     <= '1';
        wait for 4000 ns;
        s_en     <= '0';
        wait for 3000 ns;
        s_en     <= '1';
        wait for 4000 ns;
        s_en     <= '0';
        wait for 3000 ns;
        s_en     <= '1';
        wait for 4000 ns;
        s_en     <= '0';
        wait for 3000 ns;
        s_en     <= '1';
        wait for 4000 ns;
        s_en     <= '0';
        wait for 3000 ns;
        s_en     <= '1';
        wait for 4000 ns;
        s_en     <= '0';
   
        
      
        -- Disable counting
 

        report "Stimulus process finished" severity note;
        wait;
    end process p_stimulus;


end architecture testbench;