from app.api import bp 
from flask import jsonify, current_app
from flask_jwt_extended import *
from app.extension import mongo

@bp.route('/user', methods=['GET'])
@jwt_required()
def get_user_data():
    user = get_jwt_identity()['username']

    user_data = mongo['users'].find_one({'_id': user}, {'password': 0})

    if user_data:
        return jsonify(user_data), 200
    else:
        return jsonify({'message': 'User not found'}), 404

@bp.route('/user/post', methods=['GET'])
@jwt_required()
def get_user_post():
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