from PIL import Image

WATER_OPEN = (17,29,53,255)
WATER_DEEP = (29,43,83,255)
WATER_SHALLOWS = (6,90,181,255)
WATER_SHORE = (41,173,255,255)
LAND_SHORE = (255,204,170,255)
LAND_GRASS = (0,228,54,255)
LAND_FOREST = (0,135,81,255)
LAND_MOUNTAIN = (194,195,199,255)

colors = {}

colors[WATER_OPEN] = 'O'
colors[WATER_DEEP] = 'D'
colors[WATER_SHALLOWS] = 'S'
colors[WATER_SHORE] = 'H'
colors[LAND_SHORE] = 'B'
colors[LAND_GRASS] = 'G'
colors[LAND_FOREST] = 'F'
colors[LAND_MOUNTAIN] = 'M'

im = Image.open('map.png')
pix = im.load()

print(f'Size: {im.size[0]}, {im.size[1]} ')

s = ''

for y in range(im.size[0]):
    for x in range(im.size[1]):
        s += colors[pix[x,y]]
            

print(s)