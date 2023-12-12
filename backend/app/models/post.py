class Post:
    def __init__(self, post):
        self.id = post[0]
        self.creator = post[1]
        self.img_url = post[2]
        self.description = post[3]
        self.date = post[4]
        self.like = post[5]
        self.comments = post[6]

    def to_dict(self):
        return {
            "category" : self.categoria,
            "title" : self.titolo,
            "summary" : self.sintesi,
            "description" : self.descrizione,
            "tips" : self.consigli,
            "security" : self.sicurezza,
            "startpoint" : self.partenza,
            "endpoint" : self.arrivo
        }