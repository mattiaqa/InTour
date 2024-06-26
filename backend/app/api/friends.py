from app.api import bp 
from flask import jsonify, request, current_app
from flask_jwt_extended import *
from app.extension import mongo
from app.utils import isFriendOf

@bp.route('/friends/request', methods=['POST'])
@jwt_required()
def add_friends_request():
    """
        Send a friend request.

        Parameters:
        - username: field representing the username of friend who we want to send the request.

        Returns:
        - If successful, returns a JSON response with a status of success
          and an HTTP status code of 200.
        - If the friend user is not found in the database, 
          returns a JSON response with an error message
          and an HTTP status code of 404.
        - If the users are already friend, returns 204 code.
        - If any exceptions occur during the process, 
          logs an internal server error and returns a JSON response with 
          an error message ({'Error': 'Internal Server Error'}) 
          and an HTTP status code of 500.
    """
    try:
        friend_to_add = request.json['username']
        user = get_jwt_identity()['username']

        if(friend_to_add == user):
            return jsonify({"Error": "You cannot send the request to yourself"}), 204

        friend = mongo['users'].find_one(
            {'_id' : friend_to_add}
        )

        if(not friend):
            return jsonify({"Error": "Utente non trovato!"}), 404

        if(isFriendOf(user, friend_to_add)):
            return jsonify({"Error": "L'utente è già nella lista dei tuoi amici!"}), 204

        # update the friends list for both of these two users
        mongo['users'].update_one(
            {'_id' : friend_to_add},
            {'$addToSet' : {'friends_request' : user}}
        )
        mongo['users'].update_one(
            {'_id' : user},
            {'$addToSet' : {'friends_pending' : friend_to_add}}
        )

        return jsonify({"Status": "Success"}), 200
    
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"Error": "Internal Server Error"}), 500

@bp.route('/friends/accept', methods=['POST'])
@jwt_required()
def add_friends():
    """
        Accept a friend request.

        Parameters:
        - username: field representing the username of friend to be accepted.

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
        current_user = get_jwt_identity()['username']

        friend = mongo['users'].find_one(
            {'_id':friend_to_add}
        )

        if(not friend):
            return jsonify({"Error": "Utente non trovato!"}), 404

        user = mongo['users'].find_one(
            {'_id':current_user}
        )

        if(friend_to_add not in user['friends_request']):
            return jsonify({"Error": "User not in friend requests"}), 404

        # update the friends list for both of these two users
        mongo['users'].update_one(
            {'_id' : current_user},
            {'$addToSet' : {'friends' : friend_to_add}},
        )

        mongo['users'].update_one(
            {'_id' : current_user},
            {'$pull' : {'friends_request': friend_to_add}}
        )

        mongo['users'].update_one(
            {'_id' : friend_to_add},
            {'$addToSet' : {'friends' : current_user}},
        )

        mongo['users'].update_one(
            {'_id' : friend_to_add},
            {'$pull' : {'friends_pending': current_user}}
        )

        return jsonify({"Status": "Success"}), 200
    
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"Error": "Internal Server Error"}), 500


@bp.route('/friends/reject', methods=['POST'])
@jwt_required()
def add_friends_request_reject():
    """
        Reject a friend requestxs.

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

        if(friend_to_add == user):
            return jsonify({"Status": "Success"}), 200

        friend = mongo['users'].find_one(
            {'_id':friend_to_add}
        )

        if(not friend):
            return jsonify({"Error": "Utente non trovato!"}), 404

        # update the friends list for both of these two users
        mongo['users'].update_one(
            {'_id' : user},
            {'$pull' : {'friends_request' : friend_to_add}}
        )
        mongo['users'].update_one(
            {'_id' : friend_to_add},
            {'$pull' : {'friends_pending' : user}}
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
            return jsonify({"Error": "Utente non trovato!"}), 404

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


@bp.route('/friends/undo_request', methods=['POST'])
@jwt_required()
def add_friends_undo_request():
    """
        Undo a friend request.

        Parameters:
        - username: field representing the username of friend who the user sent the request.

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

        if(friend_to_add == user):
            return jsonify({"Status": "Success"}), 200

        friend = mongo['users'].find_one(
            {'_id' : friend_to_add}
        )

        if(not friend):
            return jsonify({"Error": "Utente non trovato!"}), 404

        # update the friends list for both of these two users
        mongo['users'].update_one(
            {'_id' : user},
            {'$pull' : {'friends_pending' : friend_to_add}}
        )

        mongo['users'].update_one(
            {'_id' : friend_to_add},
            {'$pull' : {'friends_request' : user}}
        )

        return jsonify({"Status": "Success"}), 200
    
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"Error": "Internal Server Error"}), 500