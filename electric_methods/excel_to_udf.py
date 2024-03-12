import pandas as pd

#correr para todas las hojas de datos
for i in range(4):

    #leer datos electricos como DataFrame
    #y guardar cantidad de datos en una variable
    df = pd.read_excel('data\electric_data _modified.xlsx',sheet_name=i,index_col=None)
    data_number = len(df)

    #filtrar datos para que no se muestre el índice
    #ni las observaciones
    labels_todrop = ['n', 'Observaciones', 'observaciones']
    filter = df.filter(labels_todrop)
    df.drop(filter, inplace=True, axis=1)

    #guardar nombres de columnas de interés en una lista
    column_names = ['A','B','N','M']

    #definir el valor de separación de electrodos,
    #siempre es el primer valor en A menos el primero en B
    electrode_sep = df.at[1,'B'] - df.at[1,'A']

    #convertir los valores de A, B, M y N al formato UDF
    #esto es, convertir los valores al índice del electrodo correspondiente
    df[column_names]=df[column_names].apply(lambda x: (x/electrode_sep)+1).astype(int)
    
    #leer archivo de topografía (con solo índice de electrodos y altura)
    #luego, convertir el valor de índice de electrodo a su posición relativa
    #a la separación de electrodos, comenzando en cero
    topo = pd.read_excel('data\position_xz.xlsx',sheet_name=i)
    topo['x']=topo['x'].apply(lambda x: (((x%(x+1))*electrode_sep)-electrode_sep)).astype(float)

    #guardar en una variable el número total de electrodos 
    n = len(topo)

    #crear el header que requiere archivo con el formato UDF y convertir
    #el diccionario en un DataFrame
    header = [{n:'#x', '#number of electrodes':'z'}]
    header = pd.DataFrame(header)

    #crear el "header" que marca el final de la topografía y el inicio
    #de los datos de resistividad, y convertir el dic en DF
    middle = [{data_number : '#a b m n u','#Number of data': 'rhoa sd i sp'}]
    middle = pd.DataFrame(middle)

    #crear el archivo de tomografía para cada iteración
    #el header.to_csv crea el archivo, y los demás df se pegan a él
    header.to_csv('data\\tomo'+str(i)+'.csv', mode = 'w', index = False,sep='\t')
    topo.to_csv('data\\tomo'+str(i)+'.csv', mode = 'a', index = False, header=False,sep='\t')
    middle.to_csv('data\\tomo'+str(i)+'.csv', mode = 'a', index = False,sep='\t')
    df.to_csv('data\\tomo'+str(i)+'.csv', index=False, mode = 'a', header=False, sep='\t')
