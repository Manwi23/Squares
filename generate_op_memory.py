prefix = """DEPTH = 128;                   -- The size of memory in words
WIDTH = 16;                    -- The size of data in bits
ADDRESS_RADIX = HEX;          -- The radix for address values
DATA_RADIX = BIN;             -- The radix for data values
CONTENT                       -- start of (address : data pairs)
BEGIN

"""

prefix2 = """DEPTH = 1024;                   -- The size of memory in words
WIDTH = 16;                    -- The size of data in bits
ADDRESS_RADIX = HEX;          -- The radix for address values
DATA_RADIX = BIN;             -- The radix for data values
CONTENT                       -- start of (address : data pairs)
BEGIN

"""

sufix = """

END;"""

boards = []
cowboys = []

with open('boards.txt', 'r') as f:
    for b in range(8):
        board = []
        for i in range(10):
            l = f.readline()[:-1]
            n = list(map(lambda x: int(x), l))
            board += [n]
            if 4 in n:
                cowboys += [(i, n.index(4))]
        boards += [board]
        l = f.readline()

with open('op_memory.mif', 'w') as f:
    with open('boards_memory.mif', 'w') as f2:
        cnt = 0
        f2.write(prefix2)
        f.write(prefix)
        for b in range(8):
            board = boards[b]

            for i in range(10):
                for j in range(10):
                    a = str(hex(cnt))[2:].upper()
                    s = str(bin(board[i][j] * 2**8))[2:].upper()
                    s = '0' * (16 - len(s)) + s
                    if not b: f.write(a + " : " + s + ";\n")       
                    f2.write(a + " : " + s + ";\n")   
                    cnt += 1

            for i in cowboys[b]:
                a = str(hex(cnt))[2:].upper()
                s = str(bin(i))[2:].upper()
                s = '0' * (16 - len(s)) + s
                if not b: f.write(a + " : " + s + ";\n")    
                f2.write(a + " : " + s + ";\n")       
                cnt += 1

            stars = sum([sum(map(lambda x: x == 1, i)) for i in board])
            a = str(hex(cnt))[2:].upper()
            s = str(bin(stars))[2:].upper()
            s = '0' * (16 - len(s)) + s
            if not b: f.write(a + " : " + s + ";\n")
            f2.write(a + " : " + s + ";\n")   
            cnt += 1

            while cnt % 128 != 0:
                a = str(hex(cnt))[2:].upper()
                f2.write(a + " : " + '0'*16 + ";\n")
                cnt += 1

        f.write(sufix)
        f2.write(sufix)