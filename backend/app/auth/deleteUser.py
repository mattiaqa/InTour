from app.auth import bp 
from flask import jsonify, request, current_app
from app.extension import mongo
from flask_jwt_extended import *
import shutil

@bp.route('/delete', methods=['POST'])
@jwt_required()
def deleteUser():
    try:
        username = request.json['username']

        if not username:
            return jsonify({"Error":"Missing parameters!"}), 400

        query = {"_id" : username}
        result = mongo['users'].delete_one(query)

        if result:
            shutil.rmtree(f'uploads/{username}/')
            return jsonify({"Status":"Success"}), 200

        return jsonify({"Error":"Username not found"}), 404
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"Error":"Internal Server Error"}), 500

