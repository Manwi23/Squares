	component squares is
		port (
			clk_clk             : in  std_logic                     := 'X'; -- clk
			lights_leds         : out std_logic_vector(9 downto 0);         -- leds
			lights_hex          : out std_logic_vector(41 downto 0);        -- hex
			pll_0_locked_export : out std_logic;                            -- export
			ps2_ps2_clk         : in  std_logic                     := 'X'; -- ps2_clk
			ps2_ps2_data        : in  std_logic                     := 'X'; -- ps2_data
			reset_reset_n       : in  std_logic                     := 'X'; -- reset_n
			vga_CLK             : out std_logic;                            -- CLK
			vga_HS              : out std_logic;                            -- HS
			vga_VS              : out std_logic;                            -- VS
			vga_BLANK           : out std_logic;                            -- BLANK
			vga_SYNC            : out std_logic;                            -- SYNC
			vga_R               : out std_logic_vector(7 downto 0);         -- R
			vga_G               : out std_logic_vector(7 downto 0);         -- G
			vga_B               : out std_logic_vector(7 downto 0)          -- B
		);
	end component squares;

	u0 : component squares
		port map (
			clk_clk             => CONNECTED_TO_clk_clk,             --          clk.clk
			lights_leds         => CONNECTED_TO_lights_leds,         --       lights.leds
			lights_hex          => CONNECTED_TO_lights_hex,          --             .hex
			pll_0_locked_export => CONNECTED_TO_pll_0_locked_export, -- pll_0_locked.export
			ps2_ps2_clk         => CONNECTED_TO_ps2_ps2_clk,         --          ps2.ps2_clk
			ps2_ps2_data        => CONNECTED_TO_ps2_ps2_data,        --             .ps2_data
			reset_reset_n       => CONNECTED_TO_reset_reset_n,       --        reset.reset_n
			vga_CLK             => CONNECTED_TO_vga_CLK,             --          vga.CLK
			vga_HS              => CONNECTED_TO_vga_HS,              --             .HS
			vga_VS              => CONNECTED_TO_vga_VS,              --             .VS
			vga_BLANK           => CONNECTED_TO_vga_BLANK,           --             .BLANK
			vga_SYNC            => CONNECTED_TO_vga_SYNC,            --             .SYNC
			vga_R               => CONNECTED_TO_vga_R,               --             .R
			vga_G               => CONNECTED_TO_vga_G,               --             .G
			vga_B               => CONNECTED_TO_vga_B                --             .B
		);

