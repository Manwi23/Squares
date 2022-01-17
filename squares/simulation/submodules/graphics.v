// graphics.v

// This file was auto-generated as a prototype implementation of a module
// created in component editor.  It ties off all outputs to ground and
// ignores all inputs.  It needs to be edited to make it do something
// useful.
// 
// This file will not be automatically regenerated.  You should check it in
// to your version control system if you want to keep it.

`timescale 1 ps / 1 ps
module graphics (
		input  wire        clock_clk,                 //         clock.clk
		input  wire        reset_reset,               //         reset.reset
		output wire        avalon_master_write,       // avalon_master.write
		output wire        avalon_master_read,        //              .read
		input  wire        avalon_master_waitrequest, //              .waitrequest
		output wire [31:0] avalon_master_writedata,   //              .writedata
		input  wire [31:0] avalon_master_readdata,    //              .readdata
		output wire [31:0] avalon_master_address,     //              .address
		output wire        swap,                      //   conduit_end.swap
		output wire [23:0] address,                   //              .address
		output wire [23:0] color                      //              .color
	);

	// TODO: Auto-generated HDL template

	assign avalon_master_read = 1'b0;

	assign avalon_master_address = 32'b00000000000000000000000000000000;

	assign avalon_master_write = 1'b0;

	assign avalon_master_writedata = 32'b00000000000000000000000000000000;

	assign address = 24'b000000000000000000000000;

	assign color = 24'b000000000000000000000000;

	assign swap = 1'b0;

endmodule
