from app.api import bp 

@bp.route('/hello', methods=['GET'])
def test():
    return '<h1>Work</h1>'