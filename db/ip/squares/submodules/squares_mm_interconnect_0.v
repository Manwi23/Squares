// squares_mm_interconnect_0.v

// This file was auto-generated from altera_mm_interconnect_hw.tcl.  If you edit it your changes
// will probably be lost.
// 
// Generated using ACDS version 19.1 670

`timescale 1 ps / 1 ps
module squares_mm_interconnect_0 (
		input  wire        clk_0_clk_clk,                                   //                                 clk_0_clk.clk
		input  wire        coordinator_0_reset_reset_bridge_in_reset_reset, // coordinator_0_reset_reset_bridge_in_reset.reset
		input  wire [9:0]  coordinator_0_avalon_master_address,             //               coordinator_0_avalon_master.address
		output wire        coordinator_0_avalon_master_waitrequest,         //                                          .waitrequest
		input  wire        coordinator_0_avalon_master_read,                //                                          .read
		output wire [15:0] coordinator_0_avalon_master_readdata,            //                                          .readdata
		input  wire        coordinator_0_avalon_master_write,               //                                          .write
		input  wire [15:0] coordinator_0_avalon_master_writedata,           //                                          .writedata
		output wire [8:0]  onchip_memory2_0_s1_address,                     //                       onchip_memory2_0_s1.address
		output wire        onchip_memory2_0_s1_write,                       //                                          .write
		input  wire [15:0] onchip_memory2_0_s1_readdata,                    //                                          .readdata
		output wire [15:0] onchip_memory2_0_s1_writedata,                   //                                          .writedata
		output wire [1:0]  onchip_memory2_0_s1_byteenable,                  //                                          .byteenable
		output wire        onchip_memory2_0_s1_chipselect,                  //                                          .chipselect
		output wire        onchip_memory2_0_s1_clken                        //                                          .clken
	);

	wire         coordinator_0_avalon_master_translator_avalon_universal_master_0_waitrequest;   // onchip_memory2_0_s1_translator:uav_waitrequest -> coordinator_0_avalon_master_translator:uav_waitrequest
	wire  [15:0] coordinator_0_avalon_master_translator_avalon_universal_master_0_readdata;      // onchip_memory2_0_s1_translator:uav_readdata -> coordinator_0_avalon_master_translator:uav_readdata
	wire         coordinator_0_avalon_master_translator_avalon_universal_master_0_debugaccess;   // coordinator_0_avalon_master_translator:uav_debugaccess -> onchip_memory2_0_s1_translator:uav_debugaccess
	wire   [9:0] coordinator_0_avalon_master_translator_avalon_universal_master_0_address;       // coordinator_0_avalon_master_translator:uav_address -> onchip_memory2_0_s1_translator:uav_address
	wire         coordinator_0_avalon_master_translator_avalon_universal_master_0_read;          // coordinator_0_avalon_master_translator:uav_read -> onchip_memory2_0_s1_translator:uav_read
	wire   [1:0] coordinator_0_avalon_master_translator_avalon_universal_master_0_byteenable;    // coordinator_0_avalon_master_translator:uav_byteenable -> onchip_memory2_0_s1_translator:uav_byteenable
	wire         coordinator_0_avalon_master_translator_avalon_universal_master_0_readdatavalid; // onchip_memory2_0_s1_translator:uav_readdatavalid -> coordinator_0_avalon_master_translator:uav_readdatavalid
	wire         coordinator_0_avalon_master_translator_avalon_universal_master_0_lock;          // coordinator_0_avalon_master_translator:uav_lock -> onchip_memory2_0_s1_translator:uav_lock
	wire         coordinator_0_avalon_master_translator_avalon_universal_master_0_write;         // coordinator_0_avalon_master_translator:uav_write -> onchip_memory2_0_s1_translator:uav_write
	wire  [15:0] coordinator_0_avalon_master_translator_avalon_universal_master_0_writedata;     // coordinator_0_avalon_master_translator:uav_writedata -> onchip_memory2_0_s1_translator:uav_writedata
	wire   [1:0] coordinator_0_avalon_master_translator_avalon_universal_master_0_burstcount;    // coordinator_0_avalon_master_translator:uav_burstcount -> onchip_memory2_0_s1_translator:uav_burstcount

	altera_merlin_master_translator #(
		.AV_ADDRESS_W                (10),
		.AV_DATA_W                   (16),
		.AV_BURSTCOUNT_W             (1),
		.AV_BYTEENABLE_W             (2),
		.UAV_ADDRESS_W               (10),
		.UAV_BURSTCOUNT_W            (2),
		.USE_READ                    (1),
		.USE_WRITE                   (1),
		.USE_BEGINBURSTTRANSFER      (0),
		.USE_BEGINTRANSFER           (0),
		.USE_CHIPSELECT              (0),
		.USE_BURSTCOUNT              (0),
		.USE_READDATAVALID           (0),
		.USE_WAITREQUEST             (1),
		.USE_READRESPONSE            (0),
		.USE_WRITERESPONSE           (0),
		.AV_SYMBOLS_PER_WORD         (2),
		.AV_ADDRESS_SYMBOLS          (1),
		.AV_BURSTCOUNT_SYMBOLS       (0),
		.AV_CONSTANT_BURST_BEHAVIOR  (0),
		.UAV_CONSTANT_BURST_BEHAVIOR (0),
		.AV_LINEWRAPBURSTS           (0),
		.AV_REGISTERINCOMINGSIGNALS  (0)
	) coordinator_0_avalon_master_translator (
		.clk                    (clk_0_clk_clk),                                                                  //                       clk.clk
		.reset                  (coordinator_0_reset_reset_bridge_in_reset_reset),                                //                     reset.reset
		.uav_address            (coordinator_0_avalon_master_translator_avalon_universal_master_0_address),       // avalon_universal_master_0.address
		.uav_burstcount         (coordinator_0_avalon_master_translator_avalon_universal_master_0_burstcount),    //                          .burstcount
		.uav_read               (coordinator_0_avalon_master_translator_avalon_universal_master_0_read),          //                          .read
		.uav_write              (coordinator_0_avalon_master_translator_avalon_universal_master_0_write),         //                          .write
		.uav_waitrequest        (coordinator_0_avalon_master_translator_avalon_universal_master_0_waitrequest),   //                          .waitrequest
		.uav_readdatavalid      (coordinator_0_avalon_master_translator_avalon_universal_master_0_readdatavalid), //                          .readdatavalid
		.uav_byteenable         (coordinator_0_avalon_master_translator_avalon_universal_master_0_byteenable),    //                          .byteenable
		.uav_readdata           (coordinator_0_avalon_master_translator_avalon_universal_master_0_readdata),      //                          .readdata
		.uav_writedata          (coordinator_0_avalon_master_translator_avalon_universal_master_0_writedata),     //                          .writedata
		.uav_lock               (coordinator_0_avalon_master_translator_avalon_universal_master_0_lock),          //                          .lock
		.uav_debugaccess        (coordinator_0_avalon_master_translator_avalon_universal_master_0_debugaccess),   //                          .debugaccess
		.av_address             (coordinator_0_avalon_master_address),                                            //      avalon_anti_master_0.address
		.av_waitrequest         (coordinator_0_avalon_master_waitrequest),                                        //                          .waitrequest
		.av_read                (coordinator_0_avalon_master_read),                                               //                          .read
		.av_readdata            (coordinator_0_avalon_master_readdata),                                           //                          .readdata
		.av_write               (coordinator_0_avalon_master_write),                                              //                          .write
		.av_writedata           (coordinator_0_avalon_master_writedata),                                          //                          .writedata
		.av_burstcount          (1'b1),                                                                           //               (terminated)
		.av_byteenable          (2'b11),                                                                          //               (terminated)
		.av_beginbursttransfer  (1'b0),                                                                           //               (terminated)
		.av_begintransfer       (1'b0),                                                                           //               (terminated)
		.av_chipselect          (1'b0),                                                                           //               (terminated)
		.av_readdatavalid       (),                                                                               //               (terminated)
		.av_lock                (1'b0),                                                                           //               (terminated)
		.av_debugaccess         (1'b0),                                                                           //               (terminated)
		.uav_clken              (),                                                                               //               (terminated)
		.av_clken               (1'b1),                                                                           //               (terminated)
		.uav_response           (2'b00),                                                                          //               (terminated)
		.av_response            (),                                                                               //               (terminated)
		.uav_writeresponsevalid (1'b0),                                                                           //               (terminated)
		.av_writeresponsevalid  ()                                                                                //               (terminated)
	);

	altera_merlin_slave_translator #(
		.AV_ADDRESS_W                   (9),
		.AV_DATA_W                      (16),
		.UAV_DATA_W                     (16),
		.AV_BURSTCOUNT_W                (1),
		.AV_BYTEENABLE_W                (2),
		.UAV_BYTEENABLE_W               (2),
		.UAV_ADDRESS_W                  (10),
		.UAV_BURSTCOUNT_W               (2),
		.AV_READLATENCY                 (1),
		.USE_READDATAVALID              (0),
		.USE_WAITREQUEST                (0),
		.USE_UAV_CLKEN                  (0),
		.USE_READRESPONSE               (0),
		.USE_WRITERESPONSE              (0),
		.AV_SYMBOLS_PER_WORD            (2),
		.AV_ADDRESS_SYMBOLS             (0),
		.AV_BURSTCOUNT_SYMBOLS          (0),
		.AV_CONSTANT_BURST_BEHAVIOR     (0),
		.UAV_CONSTANT_BURST_BEHAVIOR    (0),
		.AV_REQUIRE_UNALIGNED_ADDRESSES (0),
		.CHIPSELECT_THROUGH_READLATENCY (0),
		.AV_READ_WAIT_CYCLES            (0),
		.AV_WRITE_WAIT_CYCLES           (0),
		.AV_SETUP_WAIT_CYCLES           (0),
		.AV_DATA_HOLD_CYCLES            (0)
	) onchip_memory2_0_s1_translator (
		.clk                    (clk_0_clk_clk),                                                                  //                      clk.clk
		.reset                  (coordinator_0_reset_reset_bridge_in_reset_reset),                                //                    reset.reset
		.uav_address            (coordinator_0_avalon_master_translator_avalon_universal_master_0_address),       // avalon_universal_slave_0.address
		.uav_burstcount         (coordinator_0_avalon_master_translator_avalon_universal_master_0_burstcount),    //                         .burstcount
		.uav_read               (coordinator_0_avalon_master_translator_avalon_universal_master_0_read),          //                         .read
		.uav_write              (coordinator_0_avalon_master_translator_avalon_universal_master_0_write),         //                         .write
		.uav_waitrequest        (coordinator_0_avalon_master_translator_avalon_universal_master_0_waitrequest),   //                         .waitrequest
		.uav_readdatavalid      (coordinator_0_avalon_master_translator_avalon_universal_master_0_readdatavalid), //                         .readdatavalid
		.uav_byteenable         (coordinator_0_avalon_master_translator_avalon_universal_master_0_byteenable),    //                         .byteenable
		.uav_readdata           (coordinator_0_avalon_master_translator_avalon_universal_master_0_readdata),      //                         .readdata
		.uav_writedata          (coordinator_0_avalon_master_translator_avalon_universal_master_0_writedata),     //                         .writedata
		.uav_lock               (coordinator_0_avalon_master_translator_avalon_universal_master_0_lock),          //                         .lock
		.uav_debugaccess        (coordinator_0_avalon_master_translator_avalon_universal_master_0_debugaccess),   //                         .debugaccess
		.av_address             (onchip_memory2_0_s1_address),                                                    //      avalon_anti_slave_0.address
		.av_write               (onchip_memory2_0_s1_write),                                                      //                         .write
		.av_readdata            (onchip_memory2_0_s1_readdata),                                                   //                         .readdata
		.av_writedata           (onchip_memory2_0_s1_writedata),                                                  //                         .writedata
		.av_byteenable          (onchip_memory2_0_s1_byteenable),                                                 //                         .byteenable
		.av_chipselect          (onchip_memory2_0_s1_chipselect),                                                 //                         .chipselect
		.av_clken               (onchip_memory2_0_s1_clken),                                                      //                         .clken
		.av_read                (),                                                                               //              (terminated)
		.av_begintransfer       (),                                                                               //              (terminated)
		.av_beginbursttransfer  (),                                                                               //              (terminated)
		.av_burstcount          (),                                                                               //              (terminated)
		.av_readdatavalid       (1'b0),                                                                           //              (terminated)
		.av_waitrequest         (1'b0),                                                                           //              (terminated)
		.av_writebyteenable     (),                                                                               //              (terminated)
		.av_lock                (),                                                                               //              (terminated)
		.uav_clken              (1'b0),                                                                           //              (terminated)
		.av_debugaccess         (),                                                                               //              (terminated)
		.av_outputenable        (),                                                                               //              (terminated)
		.uav_response           (),                                                                               //              (terminated)
		.av_response            (2'b00),                                                                          //              (terminated)
		.uav_writeresponsevalid (),                                                                               //              (terminated)
		.av_writeresponsevalid  (1'b0)                                                                            //              (terminated)
	);

endmodule