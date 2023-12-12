from flask import Flask
from config import Config 
from flask_jwt_extended import JWTManager
from app.utils import init_trails
import logging 

def create_app(config_class=Config):
    app = Flask(__name__)
    app.config.from_object(config_class)

    from app.api import bp as api_bp
    app.register_blueprint(api_bp, url_prefix='/api')

    from app.auth import bp as auth_bp
    app.register_blueprint(auth_bp, url_prefix='/auth')

    jwt = JWTManager(app)

    init_trails()
    
    handler = logging.FileHandler(filename='log.log')
    formatter = logging.Formatter("%(asctime)s;%(levelname)s;%(message)s",
                              "%Y-%m-%d %H:%M:%S")
    handler.setFormatter(formatter)
    app.logger.addHandler(handler)

    return app
    