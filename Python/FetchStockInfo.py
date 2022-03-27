import json
from datetime import datetime
from BusinessLogicLayer.StockInfo import StockInfo
from Model.JsonHelper import JsonHelper

class FetchStockInfo:
    today = datetime.today()
    StockInfo.FetchAll(today.year, today.month)
    print("End")
#end class