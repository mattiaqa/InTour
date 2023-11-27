from app.auth import bp 
from flask import jsonify, request
from app.extension import mongo
from flask_jwt_extended import *

@bp.route('/delete', methods=['POST'])
@jwt_required()
def deleteUser():
    username = request.json['username']

    if not username:
        return jsonify({"Status": 401, "Reason":"Missing parameters!"})

    query = {"_id" : username}
    result = mongo['users'].delete_one(query)

    if result:
        return 'Done', 200

    return "Something went wrong", 403
