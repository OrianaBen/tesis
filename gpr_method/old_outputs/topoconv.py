import pandas as pd
import os

arc = os.listdir('gpr_method\\topo\\raw')

for f in arc: 
    df = pd.read_csv('gpr_method\\topo\\raw\\'+f, index_col=False, header=0)
    df = df.drop(['OBJECTID', 'ID'], axis=1)
    df.columns = ['E','N', 'Z'] 
    df.to_csv('gpr_method\\topo\\'+f, index=False, index_label=False)