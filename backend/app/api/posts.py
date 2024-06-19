import os 
from datetime import datetime
from app.api import bp 
from flask import jsonify, request, current_app, send_file
from flask_jwt_extended import *
from app.extension import mongo
from app.utils import get_all_friends, isFriendOf
from bson import ObjectId

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

        # check if filename is void
        uploaded_file = request.files['file']
        if uploaded_file.filename == '':
            return jsonify({'error': 'Void filename'}), 400

        # check extension
        #if not allowed_file(uploaded_file.):
        #    return jsonify({'error': 'Invalid file type. Only .png and .jpg allowed'}), 400

        user = get_jwt_identity()['username']
        description = request.form.get('description')

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

        # calculate the current date
        current_date = datetime.now().date()

        img_url = f'/uploads/{user}/{object_id}'

        new_post = {
            "_id" : object_id,
            "creator" : user,
            "img_url" : img_url,
            "description" : description,
            "date" : str(current_date), 
            "like" : [],
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
            os.remove(f"/src/backend/static/uploads/{user}/{post_id}")
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
            friend_posts = mongo['posts'].find({'creator' : friend})

            for post in friend_posts:
                post['_id'] = str(post['_id'])
                result.append(post)
        
        result.sort(key=lambda x: x['date'])

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
            '_id' : str(ObjectId()),
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


@bp.route('/post/comment/delete', methods=['POST'])
@jwt_required()
def remove_comment_post():
    """
        Remove a comment's post

        Parameters:
        - post_id: id of the post.
        - comment: text of the comment to be removed

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
        comment_id = request.json['_id']

        if not post_id or not comment_id:
            return jsonify({"Error":"Missing Parameters"}), 400
        
        post = mongo['posts'].find_one({'_id' : ObjectId(post_id)})

        if not post:
            return jsonify({"Error":"Post not found"}), 404
        
        comments = post.get('comments', [])

        index_to_delete = None
        for i, comment in enumerate(comments):
            if comment.get('user') == user['username'] and comment.get('_id') == comment_id:
                index_to_delete = i
                break

        if index_to_delete is not None:
            del comments[index_to_delete]
            mongo['posts'].update_one({'_id': ObjectId(post_id)}, {'$set': {'comments': comments}})

            return jsonify({"Status":"Success"}), 200

        return jsonify({"Error":"Comment not found"}), 404
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
            {'$push': {'like': user['username']}}
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
            {'$pull': {'like': user['username']}}
        )

        return jsonify({"Status":"Success"}), 200

    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"error": "something went wrong"}), 500
    

@bp.route('/uploads/<username>/<filename>')
#@jwt_required()
def get_post_image(username, filename):
    """
        Give access to user's uploads

        Returns:
        - If successful, returns the file desired with a status of success
          and an HTTP status code of 200.
        - If the user does not have access to the resource, return an HTTP status code of 403.
        - If any exceptions occur during the process, 
          logs an internal server error and returns a JSON response with 
          an error message ({'Error': 'Internal Server Error'}) 
          and an HTTP status code of 500.
    """
    try:
        #user = get_jwt_identity()['username']

        #if(not isFriendOf(username, user)):
        #    return jsonify({"Error":"Unauthorized"}), 403

        # prevent path traversal
        path = f'/src/backend/static/uploads/{username}/{filename}'
        #sanitezed_path = os.path.normpath(path)

        return send_file(path, mimetype='image/jpeg'), 200
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"error": "something went wrong"}), 500