import json
from datetime import datetime
from BusinessLogicLayer.StockInfo import StockInfo
from Model.JsonHelper import JsonHelper

class FetchStockInfo:
    for i in range(3):
        StockInfo.FetchAll(2022, i + 1)
    #end loop
    print("End")
#end class