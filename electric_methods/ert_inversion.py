import pygimli as pg
from pygimli.physics import ert
import matplotlib.pyplot as plt
from matplotlib import colormaps

data = ert.load('data\\tomo2.csv')
print(data)
ert.show(data)

# fig, ax = plt.subplots()
# ax.plot(pg.x(data), pg.z(data),'.')
# ax.set_aspect(1)
# plt.show()

# k_num = ert.createGeometricFactors(data, numerical=True)
# k_ana = ert.createGeometricFactors(data, numerical=False)

# # ert.show(data, vals=k_num/k_ana, label='Efecto de topografía',
# #          cMap="plasma",logscale=True)

# data['k']=k_num
# data['err'] = ert.estimateError(data,absoluteError=5)
# #ert.show(data)

# mgr = ert.ERTManager(data)
# # mgr.invert(data, lam=10, verbose = True,quality=30, paraDepth =20)
# # mgr.showResult(cMap='verbose')
# mod = mgr.invert(data, lam=25, verbose=True, quality=35)

# mgr.showResult(cMap='viridis')