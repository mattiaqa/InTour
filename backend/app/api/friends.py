from app.api import bp 
from flask import jsonify, request, current_app
from flask_jwt_extended import *
from app.extension import mongo

@bp.route('/friends/add', methods=['POST'])
@jwt_required()
def add_friends():
    """
        Adds a friend for the current user.

        Parameters:
        - username: field representing the username of friend to be added.

        Returns:
        - If successful, returns a JSON response with a status of success
          and an HTTP status code of 200.
        - If the friend user is not found in the database, 
          returns a JSON response with an error message
          and an HTTP status code of 404.
        - If any exceptions occur during the process, 
          logs an internal server error and returns a JSON response with 
          an error message ({'Error': 'Internal Server Error'}) 
          and an HTTP status code of 500.
    """
    try:
        friend_to_add = request.json['username']
        user = get_jwt_identity()['username']

        friend = mongo['users'].find_one(
            {'_id':friend_to_add}
        )

        if(not friend):
            return jsonify({"Error": "User not found"}), 404

        # update the friends list for both of these two users
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


@bp.route('/friends/remove', methods=['POST'])
@jwt_required()
def remove_friends():
    """
        Remove a friend for the current user.

        Parameters:
        - username: field representing the username of friend to be removed.

        Returns:
        - If successful, returns a JSON response with a status of success
          and an HTTP status code of 200.
        - If the friend user is not found in the database, 
          returns a JSON response with an error message
          and an HTTP status code of 404.
        - If any exceptions occur during the process, 
          logs an internal server error and returns a JSON response with 
          an error message ({'Error': 'Internal Server Error'}) 
          and an HTTP status code of 500.
    """
    try:
        friend_to_add = request.json['username']
        user = get_jwt_identity()['username']

        friend = mongo['users'].find_one(
            {'_id':friend_to_add}
        )

        if(not friend):
            return jsonify({"Error": "User not found"}), 404

        # update the friends list for both of these two users
        mongo['users'].update_one(
            {'_id' : user},
            {'$pull' : {'friends' : friend_to_add}}
        )
        mongo['users'].update_one(
            {'_id' : friend_to_add},
            {'$pull' : {'friends' : user}}
        )

        return jsonify({"Status": "Success"}), 200
    
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"Error": "Internal Server Error"}), 500