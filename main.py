from PIL import Image

source0 = Image.open("source.jpg")

# resize the image
SCALE = 3
source0 = source0.resize((source0.width*SCALE, source0.height*SCALE))

source = source0.convert("L")

pixels = source.load()

grid_num = {
    "x": 0,
    "y": 0
}


def avg_color(c1):
    #return tuple(sum(p1[i] for p1 in c1)//len(c1) for i in range(3))
    return sum(c1)//len(c1)


def is_same_grid(c1, c2):
    a1 = avg_color(c1)
    #return all(abs(a1[i]-c2[i]) < 256*0.15 for i in range(3))
    return abs(a1-c2) < 55


# scanning how many grid is in one row
pos = set()
pix = []
for j in range(2, source.height, 3):
    rec = len(pos)
    last = [pixels[2, j]]
    for i in range(0, source.width):
        current = pixels[i, j]
        if is_same_grid(last, current):
            last.append(current)
        else:
            last = [current]
            if i not in pos:
                pix.append((i,j))
            pos.add(i)
    print(f"{j}({j/source.height*100:.2f}%)",
          "found: ", len(pos)-rec)
    # if j == source.height-1:
    #     if source.width-pos[-1] < 10:
    #         break
    #     j = 2
    # else:
    #     j += 3


# # scanning how many grid is in one column
# last = pixels[0, 0]
# for j in range(1, source.height):
#     current = pixels[i, 2]
#     if is_not_same_grid(last, current):
#         last = current
#         grid_num["y"] += 1
#         for i in range(source.width):
#             pixels[i, j] = (255, 255, 0)

pixels0 = source0.load()

for p in pos:
    for j in range(source.height):
        pixels0[p, j] = (255, 0, 0)
    # for i in range(source.height):
    #     pixels[i, p[1]] = (0, 255, 255)
    # pixels0[p[0], p[1]]  = (255, 0, 0)


print("total: ", len(pos), pos)

source0.save("result.jpg")
