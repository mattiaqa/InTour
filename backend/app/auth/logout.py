from app.auth import bp 
from app.extension import token_blacklist
from flask_jwt_extended import jwt_required, get_jwt
from flask import current_app, jsonify

@bp.route('/logout', methods=['POST'])
@jwt_required()
def logout():
    try:
        jti = get_jwt()['jti']
        token_blacklist.append(jti)
        return jsonify({"Status":"Logged out"}), 200
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"Error":"Internal Server Error"}), 500