from app.api import bp 
from flask import jsonify
from flask_jwt_extended import *
from app.extension import trails

@bp.route('/trails', methods=['GET'])
@jwt_required()
def get_all_path():
    trails_dict = [item.to_dict() for item in trails]
    return jsonify(trails_dict), 200