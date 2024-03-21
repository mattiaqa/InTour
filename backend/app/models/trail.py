class Trail:
    def __init__(self, trail, trail_id):
        self.trail_id = trail_id
        self.category = trail.iloc[0]
        self.title = trail.iloc[2]
        self.summary = trail.iloc[3]
        self.description = trail.iloc[4]
        self.tips = trail.iloc[5]
        self.security = trail.iloc[6]
        self.startpoint = trail.iloc[9]
        self.endpoint = trail.iloc[10]

    def to_dict(self):
        return {
            "trail_id" : self.trail_id,
            "category" : self.category,
            "title" : self.title,
            "summary" : self.summary,
            "description" : self.description,
            "tips" : self.tips,
            "security" : self.security,
            "startpoint" : self.startpoint,
            "endpoint" : self.endpoint
        }