from app.api import bp 
from flask import jsonify, request, current_app
from flask_jwt_extended import *
from app.extension import mongo
import sys
@bp.route('/friends/add', methods=['POST'])
@jwt_required()
def get_friends():
    try:
        friend_to_add = request.json['nickname']
        user = get_jwt_identity()['username']

        friend = mongo['users'].find_one(
            {'_id':friend_to_add}
        )

        if(not friend):
            return jsonify({"Error": "User not found"}), 404

        # TODO: check if user is already friend of friend_to_add
        mongo['users'].update_one(
            {'_id' : user},
            {'$addToSet' : {'friends' : friend_to_add}}
        )
        mongo['users'].update_one(
            {'_id' : friend_to_add},
            {'$addToSet' : {'friends' : user}}
        )

        return jsonify({"Status": "Success"}), 200
    
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"Error": "Internal Server Error"}), 500

