import json

class JsonHelper:
    def toJSON(self):
        return json.dumps(self, default=lambda o: o.__dict__, sort_keys=True, ensure_ascii = False)
        #end def
    #end class