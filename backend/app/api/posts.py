import random
import string
import os 

from app.api import bp 
from flask import jsonify, request
from flask_jwt_extended import *
from app.extension import mongo

@bp.route('/post/upload', methods=['POST'])
@jwt_required()
def upload_posts():
    if 'file' not in request.files:
        return jsonify({'error': 'No file found'})

    uploaded_file = request.files['file']
    if uploaded_file.filename == '':
        return jsonify({'error': 'Nome del file vuoto'})

    user = get_jwt_identity()['username']
    descrizione = request.form.get('descrizione')

    name = ''.join(random.choices(string.ascii_letters + string.digits, k=10)) + '.jpg'

    upload_folder = f'uploads/{user}'
    if not os.path.exists(upload_folder):
        os.makedirs(upload_folder)
    
    upload_url = f'{upload_folder}/{name}'
    uploaded_file.save(upload_url)

    try:
        new_post = {
            "creator" : user,
            "img_url" : upload_url,
            "description" : descrizione,
            "like" : 0,
            "commenti" : []
        }

        mongo["posts"].insert_one(new_post)
    except:
        return 'Error', 500

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