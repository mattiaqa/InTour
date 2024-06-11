from app.api import bp 
from flask import jsonify, current_app, request
from flask_jwt_extended import *
from app.extension import mongo
import os 
from bson import ObjectId
import re
from app.utils import isFriendOf

@bp.route('/profile/<username>/data', methods=['GET'])
@jwt_required()
def get_user_data(username):
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
        user_data = mongo['users'].find_one({'_id': username}, {'password': 0})

        return jsonify(user_data), 200
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"Error": "Internal Server Error"}), 500


@bp.route('/profile/<username>/profile_image', methods=['GET'])
@jwt_required()
def get_user_profile_image(username):
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
        user_data = mongo['users'].find_one({'_id': username}, {'password': 0})

        if not user_data:
            return jsonify({"Error":"No data found"}), 404

        return jsonify({"profile_image_url":user_data['profile_image_url']}), 200
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"Error": "Internal Server Error"}), 500


@bp.route('/profile/<username>/posts', methods=['GET'])
@jwt_required()
def get_user_post(username):
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
        current_user = get_jwt_identity()['username']

        if(not isFriendOf(username, current_user)):
            return jsonify({"Error":"Unauthorized"}), 403
            

        posts = mongo['posts'].find({'creator' : username})

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

        current_app.logger.info("%s", user)
        current_app.logger.info("%s", new_description)

        return jsonify({"message": "Description updated successfully"}), 200
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"Error": "Internal Server Error"}), 500


@bp.route('/profile/edit/image', methods=['POST'])
@jwt_required()
def edit_profile_image():
    """
        Give the possibility to edit the profile image of the current user.

        Parameters:
        - file: image to be uploaded.

        Returns:
        - If successful, returns a JSON response with a status of success
          and an HTTP status code of 200.
        - If any exceptions occur during the process, 
          logs an internal server error and returns a JSON response with 
          an error message ({'Error': 'Internal Server Error'}) 
          and an HTTP status code of 500.
        - If a file with no filename is uploaded, returns 400 error code.
    """
    try:
        if 'file' not in request.files:
            return jsonify({'error': 'No file found'}), 400

        # check if filename is void
        uploaded_file = request.files['file']
        if uploaded_file.filename == '':
            return jsonify({'error': 'Void filename'}), 400

        # check extension
        #if not allowed_file(uploaded_file.):
        #    return jsonify({'error': 'Invalid file type. Only .png and .jpg allowed'}), 400

        user = get_jwt_identity()['username']

        # create a new ObjectId to use in mongodb
        object_id = ObjectId()

        # if current user' directory does not exists, create new one
        upload_folder = f'/src/backend/static/uploads/{user}'
        if not os.path.exists(upload_folder):
            os.makedirs(upload_folder)
        
        upload_url = f'{upload_folder}/{uploaded_file.filename}'
        uploaded_file.save(upload_url)
        uploaded_url_renamed = f'{upload_folder}/{object_id}'

        os.rename(upload_url, uploaded_url_renamed)

        profile_image_url = f'/uploads/{user}/{object_id}'

        mongo['users'].update_one(
            {'_id' : user},
            {'$set' : {'profile_image_url' : profile_image_url}}
        )

        return jsonify({"Status":"Success"}), 200
    
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"Error": "Internal Server Error"}), 500
    

@bp.route('/profile/search', methods=['POST'])
@jwt_required()
def search_user():
    """
        Search for a user.

        Parameters:
        - query: name of the user to be searched.

        Returns:
        - If successful, returns a JSON response with a status of success
          and an HTTP status code of 200.
        - If any exceptions occur during the process, 
          logs an internal server error and returns a JSON response with 
          an error message ({'Error': 'Internal Server Error'}) 
          and an HTTP status code of 500.
    """
    try:
        query = request.json['query']

        regex_pattern = f".*{query}.*"
        result = []

        users = mongo['users'].find(
            {"_id": {"$regex": regex_pattern, "$options": "i"}},
            {"_id": 1}
            )

        for user in users:
            user['_id'] = str(user['_id'])
            result.append(user)

        return jsonify(result), 200
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"Error": "Internal Server Error"}), 500
    

@bp.route('/profile/remove/image', methods=['POST'])
@jwt_required()
def remove_profile_image():
    """
        Give the possibility to remove the profile image of the current user.

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

        image_url = mongo['users'].find_one(
            {'_id' : user},
            {'profile_image_url' : 1}
        )

        os.remove(f"/src/backend/static/{image_url['profile_image_url']}")

        mongo['users'].update_one(
            {'_id' : user},
            {'$set' : {'profile_image_url' : ""}}
        )
        
        return jsonify({"Status":"Success"}), 200
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"Error": "Internal Server Error"}), 500