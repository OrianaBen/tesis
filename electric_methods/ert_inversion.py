import pygimli as pg
from pygimli.physics import ert
import matplotlib.pyplot as plt
from matplotlib import colormaps
import numpy as np

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

data['err'] = ert.estimateError(data, relativeError=0.02,absoluteError=2, absoluteUError=0.2)
data.remove(data['err']>0.5)
ert.show(data, data['err']*100)
plt.savefig('error_tomo3.png')

mgr = ert.ERTManager(data)
mod = mgr.invert(data, lam=20, stopAtChi1 = True, verbose = True,quality=34.5, 
                 paraMaxCellSize = 0.1, robustData = True)
# np.testing.assert_approx_equal(mgr.inv.chi2(), 1, significant=2)
# np.testing.assert_approx_equal(mgr.inv.relrms(), 5, significant=2)

mgr.showResultAndFit(cMap = 'rainbow')
plt.savefig('fit_and_model_tomo3.png')

mgr.showResult(mod, cMap = 'rainbow', label="Resistividad ($\\Omega$ m)", 
            xlabel = 'x (m)', ylabel = 'z (m)')

plt.savefig('tomo3.png')

#RRMSE: relative root-mean-square misfit, chi2: 
#CHI2: chi-squared misfit (mean of squared error-weighted misfit).
#rrmse debe estar entre 0 - 5% y chi2 cercano a 1
#tomo 0 lam 0.05 paraSize 0.1 quality 28
#tomo 1 lam 8 quality 34.5
#tomo 2 lam 20 quality 34.5
#tomo 3 lam 20 quality 34.5