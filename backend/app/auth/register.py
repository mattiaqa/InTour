import bcrypt
from pymongo.errors import DuplicateKeyError

from app.auth import bp 
from flask import jsonify, request
from app.extension import mongo

@bp.route('/register', methods=['POST'])
def register():
    try:
        email = request.json['email']
        username = request.json['username']
        nome = request.json['nome']
        cognome = request.json['cognome']
        dataNascita = request.json['dataNascita']
        password = request.json['password'].encode('utf-8')

        salt = bcrypt.gensalt()
        password = bcrypt.hashpw(password, salt)

        newUser = {
            "_id": username,
            "nome": nome,
            "cognome": cognome,
            "email": email,
            "password": password,
            "dataNascita": dataNascita,
            "friends" : []
        }

        result = mongo["users"].insert_one(newUser)

    except DuplicateKeyError:
        return 'Username already taken', 403

    return "Done", 200
