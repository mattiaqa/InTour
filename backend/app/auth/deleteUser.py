from app.auth import bp 
from flask import jsonify, request, current_app
from app.extension import mongo
from flask_jwt_extended import *
import shutil
import os 

@bp.route('/delete', methods=['POST'])
@jwt_required()
def delete_user():
    try:
        username = get_jwt_identity()['username']

        result = mongo['users'].update_many(
            {'friends':username},
            {'$pull':{'friends':username}}
        )
        query = {"_id" : username}
        result = mongo['users'].delete_one(query)

        result = mongo['posts'].update_many(
            {"comments.user" : username},
            {
                "$pull" : {
                    "comments" : {"user" : username},
                    "like" : username
                }
            }
        )

        query = {"creator" : username}
        result = mongo['posts'].delete_many(query)

        if result:
            upload_folder = f'/src/backend/static/uploads/{username}'
            if os.path.exists(upload_folder):
                shutil.rmtree(upload_folder)
                return jsonify({"Status":"Success"}), 200
            
        return jsonify({"Error":"Username not found"}), 404
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"Error":"Internal Server Error"}), 500

