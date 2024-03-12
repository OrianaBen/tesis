import pandas as pd

df = pd.read_excel('data\electric_data.xlsx',sheet_name=3,index_col=None).drop('n',axis=1)
column_names = ['A','B','N','M']
electrode_sep = df.at[1,'B'] - df.at[1,'A']

df[column_names]=df[column_names].apply(lambda x: (x/5)+1).astype(int)
df.rename(columns={'A':'a','B':'b','M':'m','N':'n','ΔV':'u','ρ̥':'rhoa','SD':'sd','I':'i','SP':'sp'},inplace=True)

topo = pd.read_excel('data\position_data.xlsx',sheet_name=2)
topo['x']=topo['x'].apply(lambda x: (((x%(x+1))*electrode_sep)-electrode_sep)).astype(float)

n = len(topo)
last_x = topo.at[topo.index[-1], 'x']

header = [{n:'#x', '#number of electrodes':'z'}]
header = pd.DataFrame(header)

la_elec = last_x + electrode_sep

middle = [{la_elec : '#a b m n u','#Number of data': 'rhoa sd i sp'}]
middle = pd.DataFrame(middle)

header.to_csv('LaNegra45_3011.csv', mode = 'w', index = False,sep='\t')
topo.to_csv('LaNegra45_3011.csv', mode = 'a', index = False, header=False,sep='\t')
middle.to_csv('LaNegra45_3011.csv', mode = 'a', index = False,sep='\t')
df.to_csv('LaNegra45_3011.csv', index=False, mode = 'a', header=False, sep='\t')
