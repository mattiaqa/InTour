class Trail:
    def __init__(self, trail, trail_id):
        self.trail_id = trail_id
        self.category = trail.iloc[0]
        self.imageName = trail.iloc[1]
        self.title = trail.iloc[2]
        self.summary = trail.iloc[3]
        self.description = trail.iloc[4]
        self.tips = trail.iloc[5]
        self.length = trail.iloc[6]
        self.security = trail.iloc[7]
        self.equipment = trail.iloc[8]
        self.references = trail.iloc[9]
        self.startpoint = trail.iloc[10]
        self.endpoint = trail.iloc[11]
        self.climb = trail.iloc[25]
        self.descent = trail.iloc[26]
        self.difficulty = trail.iloc[27]
        self.duration = trail.iloc[28]
        self.x = trail.iloc[29]
        self.y = trail.iloc[30]

    def to_dict(self):
        return {
            "trail_id" : self.trail_id,
            "category" : self.category,
            "imageName" : self.imageName,
            "title" : self.title,
            "summary" : self.summary,
            "description" : self.description,
            "tips" : self.tips,
            "length" : self.length,
            "security" : self.security,
            "equipment" : self.equipment,
            "references" : self.references,
            "startpoint" : self.startpoint,
            "endpoint" : self.endpoint,
            "climb" : self.climb,
            "descent" : self.descent,
            "difficulty" : self.difficulty,
            "duration" : self.duration,
            "x" : self.x,
            "y" : self.y
        }