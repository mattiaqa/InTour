import pandas as pd
import spacy
from app.models.trail import Trail
from app.extension import trails
from app.extension import mongo
from app.extension import trails

nlp = spacy.load("it_core_news_lg")

def allowed_file(filename):
    ALLOWED_EXTENSIONS = {'png', 'jpg'}

    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def init_trails():
    data = pd.read_excel('/assets/datasets/sentieri-storico-culturali.xls')

    for index, row in data.iterrows():
        percorso = Trail(row)
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

def extract_preferences(user_input_text):
    doc = nlp(user_input_text.lower())

    trail_type = None
    length = None
    location = None
    difficulty = None
    
    for token in doc:
        if token.dep_ == "nsubj" and token.head.pos_ == "VERB":
            trail_type = token.text
        if token.text == "lungo":
            length = "lungo"
        if token.text == "corto":
            length = "corto"
        if token.text == "luogo" or token.text == "partenza":
            location = token.head.text
        if token.text == "difficile":
            difficulty = "difficile"
        if token.text == "facile":
            difficulty = "facile"

    preferences = {
        "trail_type":trail_type,
        "length":length,
        "location":location,
        "difficulty":difficulty
    }

    return preferences