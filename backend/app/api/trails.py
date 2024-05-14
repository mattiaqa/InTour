from app.api import bp 
from flask import jsonify, current_app, request
from flask_jwt_extended import *
from app.extension import trails
from app.extension import mongo
import pandas as pd 

@bp.route('/trails', methods=['GET'])
@jwt_required()
def get_all_path():
    """
        Retrive from server the list of all available trails.

        Returns:
        - If successful, returns a JSON list with all data requested 
          and an HTTP status code of 200.
        - If any exceptions occur during the process, 
          logs an internal server error and returns a JSON response with 
          an error message ({'Error': 'Internal Server Error'}) 
          and an HTTP status code of 500.
    """
    try:
        # convert each trail object in dictionary, so it can be returned as json
        trails_dict = [item.to_dict() for item in trails]
        return jsonify(trails_dict), 200
    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"Error": "Internal Server Error"}), 500
    