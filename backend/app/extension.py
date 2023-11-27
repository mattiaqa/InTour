import pymongo
import os 
import urllib.parse

from dotenv import load_dotenv

load_dotenv()

host = urllib.parse.quote_plus(os.environ.get('DB_URL')) 
port = urllib.parse.quote_plus(os.environ.get('DB_PORT')) 
user = urllib.parse.quote_plus(os.environ.get('DB_USER'))
pwd = urllib.parse.quote_plus(os.environ.get('DB_PWD'))

mongo = pymongo.MongoClient('mongodb://%s:%s@%s:%s' % (user, pwd, host, port))["VeneTour"]

token_blacklist = []
percorsi = []