from PIL import Image
import numpy as np

images = {
    'dirt' : np.array(Image.open("images/dirt2.bmp")),
    'box' : np.array(Image.open("images/box2.bmp")),
    'cowboy' : np.array(Image.open("images/cowboy.bmp")),
    'wall' : np.array(Image.open("images/wall.bmp")),
    'goal' : np.array(Image.open("images/goal2.bmp")),
    'youwon' : np.array(Image.open("images/youwon.bmp")),
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