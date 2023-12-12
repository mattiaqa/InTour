from app.api import bp 
from flask import jsonify, request, current_app
from flask_jwt_extended import *
from app.extension import mongo

@bp.route('/friends/add', methods=['POST'])
@jwt_required()
def get_friends():
    try:
        friend_to_add = request.json['nickname']
        user = get_jwt_identity()['username']

        exist_friend = mongo['users'].find(
            {'_id':friend_to_add}
        )

        if(not exist_friend):
            return jsonify({"Error": "User not found"}), 404

        # TODO: check if user is already friend of friend_to_add
        mongo['users'].update_one(
            {'_id' : user},
            {'$push' : {'friends' : friend_to_add}}
        )

        return jsonify({"Status": "Success"}), 200
    
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"Error": "Internal Server Error"}), 500

