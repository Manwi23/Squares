set_global_assignment -entity "squares" -library "lib_squares" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "squares" -library "lib_squares" -name IP_TOOL_VERSION "19.1"
set_global_assignment -entity "squares" -library "lib_squares" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_squares" -name SPD_FILE [file join $::quartus(sip_path) "../squares.spd"]
set_global_assignment -library "lib_squares" -name MISC_FILE [file join $::quartus(sip_path) "../../squares.qsys"]

set_global_assignment -library "lib_squares" -name MISC_FILE [file join $::quartus(sip_path) "squares.v"]
set_global_assignment -library "lib_squares" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_reset_controller.v"]
set_global_assignment -library "lib_squares" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_reset_synchronizer.v"]
set_global_assignment -library "lib_squares" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_reset_controller.sdc"]
set_global_assignment -library "lib_squares" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_avalon_video_vga_timing.v"]
set_global_assignment -library "lib_squares" -name MISC_FILE [file join $::quartus(sip_path) "submodules/squares_video_vga_controller_0.v"]
set_global_assignment -library "lib_squares" -name MISC_FILE [file join $::quartus(sip_path) "submodules/squares_video_pll_0.v"]
set_global_assignment -library "lib_squares" -name MISC_FILE [file join $::quartus(sip_path) "submodules/altera_up_avalon_reset_from_locked_signal.v"]
set_global_assignment -library "lib_squares" -name MISC_FILE [file join $::quartus(sip_path) "submodules/squares_video_pll_0_video_pll.vo"]
set_global_assignment -library "lib_squares" -name MISC_FILE [file join $::quartus(sip_path) "submodules/squares_pll_0.vo"]
set_global_assignment -library "lib_squares" -name MISC_FILE [file join $::quartus(sip_path) "submodules/game.v"]
