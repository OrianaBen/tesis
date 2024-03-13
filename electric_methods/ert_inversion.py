import pygimli as pg
from pygimli.physics import ert
import matplotlib.pyplot as plt
from matplotlib import colormaps

data = ert.load('data\\tomo3.csv')

# fig, ax = plt.subplots()
# ax.plot(pg.x(data), pg.z(data),'.')
# ax.set_aspect(1)
# plt.show()

k_num = ert.createGeometricFactors(data, numerical=True)
k_ana = ert.createGeometricFactors(data, numerical=False)
data['k']=k_num

# ert.show(data, vals=k_num/k_ana, label='Efecto de topografía',
#          cMap="plasma",logscale=True)

data['err'] = ert.estimateError(data, relativeError=0.01,absoluteError=10)

mgr = ert.ERTManager(data)
mod = mgr.invert(data, lam=10, verbose = True,quality=34)
#mgr.showResultAndFit()

mgr.showResult(mod, cmap = 'coolwarm')