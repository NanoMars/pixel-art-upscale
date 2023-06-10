from PIL import Image

source0 = Image.open("source.jpg")

# resize the image
SCALE = 3
source0 = source0.resize((source0.width*SCALE, source0.height*SCALE))

source = source0.convert("L")

pixels=source.load()

s=""

for i in range(source.width):
    for j in range(source.height):
        s+=str(pixels[i,j])+' '
    s=s[:-1]+"\n"

with open('./source.txt','wt') as f :
    f.write(s[:-1])
    