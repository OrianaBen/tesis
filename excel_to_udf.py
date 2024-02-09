import pandas as pd

df = pd.read_excel('data\electric_data.xlsx',sheet_name=1).drop('n',axis=1)

column_names = ['A','B','N','M']
df[column_names]=df[column_names].apply(lambda x: (x/5)+1).astype(int)

df.rename(columns={'A':'a','B':'b','M':'m','N':'n','ΔV':'u','ρ̥':'rhoa','SD':'err','I':'i','SP':'sp'},inplace=True)

topo = pd.read_excel('data\position_data.xlsx',sheet_name=0)

df.to_csv('data\electric.csv',sep=' ',index=False)
topo.to_csv('data\position.csv', sep='\t', index=False)

a = pd.read_csv('data\electric.csv',index_col=False)
b = pd.read_csv('data\position.csv',index_col=False)

merged = pd.concat([b,a], join='outer',axis=0)
print(merged)