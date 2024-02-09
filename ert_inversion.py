import pygimli as pg
from pygimli.physics import ert
import matplotlib.pyplot as plt

data = ert.load('data\merged.txt')
#print(data)

fig, ax = plt.subplots()
ax.set_xlim(xmin=1,xmax=(max(pg.x(data)+1)))
ax.set_ylim(ymin=2835,ymax=(max(pg.z(data))+1))
ax.plot(pg.x(data), pg.z(data),'.')
#ax.set_aspect(1)
plt.show()