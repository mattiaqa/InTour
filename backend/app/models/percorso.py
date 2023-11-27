class Percorso:
    def __init__(self, percorso):
        self.categoria = percorso[0]
        self.titolo = percorso[2]
        self.sintesi = percorso[3]
        self.descrizione = percorso[4]
        self.consigli = percorso[5]
        self.sicurezza = percorso[6]
        self.partenza = percorso[9]
        self.arrivo = percorso[10]

    def to_dict(self):
        return {
            "categoria" : self.categoria,
            "titolo" : self.titolo,
            "sintesi" : self.sintesi,
            "descrizione" : self.descrizione,
            "consigli" : self.consigli,
            "sicurezza" : self.sicurezza,
            "partenza" : self.partenza,
            "arrivo" : self.arrivo
        }