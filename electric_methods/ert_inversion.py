import pygimli as pg
from pygimli.physics import ert
import matplotlib.pyplot as plt
from matplotlib import colormaps
import numpy as np

data = ert.load('data\\tomo2.csv')

# fig, ax = plt.subplots()
# ax.plot(pg.x(data), pg.z(data),'.')
# ax.set_aspect(1)
# plt.show()

k_num = ert.createGeometricFactors(data, numerical=True)
k_ana = ert.createGeometricFactors(data, numerical=False)
data['k']=k_num

# ert.show(data, vals=k_num/k_ana, label='Efecto de topografía',
#          cMap="plasma",logscale=True)

data['err'] = ert.estimateError(data, relativeError=0.05,absoluteError=10)

mgr = ert.ERTManager(data)
mod = mgr.invert(data, lam=8, verbose = True,quality=33.5, 
                 paraMaxCellSize = 1, paraBoundary=0)
np.testing.assert_approx_equal(mgr.inv.chi2(), 1, significant=1)

# mgr.showResultAndFit()
# plt.savefig('fit_and_model_tomo0.png')

mgr.showResult(mod, cmap = 'rainbow', label="Resistividad ($\\Omega$ m)", 
            xlabel = 'x (m)', ylabel = 'z (m)')

plt.savefig('tomo2_test.png')

#RRMSE: relative root-mean-square misfit, chi2: 
#CHI2: chi-squared misfit (mean of squared error-weighted misfit).
#rrmse debe estar entre 0 - 20% y chi2 cercano a 1
#tomo 0 relative error 0.1 absolute error 1.5 lam 0.1 quality 35
#tomo 1 relative error 0.05 absolute error 10 lam 2.5 quality 35
#tomo 2 relative error 0.05 absolute error 10 lam 8 quality 35
#tomo 3 relative error 0.05 absolute error 10 lam 3 quality 35