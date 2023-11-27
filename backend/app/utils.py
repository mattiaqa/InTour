import pandas as pd
from app.models.percorso import Percorso
from app.extension import percorsi

def init_percorsi():
    data = pd.read_excel('/assets/datasets/sentieri-storico-culturali.xls')

    for index, row in data.iterrows():
        percorso = Percorso(row)
        percorsi.append(percorso)