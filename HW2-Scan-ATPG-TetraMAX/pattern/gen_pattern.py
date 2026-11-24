import random

def to_hex_str(value, width):  # width in hex digits
    return format(value, f'0{width}X')

filename = "test_patterns.txt"

with open(filename, "w") as f:
    
    for i in range(1, 1001):
        ac = random.getrandbits(32)
        x = random.getrandbits(16)
        result = (ac + x) & 0xFFFFFFFF

        line = f" {to_hex_str(ac, 8)}     {to_hex_str(x, 4)}     {to_hex_str(result, 8)}\n"
        f.write(line)