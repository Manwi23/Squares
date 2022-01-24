	component squares is
		port (
			clk_clk              : in  std_logic                     := 'X';             -- clk
			hex_new_signal       : out std_logic_vector(41 downto 0);                    -- new_signal
			ledr_new_signal      : out std_logic_vector(9 downto 0);                     -- new_signal
			ps2_conduit_end_clk  : in  std_logic                     := 'X';             -- conduit_end_clk
			ps2_conduit_end_data : in  std_logic                     := 'X';             -- conduit_end_data
			reset_reset_n        : in  std_logic                     := 'X';             -- reset_n
			vga_CLK              : out std_logic;                                        -- CLK
			vga_HS               : out std_logic;                                        -- HS
			vga_VS               : out std_logic;                                        -- VS
			vga_BLANK            : out std_logic;                                        -- BLANK
			vga_SYNC             : out std_logic;                                        -- SYNC
			vga_R                : out std_logic_vector(7 downto 0);                     -- R
			vga_G                : out std_logic_vector(7 downto 0);                     -- G
			vga_B                : out std_logic_vector(7 downto 0);                     -- B
			keys_new_signal      : in  std_logic_vector(3 downto 0)  := (others => 'X'); -- new_signal
			switches_new_signal  : in  std_logic_vector(9 downto 0)  := (others => 'X')  -- new_signal
		);
	end component squares;

	u0 : component squares
		port map (
			clk_clk              => CONNECTED_TO_clk_clk,              --      clk.clk
			hex_new_signal       => CONNECTED_TO_hex_new_signal,       --      hex.new_signal
			ledr_new_signal      => CONNECTED_TO_ledr_new_signal,      --     ledr.new_signal
			ps2_conduit_end_clk  => CONNECTED_TO_ps2_conduit_end_clk,  --      ps2.conduit_end_clk
			ps2_conduit_end_data => CONNECTED_TO_ps2_conduit_end_data, --         .conduit_end_data
			reset_reset_n        => CONNECTED_TO_reset_reset_n,        --    reset.reset_n
			vga_CLK              => CONNECTED_TO_vga_CLK,              --      vga.CLK
			vga_HS               => CONNECTED_TO_vga_HS,               --         .HS
			vga_VS               => CONNECTED_TO_vga_VS,               --         .VS
			vga_BLANK            => CONNECTED_TO_vga_BLANK,            --         .BLANK
			vga_SYNC             => CONNECTED_TO_vga_SYNC,             --         .SYNC
			vga_R                => CONNECTED_TO_vga_R,                --         .R
			vga_G                => CONNECTED_TO_vga_G,                --         .G
			vga_B                => CONNECTED_TO_vga_B,                --         .B
			keys_new_signal      => CONNECTED_TO_keys_new_signal,      --     keys.new_signal
			switches_new_signal  => CONNECTED_TO_switches_new_signal   -- switches.new_signal
		);

