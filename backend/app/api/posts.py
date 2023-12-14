import os 
from datetime import datetime
from app.api import bp 
from flask import jsonify, request, current_app
from flask_jwt_extended import *
from app.extension import mongo
from app.utils import get_all_friends, isFriendOf, allowed_file
from bson import ObjectId
import magic 

@bp.route('/post/upload', methods=['POST'])
@jwt_required()
def upload_posts():
    """
        Uploads a post.

        Parameters:
        - file: image to be uploaded.
        - description: post's description 

        Returns:
        - If successful, returns a JSON response with a status of success
          and an HTTP status code of 200.
        - If the requests is not valid, return an HTTP status code of 400.
        - If any exceptions occur during the process, 
          logs an internal server error and returns a JSON response with 
          an error message ({'Error': 'Internal Server Error'}) 
          and an HTTP status code of 500.
    """

    try:
        if 'file' not in request.files:
            return jsonify({'error': 'No file found'}), 400

        # check if name file is void
        uploaded_file = request.files['file']
        if uploaded_file.filename == '':
            return jsonify({'error': 'Void name file'}), 400

        # check extension
        if not allowed_file(uploaded_file.filename):
            return jsonify({'error': 'Invalid file type. Only .png and .jpg allowed'}), 400

        # check MIME type
        mime = magic.Magic(mime=True)
        file_mime = mime.from_buffer(uploaded_file.stream.read(2048))
        if file_mime not in ['image/jpeg', 'image/png']:
            return jsonify({'error': 'Invalid MIME type. Only JPEG and PNG allowed'}), 400

        user = get_jwt_identity()['username']
        description = request.form.get('description')

        # create a new ObjectId to use in mongodb
        object_id = ObjectId()

        # use of the ObjectId as the file name
        file_name = str(object_id) + '.jpg'

        # if current user' directory does not exists, create new one
        upload_folder = f'uploads/{user}'
        if not os.path.exists(upload_folder):
            os.makedirs(upload_folder)
        
        upload_url = f'{upload_folder}/{file_name}'
        uploaded_file.save(upload_url)

        # calculate the current date
        current_date = datetime.now().date()

        new_post = {
            "_id" : object_id,
            "creator" : user,
            "img_url" : upload_url,
            "description" : description,
            "date" : str(current_date), 
            "like" : 0,
            "comments" : []
        }

        mongo["posts"].insert_one(new_post)
        return jsonify({"Status":"Success"}), 200
    
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"Error": "Internal Server Error"}), 500


@bp.route('/post/delete', methods=['POST'])
@jwt_required()
def delete_posts():
    """
        Delete a post.

        Parameters:
        - post_id: id of the post.

        Returns:
        - If successful, returns a JSON response with a status of success
          and an HTTP status code of 200.
        - If the requests is not valid, return an HTTP status code of 400.
        - If the post is not found, return an HTTP status code of 404.
        - If any exceptions occur during the process, 
          logs an internal server error and returns a JSON response with 
          an error message ({'Error': 'Internal Server Error'}) 
          and an HTTP status code of 500.
    """
    try:
        post_id = request.json.get('post_id')
        user = get_jwt_identity()['username']
        
        # Check if the post_id is a valid ObjectId
        if not ObjectId.is_valid(post_id):
            return jsonify({"Error": "Invalid post_id format"}), 400
        
        query = {"_id": ObjectId(post_id)}
        result = mongo["posts"].delete_one(query)
        
        # Check if the post was found and deleted
        if result.deleted_count == 1:
            # remove the image from uploads folder
            os.remove(f"uploads/{user}/{post_id}.jpg")
            return jsonify({"Status": "Success"}), 200
        else:
            return jsonify({"Error": "Post not found"}), 404

    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"Error": "Something went wrong"}), 500

@bp.route('/post', methods=['GET'])
@jwt_required()
def fetch_friend_posts():
    """
        Return a list of posts from current user's friends.

        Returns:
        - If successful, returns a JSON list with all the posts
          and an HTTP status code of 200.
        - If any exceptions occur during the process, 
          logs an internal server error and returns a JSON response with 
          an error message ({'Error': 'Internal Server Error'}) 
          and an HTTP status code of 500.
    """
    try:
        user = get_jwt_identity()['username']
        friends_list = get_all_friends(user)
        result = []

        #TODO: add dynamic post loading
        for friend in friends_list:
            friend_posts = mongo['posts'].find({'creator' : friend}).limit(10).sort('date')

            for post in friend_posts:
                post['_id'] = str(post['_id'])
                result.append(post)
            
        return jsonify(result), 200

    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"error": "something went wrong"}), 500
    
