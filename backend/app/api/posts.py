import random
import string
import os 
from datetime import datetime
from bson import json_util
import json

from app.api import bp 
from flask import jsonify, request, current_app
from flask_jwt_extended import *
from app.extension import mongo
from app.utils import get_all_friends

@bp.route('/post/upload', methods=['POST'])
@jwt_required()
def upload_posts():
    try:
        if 'file' not in request.files:
            return jsonify({'error': 'No file found'}), 500

        uploaded_file = request.files['file']
        if uploaded_file.filename == '':
            return jsonify({'error': 'Void name file'})

        user = get_jwt_identity()['username']
        description = request.form.get('description')

        name = ''.join(random.choices(string.ascii_letters + string.digits, k=10)) + '.jpg'

        upload_folder = f'uploads/{user}'
        if not os.path.exists(upload_folder):
            os.makedirs(upload_folder)
        
        upload_url = f'{upload_folder}/{name}'
        uploaded_file.save(upload_url)
        current_date = datetime.now().date()

        new_post = {
            "creator" : user,
            "img_url" : upload_url,
            "description" : description,
            "date" : str(current_date), 
            "like" : 0,
            "comments" : []
        }

        mongo["posts"].insert_one(new_post)
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"Error": "Internal Server Error"}), 500

    return 'Done', 200

@bp.route('/post/delete', methods=['POST'])
@jwt_required()
def delete_posts():
    post_url = request.json['post_url']
    user = get_jwt_identity()['username']
    
    try:
        query = {"img_url" : post_url}
        mongo["posts"].delete_one(query)
        os.remove(post_url)
    except:
        return jsonify({"error": "something went wrong"})

    return 'Done', 200

@bp.route('/post', methods=['GET'])
@jwt_required()
def fetch_friend_posts():
    user = get_jwt_identity()['username']

    try:
        friends_list = get_all_friends(user)
        result = []
        #TODO: aggiungere il limite sul numero di post dinamico
        for friend in friends_list:
            friend_posts = mongo['posts'].find({'creator' : friend}).limit(10).sort('date')

            for post in friend_posts:
                post['_id'] = str(post['_id'])
                result.append(post)
            
        return jsonify(result), 200

    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"error": "something went wrong"}), 500