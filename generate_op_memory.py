from PIL import Image
import numpy as np

cowboy = (5,5)

board = [[2]*10] + [[2] + [0]*8 + [2]]*8 + [[2]*10]
# board = [[2]*10] + [[2] + [2]*8 + [2]]*8 + [[2]*10]
board = tuple([tuple(i) for i in board])
board = [list(i) for i in board]
board[cowboy[0]][cowboy[1]] = 4
board[cowboy[0]+1][cowboy[1]] = 2
board[cowboy[0]-1][cowboy[1]] = 5
board[1][6] = 5
board[7][7] = 5
board[2][3] = 1

# board = [[0]*10]*10

prefix = """DEPTH = 128;                   -- The size of memory in words
WIDTH = 16;                    -- The size of data in bits
ADDRESS_RADIX = HEX;          -- The radix for address values
DATA_RADIX = BIN;             -- The radix for data values
CONTENT                       -- start of (address : data pairs)
BEGIN

"""

sufix = """

END;"""

with open('op_memory.mif', 'w') as f:
    f.write(prefix)
    cnt = 0

    for i in range(10):
        for j in range(10):
            a = str(hex(cnt))[2:].upper()
            s = str(bin(board[i][j] * 2**8))[2:].upper()
            # print(board[i][j] * 2**8)
            s = '0' * (16 - len(s)) + s
            f.write(a + " : " + s + ";\n")          
            cnt += 1

    for i in cowboy:
        a = str(hex(cnt))[2:].upper()
        s = str(bin(i))[2:].upper()
        s = '0' * (16 - len(s)) + s
        f.write(a + " : " + s + ";\n")          
        cnt += 1

    f.write(sufix)