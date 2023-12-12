from app.auth import bp 
from flask import jsonify, request, current_app
from app.extension import mongo
from flask_jwt_extended import *

import bcrypt

@bp.route('/login', methods=['POST'])
def login():
    try:
        username = request.json['username']
        clear_password = request.json['password']

        if not username or not clear_password:
            return jsonify({"Status": 401, "Reason":"Missing parameters!"})

        query = {"_id" : username}
        user = mongo['users'].find_one(query)

        if user:
            hashed_password = str(user['password'], encoding='utf8')
            if bcrypt.checkpw(clear_password.encode('utf-8'), hashed_password.encode('utf-8')):
                identity = {'username' : username}

                ret = {'access_token' : create_access_token(identity=identity)}

                return jsonify(ret), 200
            return jsonify({"Error":"Wrong credentials"}), 403

        return jsonify({"Error":"User doesn't exist"}), 404
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"Error":"Internal Server Error"}), 500