@bp.route('/post/comment', methods=['POST'])
@jwt_required()
def add_comment_to_post():
    """
        Add a comment to a post

        Parameters:
        - post_id: id of the post.
        - comment: text of the comment to be inserted

        Returns:
        - If successful, returns a JSON response with a status of success
          and an HTTP status code of 200.
        - If the requests is not valid, return an HTTP status code of 400.
        - If the post is not found, return an HTTP status code of 404.
        - If any exceptions occur during the process, 
          logs an internal server error and returns a JSON response with 
          an error message ({'Error': 'Internal Server Error'}) 
          and an HTTP status code of 500.
    """
    try:
        user = get_jwt_identity()
        post_id = request.json['post_id']
        comment_text = request.json['comment']

        if not post_id or not comment_text:
            return jsonify({"Error":"Missing Parameters"}), 400
        
        post = mongo['posts'].find_one({'_id' : ObjectId(post_id)})

        if not post:
            return jsonify({"Error":"Post not found"}), 404
        
        # if the current user is not friend of the post's creator, denies access
        if not isFriendOf(post['creator'], user['username']):
            return jsonify({"Error":"Unathorized"}), 403
        
        comment = {
            'user' : user['username'],
            'comment': comment_text,
            'comment_date': datetime.now().strftime("%Y-%m-%d")
        }

        mongo['posts'].update_one(
            {'_id': ObjectId(post_id)},
            {'$push': {'comments': comment}}
        )

        return jsonify({"Status":"Success"}), 200

    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"error": "something went wrong"}), 500
    

@bp.route('/post/like', methods=['POST'])
@jwt_required()
def like_post():
    """
        Add a like to a post

        Parameters:
        - post_id: id of the post.

        Returns:
        - If successful, returns a JSON response with a status of success
          and an HTTP status code of 200.
        - If the requests is not valid, return an HTTP status code of 400.
        - If the post is not found, return an HTTP status code of 404.
        - If any exceptions occur during the process, 
          logs an internal server error and returns a JSON response with 
          an error message ({'Error': 'Internal Server Error'}) 
          and an HTTP status code of 500.
    """
    try:
        user = get_jwt_identity()
        post_id = request.json['post_id']

        if not post_id:
            return jsonify({"Error":"Missing Parameters"}), 400
        
        post = mongo['posts'].find_one({'_id' : ObjectId(post_id)})

        if not post:
            return jsonify({"Error":"Post not found"}), 404
        
        # if the current user is not friend of the post's creator, denies access
        if not isFriendOf(post['creator'], user['username']):
            return jsonify({"Error":"Unauthorized"}), 403
    
        mongo['posts'].update_one(
            {'_id': ObjectId(post_id)},
            {'$inc': {'like': 1}}
        )

        return jsonify({"Status":"Success"}), 200

    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"error": "something went wrong"}), 500
    
@bp.route('/post/dislike', methods=['POST'])
@jwt_required()
def dislike_post():
    """
        Remove a like to a post

        Parameters:
        - post_id: id of the post.

        Returns:
        - If successful, returns a JSON response with a status of success
          and an HTTP status code of 200.
        - If the requests is not valid, return an HTTP status code of 400.
        - If the post is not found, return an HTTP status code of 404.
        - If any exceptions occur during the process, 
          logs an internal server error and returns a JSON response with 
          an error message ({'Error': 'Internal Server Error'}) 
          and an HTTP status code of 500.
    """
    try:
        user = get_jwt_identity()
        post_id = request.json['post_id']

        if not post_id:
            return jsonify({"Error":"Missing Parameters"}), 400
        
        post = mongo['posts'].find_one({'_id' : ObjectId(post_id)})

        if not post:
            return jsonify({"Error":"Post not found"}), 404
        
        # if the current user is not friend of the post's creator, denies access
        if not isFriendOf(post['creator'], user['username']):
            return jsonify({"Error":"Unauthorized"}), 403
    
        mongo['posts'].update_one(
            {'_id': ObjectId(post_id)},
            {'$inc': {'like': -1}}
        )

        return jsonify({"Status":"Success"}), 200

    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"error": "something went wrong"}), 500