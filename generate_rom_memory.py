from PIL import Image
import numpy as np

figures = { # rgbcolor1, rgbcolor2
    'blue' : [0, 0, 2**8 - 1, 0, 2**8 - 1, 0],
    'red' : [2**8 - 1, 0, 0, 0, 2**8 - 1, 2**8 - 1],
    'green' : [0, 2**8 - 1, 0, 2**8 - 1, 2**8 - 1, 0],
    'white' : [2**8 - 1, 2**8 - 1, 2**8 - 1, 2**8 - 1,2**8 - 1, 2**8 - 1]
}

images = {
    'heart' : np.array(Image.open("heart.bmp")),
    'mo' : np.array(Image.open("mo.bmp")),
    'km' : np.array(Image.open("km.bmp"))
}

prefix = """DEPTH = 18432;                   -- The size of memory in words
WIDTH = 24;                    -- The size of data in bits
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
        color1 = figures[figure][:3]
        color2 = figures[figure][3:]
        for i in range(48*48):
            a = str(hex(cnt))[2:].upper()
            s = ''
            for col in (color1 if (cnt)%2 == 0 else color2):
                tmp = str(hex(col))[2:].upper()
                tmp = '0' * (2 - len(tmp)) + tmp
                s += tmp
            f.write(a + " : " + s + ";\n")          
            cnt += 1

    for image in images:
        img = images[image]
        for i in range(48):
            for j in range(48):
                a = str(hex(cnt))[2:].upper()
                s = ''
                for col in range(3):
                    tmp = str(hex(img[i][j][col]))[2:].upper()
                    tmp = '0' * (2 - len(tmp)) + tmp
                    s += tmp
                f.write(a + " : " + s + ";\n")          
                cnt += 1

    f.write(sufix)