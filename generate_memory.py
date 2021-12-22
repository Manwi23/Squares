figures = { # up, down, left, right, rgb0
    'blue' : [200, 300, 100, 200, 0, 0, 10],
    'red' : [100, 150, 80, 100, 10, 0, 0],
    'green' : [300, 350, 400, 480, 0, 10, 0]
}

prefix = """DEPTH = 1024;                   -- The size of memory in words
WIDTH = 16;                    -- The size of data in bits
ADDRESS_RADIX = HEX;          -- The radix for address values
DATA_RADIX = HEX;             -- The radix for data values
CONTENT                       -- start of (address : data pairs)
BEGIN

"""

sufix = """

END;"""

with open('memory.mif', 'w') as f:
    f.write(prefix)
    cnt = 0
    for figure in figures:
        for elem in figures[figure]:
            a = str(hex(cnt))[2:].upper()
            s = str(hex(elem))[2:].upper()
            f.write(a + " : " + s + ";\n")          
            cnt += 1
    f.write(sufix)