from app.api import bp 
from flask import jsonify
from flask_jwt_extended import *
from app.extension import percorsi

@bp.route('/percorsi', methods=['GET'])
@jwt_required()
def get_all_path():
    percorsi_dict = [item.to_dict() for item in percorsi]
    return jsonify(percorsi_dict)