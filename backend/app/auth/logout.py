from app.auth import bp 
from app.extension import token_blacklist
from flask_jwt_extended import jwt_required, get_jwt

@bp.route('/logout', methods=['POST'])
@jwt_required()
def logout():
    try:
        jti = get_jwt()['jti']
        token_blacklist.append(jti)
        return "Logged out", 200
    except:
        return "Error", 500