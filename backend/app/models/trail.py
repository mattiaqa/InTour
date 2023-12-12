class Trail:
    def __init__(self, trail):
        self.category = trail[0]
        self.title = trail[2]
        self.summary = trail[3]
        self.description = trail[4]
        self.tips = trail[5]
        self.security = trail[6]
        self.startpoint = trail[9]
        self.endpoint = trail[10]

    def to_dict(self):
        return {
            "category" : self.category,
            "title" : self.title,
            "summary" : self.summary,
            "description" : self.description,
            "tips" : self.tips,
            "security" : self.security,
            "startpoint" : self.startpoint,
            "endpoint" : self.endpoint
        }