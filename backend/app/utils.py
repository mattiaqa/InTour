import pandas as pd
from app.models.trail import Trail
from app.extension import trails
from app.extension import mongo
from app.extension import trails

def allowed_file(filename):
    ALLOWED_EXTENSIONS = {'png', 'jpeg'}

    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def init_trails():
    data = pd.read_excel('/assets/datasets/sentieri-storico-culturali.xls')

    for index, row in data.iterrows():
        percorso = Trail(row, index)
        trails.append(percorso)

def get_all_friends(user):
    user = mongo["users"].find_one({'_id':user})

    return user.get('friends', [])

def isFriendOf(userToSearch, userLoggedIn):
    current_user = mongo["users"].find_one(
        {'_id': userLoggedIn, 'friends': userToSearch}
    )

    if current_user:
        return True  # UserToSearch is a friend of userLoggedIn
    else:
        return False  # UserToSearch is not a friend of userLoggedIn
