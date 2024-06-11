import bcrypt
from pymongo.errors import DuplicateKeyError
from app.auth import bp 
from flask import jsonify, request, current_app
from app.extension import mongo

@bp.route('/register', methods=['POST'])
def register():
    try:
        email = request.json['email']
        username = request.json['username']
        name = request.json['name']
        surname = request.json['surname']
        birthdate = request.json['birthdate']
        password = request.json['password'].encode('utf-8')

        salt = bcrypt.gensalt()
        password = bcrypt.hashpw(password, salt)

        newUser = {
            "_id": username,
            "name": name,
            "surname": surname,
            "email": email,
            "password": password,
            "birthdate": birthdate,
            "profile_image_url": "",
            "description":"",
            "friends" : [],
            "friends_request": [],
            "friends_pending":[]
        }

        mongo["users"].insert_one(newUser)
        return jsonify({"Status":"Done"}), 200
    
    except DuplicateKeyError:
        return jsonify({"Error":"Username already taken"}), 403
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"Error":"Internal Server Error"})