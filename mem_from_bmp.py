import numpy as np

cnt = 0

for i in range(10):
    for j in range(10):
        # k = 10*i + j
        r = 48 * i
        c = 48 * j
        n = np.random.choice([0,1,2,4], p=[0.5, 0.2, 0.2, 0.1]) if i not in [0,9] and j not in [0,9] else 3
        if n == 2:
            print(f"8'd{cnt}"+": data_read_ent <= {"+f"3'd0, 9'd{r}, 9'd{c}"+"};")
            cnt += 1
        print(f"8'd{cnt}"+": data_read_ent <= {"+f"3'd{n}, 9'd{r}, 9'd{c}"+"};")
        cnt += 1
        