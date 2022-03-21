import json
import requests

from bs4 import BeautifulSoup
from datetime import datetime
from fake_useragent import UserAgent
# from FolderName.FileName import ClassName
from Model.JsonHelper import JsonHelper
from Model.MSSQLHelper import MSSQLHelper

class StockInfo():
    def __Cast(list):
        result = []

        for collection in list:
            stockInfo = JsonHelper()
            stockInfo.CompanyId = collection[0]
            stockInfo.Date = datetime.strftime(collection[1], "%Y%m%d")
            stockInfo.TradeVolume = collection[2]
            stockInfo.TradePrice = collection[3]
            stockInfo.OpenPrice = collection[4]
            stockInfo.HighestPrice = collection[5]
            stockInfo.LowestPrice = collection[6]
            stockInfo.ClosePrice = collection[7]
            stockInfo.Change = collection[8]
            stockInfo.TradeCount = collection[9]

            try:
                stockInfo.MA05 = collection[10]
            except IndexError:
                stockInfo.MA05 = None

            try:
                stockInfo.MA10 = collection[11]
            except IndexError:
                stockInfo.MA10 = None

            try:
                stockInfo.MA20 = collection[12]
            except IndexError:
                stockInfo.MA20 = None

            try:
                stockInfo.MA60 = collection[13]
            except IndexError:
                stockInfo.MA60 = None
            
            try:
                stockInfo.MA120 = collection[14]
            except IndexError:
                stockInfo.MA120 = None

            try:
                stockInfo.MA240 = collection[15]
            except IndexError:
                stockInfo.MA240 = None

            result.append(json.loads(stockInfo.toJSON()))
        #end loop

        return result
    #end def

    def __CastWithCompanyId(list, companyId):
        result = []

        for collection in list:
            stockInfo = JsonHelper()
            stockInfo.CompanyId = companyId

            timeElement = collection[0].split('/')
            stockInfo.Date = str(int(timeElement[0]) + 1911) + str(timeElement[1]) + str(timeElement[2])

            stockInfo.TradeVolume = collection[1].replace(",", "")
            stockInfo.TradePrice = collection[2].replace(",", "")
            stockInfo.OpenPrice = collection[3].replace(",", "")
            stockInfo.HighestPrice = collection[4].replace(",", "")
            stockInfo.LowestPrice = collection[5].replace(",", "")
            stockInfo.ClosePrice = collection[6].replace(",", "")
            stockInfo.Change = collection[7].replace(",", "").replace("X", "")
            stockInfo.TradeCount = collection[8].replace(",", "")

            result.append(json.loads(stockInfo.toJSON()))
        #end loop

        return result
    #end def

    def FetchStockInfo(companyId, date):
        userAgent = UserAgent()
        url = "https://www.twse.com.tw/exchangeReport/STOCK_DAY?response=json&date=" + datetime.strftime(date, "%Y%m%d") + "&stockNo=" + companyId
        header = {
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
            'Accept-Encoding': 'gzip, deflate, br',
            'Accept-Language': 'zh-TW,zh;q=0.9,en-US;q=0.8,en;q=0.7',
            'Cache-Control': 'max-age=0',
            'Connection': 'keep-alive',
            #'Cookie': '_gid=GA1.3.661867192.1647175107; _ga=GA1.3.1220449453.1647175107; _ga_F4L5BYPQDJ=GS1.1.1647181924.2.0.1647181924.0; JSESSIONID=8C5A106FC65EB5B0A13E96811CEE102D',
            'Host': 'www.twse.com.tw',
            #'sec-ch-ua': '" Not A;Brand";v="99", "Chromium";v="99", "Google Chrome";v="99"',
            'sec-ch-ua-mobile': '?0',
            'sec-ch-ua-platform': '"Windows"',
            'Sec-Fetch-Dest': 'document',
            'Sec-Fetch-Mode': 'navigate',
            'Sec-Fetch-Site': 'none',
            'Sec-Fetch-User': '?1',
            'Upgrade-Insecure-Requests': '1',
            'User-Agent': userAgent.random
        }

        response = requests.get(url, headers = header)
        soup = BeautifulSoup(response.content, "html.parser")

        result = StockInfo.__CastWithCompanyId(json.loads(soup.text)["data"], companyId)
        return result
    #end def

    def GetStockByTime(beginTime, endTime):
        command = "SELECT * FROM StockInfo WITH(NOLOCK) WHERE [Date] BETWEEN '" + datetime.strftime(beginTime, "%Y%m%d") + "' AND '" + datetime.strftime(endTime, "%Y%m%d") + "';"
        result = StockInfo.__Cast(MSSQLHelper.ExecSQLs(command))
        return result
    #end def

    def GetStockByTimeAndId(companyId, beginTime, endTime):
        command = "SELECT * FROM StockInfo WITH(NOLOCK) "
        command += "WHERE CompanyId = '" + companyId + "' AND [Date] BETWEEN '" + datetime.strftime(beginTime, "%Y%m%d") + "' AND '" + datetime.strftime(endTime, "%Y%m%d") + "';"

        result = StockInfo.__Cast(MSSQLHelper.ExecSQLs(command))
        return result
    #end def

    def Insert(object):
        command = "INSERT INTO StockInfo ("
        command += "CompanyId, "
        command += "[Date], "
        command += "TradeVolume, "
        command += "TradePrice, "
        command += "OpenPrice, "
        command += "HighestPrice, "
        command += "LowestPrice, "
        command += "ClosePrice, "
        command += "Change, "
        command += "TradeCount) VALUES "

        for row in object:
            command += "('" 
            command += row["CompanyId"] + "', '" 
            command += row["Date"] + "', '" 
            command += row["TradeVolume"] + "', '" 
            command += row["TradePrice"] + "', '" 
            command += row["OpenPrice"] + "', '" 
            command += row["HighestPrice"] + "', '" 
            command += row["LowestPrice"] + "', '" 
            command += row["ClosePrice"] + "', '" 
            command += row["Change"] + "', '" 
            command += row["TradeCount"] +  "'), "
            #end for

        command = command[:-2] #slice the last ", "
        command += ";"

        result = MSSQLHelper.ExecSQLsWithAffectedRows(command)
        return result
    #end def

#end class