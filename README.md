# Squares
#### Playing Sokoban with FPGA

--------------

This repository contains a DE1-SoC project created for my university's FPGA class.

It's a Verilog implementation of the game of [Sokoban](https://en.wikipedia.org/wiki/Sokoban) - along with PS2 keyboard driver implementation, and, probably more important, VGA video streamer.

It was developed using Quartus Lite 19.1 with Platform Designer (Qsys).

The main project structure is described in Qsys' squares.qsys file. There, apart from clocks, PLLs and VGA streamer instance, is the main Game module. It's implementation can be found in [game.v](https://github.com/Manwi23/Squares/blob/main/game.v). It itself consists of various modules, forming a pipeline.
* As the game logic is driven by pressing keys, the first module is responsible for talking to the keyboard over PS2.
* Then, the [game_logic.v](https://github.com/Manwi23/Squares/blob/main/game_logic.v) and [operational_memory.v](https://github.com/Manwi23/Squares/blob/main/operational_memory.v) modules are the ones responsible for executing the game's logic and holding the board's state, respectively. This memory is initialized with [op_memory.mif](https://github.com/Manwi23/Squares/blob/main/op_memory.mif) file, which holds the board's initial state. Python's [generate_op_memory.py](https://github.com/Manwi23/Squares/blob/main/generate_op_memory.py) script is used to conveniently prepare the memory's contents.
* Entities drawer ([entities_drawer.v](https://github.com/Manwi23/Squares/blob/main/entities_drawer.v)) when a new game state is in the memory, converts it to a list of entities (along with their position), stored in another memory piece - first the immovable ones, like walls or floors (aka dirt), then the movable ones - or, to be precise, the ones currently in motion. This is done so that the entities can be further drawn on the screen in the same order they appear in memory - without being covered up later.

Next modules in the pipeline are created in a way which prevents them from introducing further delays - namely, both the mentioned memory with entities and the row storing memory (below) are a "double memory" ([double_memory.v](https://github.com/Manwi23/Squares/blob/main/double_memory.v)) - a (currently) main part and a buffer. They consist of two RAM memory modules, one of which is being read from at the moment by the next module in the pipeline, and the other one - filled be the preceding one. When a signal of reading being finished comes from the following module, the RAMs are swapped and a new read can start without a further delay.

* Row drawer ([row_drawer.v](https://github.com/Manwi23/Squares/blob/main/row_drawer.v)) prepares rows of pixels to be sent to the VGA module. My first idea here was to have a double memory holding a whole screen description and a buffer of the next one, but it turned out 640x480x24 bits is a little too much to fit in FPGA's memory, so I turned to having a double memory for rows. So the row drawer reads the list of entities, for each one calculates if it should be anywhere in the currently drawn row, and if yes, copies out the corresponding row of the entity's picture from ROM memory.
* ROM memory storing the pictures for entities is initialized with [memory.mif](https://github.com/Manwi23/Squares/blob/main/memory.mif) file. It's created with Python script [generate_rom_memory.py](https://github.com/Manwi23/Squares/blob/main/generate_rom_memory.py). As the board consists of squares of the same size, all pics are also like that - 48x48, times 24 bits for RGB color.
* VGA module ([vga_streamer.v](https://github.com/Manwi23/Squares/blob/main/vga_streamer.v)) is an implementation of Avalon Streaming Source. The corresponding Streaming Sink is delivered via Qsys VGA Streamer module. The Source module is responsible for reading rows from the double memory module and sending them to the Sink, while also informing the preceding modules of the need to swap rows or prepare new game state and swap entities memory.

------------
#### Citation
The [keyboard_press_driver.v](https://github.com/Manwi23/Squares/blob/main/keyboard_press_driver.v) and [keyboard_inner_driver.v](https://github.com/Manwi23/Squares/blob/main/keyboard_inner_driver.v) modules were written by Dr. Hauck at the University of Washington ([class.ece.uw.edu/271/hauck2/de1/keyboard](https://class.ece.uw.edu/271/hauck2/de1/keyboard)).