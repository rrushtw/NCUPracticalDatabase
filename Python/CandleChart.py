import mplfinance as mpf
import pandas as pd

from datetime import datetime
from DataAccessLayer.StockInfo import StockInfo

class main:
    beginDate = datetime.strptime('20220101', '%Y%m%d')
    endDate = datetime.strptime('20220201', '%Y%m%d')

    result = StockInfo.GetStockByTimeAndId('2330', beginDate, endDate);

    arr = []
    for r in result:
        tempList = []
        tempList.append(r['Date'])
        tempList.append(float(r['OpenPrice']))
        tempList.append(float(r['HighestPrice']))
        tempList.append(float(r['LowestPrice']))
        tempList.append(float(r['ClosePrice']))
        tempList.append(float(r['TradeVolume']))

        arr.append(tempList)
    #end loop
    arr_df = pd.DataFrame(arr)
    print(arr_df)
    arr_df.index = pd.to_datetime(arr_df[0], format='%Y%m%d')
    arr_df = arr_df.drop(columns=[0])
    arr_df.columns = ['Open', 'High', 'Low', 'Close', 'Volume']
    arr_df.index.name = "Date"
    arr_df
    mpf.plot(arr_df, type='candle', style='charles')

    #end main