import pandas as pd

df = pd.read_excel('data\electric_data.xlsx',sheet_name=1).drop('n',axis=1)
column_names = ['A','B','N','M']
df[column_names]=df[column_names].apply(lambda x: (x/5)+1).astype(int)
df.rename(columns={'A':'a','B':'b','M':'m','N':'n','ΔV':'u','ρ̥':'rhoa','SD':'sd','I':'i','SP':'sp'},inplace=True)

topo = pd.read_excel('data\position_data.xlsx',sheet_name=0)
topo['x']=topo['x'].apply(lambda x: (((x%(x+1))*5)-5)).astype(int)