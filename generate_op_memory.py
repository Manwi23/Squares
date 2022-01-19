prefix = """DEPTH = 128;                   -- The size of memory in words
WIDTH = 16;                    -- The size of data in bits
ADDRESS_RADIX = HEX;          -- The radix for address values
DATA_RADIX = BIN;             -- The radix for data values
CONTENT                       -- start of (address : data pairs)
BEGIN

"""

sufix = """

END;"""

board = []
cowboy = None

with open('initial_board.txt', 'r') as f:
    for i in range(10):
        l = f.readline()[:-1]
        n = list(map(lambda x: int(x), l))
        board += [n]
        if 4 in n:
            cowboy = i, n.index(4)

with open('op_memory.mif', 'w') as f:
    f.write(prefix)
    cnt = 0

    for i in range(10):
        for j in range(10):
            a = str(hex(cnt))[2:].upper()
            s = str(bin(board[i][j] * 2**8))[2:].upper()
            s = '0' * (16 - len(s)) + s
            f.write(a + " : " + s + ";\n")          
            cnt += 1

    for i in cowboy:
        a = str(hex(cnt))[2:].upper()
        s = str(bin(i))[2:].upper()
        s = '0' * (16 - len(s)) + s
        f.write(a + " : " + s + ";\n")          
        cnt += 1

    stars = sum([sum(map(lambda x: x == 1, i)) for i in board])
    a = str(hex(cnt))[2:].upper()
    s = str(bin(stars))[2:].upper()
    s = '0' * (16 - len(s)) + s
    f.write(a + " : " + s + ";\n")          
    cnt += 1

    f.write(sufix)