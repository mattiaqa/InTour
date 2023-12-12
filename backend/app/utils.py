import pandas as pd
from app.models.trail import Trail
from app.extension import trails
from app.extension import mongo

def init_trails():
    data = pd.read_excel('/assets/datasets/sentieri-storico-culturali.xls')

    for index, row in data.iterrows():
        percorso = Trail(row)
        trails.append(percorso)

def get_all_friends(user):
    user = mongo["users"].find_one({'_id':user})

    return user.get('friends', [])