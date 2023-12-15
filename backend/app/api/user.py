from app.api import bp 
from flask import jsonify, current_app, request
from flask_jwt_extended import *
from app.extension import mongo

@bp.route('/profile/data', methods=['GET'])
@jwt_required()
def get_user_data():
    """
        Retrive all the data of the current user.

        Returns:
        - If successful, returns a JSON list with all user data
          and an HTTP status code of 200.
        - If any exceptions occur during the process, 
          logs an internal server error and returns a JSON response with 
          an error message ({'Error': 'Internal Server Error'}) 
          and an HTTP status code of 500.
    """
    try:
        user = get_jwt_identity()['username']

        user_data = mongo['users'].find_one({'_id': user}, {'password': 0})

        return jsonify(user_data), 200
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"Error": "Internal Server Error"}), 500

@bp.route('/profile/post', methods=['GET'])
@jwt_required()
def get_user_post():
    """
        Retrive all the posts of the current user.

        Returns:
        - If successful, returns a JSON list with all user posts
          and an HTTP status code of 200.
        - If any exceptions occur during the process, 
          logs an internal server error and returns a JSON response with 
          an error message ({'Error': 'Internal Server Error'}) 
          and an HTTP status code of 500.
    """
    try:
        user = get_jwt_identity()['username']

        posts = mongo['posts'].find({'creator':user})

        result = []
        for post in posts:
                post['_id'] = str(post['_id'])
                result.append(post)

        return jsonify(result), 200
    
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"Error": "Internal Server Error"}), 500
    

@bp.route('/profile/edit/description', methods=['POST'])
@jwt_required()
def edit_profile_description():
    """
        Give the possibility to edit the description of the current user.

        Parameters:
        - description: field representing the text of the new description.

        Returns:
        - If successful, returns a JSON response with a status of success
          and an HTTP status code of 200.
        - If any exceptions occur during the process, 
          logs an internal server error and returns a JSON response with 
          an error message ({'Error': 'Internal Server Error'}) 
          and an HTTP status code of 500.
    """
    try:
        user = get_jwt_identity()['username']
        new_description = request.json['description']

        mongo['users'].update_one(
            {'_id' : user},
            {'$set' : {'description' : new_description}}
        )

        return jsonify({"message": "Description updated successfully"}), 200
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"Error": "Internal Server Error"}), 500