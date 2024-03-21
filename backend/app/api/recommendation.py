from app.api import bp 
from flask import jsonify, current_app
from flask_jwt_extended import *
import pandas as pd
from surprise import Dataset, Reader, KNNWithMeans

@bp.route('/recommend/trails', methods=['GET'])
@jwt_required()
def recommends_trails():
    try:
        user = get_jwt_identity()['username']

        reader = Reader(rating_scale=(1, 5))
        
        ratings = Dataset.load_from_file("custom_rating.csv", reader=reader)

        sim_options = {
            "name": "cosine",
            "user_based": False,  # Compute  similarities between items
        }

    except Exception as e:
        current_app.logger.error("Internal Server Error: %s", e)
        return jsonify({"error": "something went wrong"}), 500