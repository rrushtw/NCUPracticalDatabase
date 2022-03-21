#import datetime
import requests
import json

# from FolderName.FileName import ClassName
from bs4 import BeautifulSoup
from DataAccessLayer.Holiday import Holiday as DAL
from Model.JsonHelper import JsonHelper

class Holiday:
    def FetchHolidays():
        url = "https://www.wantgoo.com/global/all-holiday-data"
        header = {
            "authority": 'www.wantgoo.com',
            "method": 'GET',
            "path": '/global/all-holiday-data',
            "scheme": 'https',
            "accept": 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
            "accept-encoding": 'gzip, deflate, br',
            "accept-language": 'zh-TW,zh;q=0.9,en-US;q=0.8,en;q=0.7',
            "cache-control": 'max-age=0',
            "cookie": 'BID=EA4F9957-F6BA-439B-B573-A3E599F6FF76; _gid=GA1.2.1112611253.1647224561; _gcl_au=1.1.1617443520.1647224561; hblid=ecqJbFFcY3R69sNQ3h7B70H4bMjFkjaA; _okdetect=%7B%22token%22%3A%2216472245617470%22%2C%22proto%22%3A%22about%3A%22%2C%22host%22%3A%22%22%7D; olfsk=olfsk9637174370893766; _ok=8391-691-10-7433; popup=showed; _hjSessionUser_827061=eyJpZCI6ImIzYmQ0MTFkLTE2ZWQtNTA3Ni05NGMwLTU0NTExYTZkZmU4YiIsImNyZWF0ZWQiOjE2NDcyMjQ1NjI2MDYsImV4aXN0aW5nIjp0cnVlfQ==; client_fingerprint=fb9df48d8618a914b0cee8a6caa346207ce6d86c84805b62a009412194935a61; wcsid=A8LKaju1IlAi5udQ3h7B70HoaMa4bjbj; _okbk=cd4%3Dtrue%2Cvi5%3D0%2Cvi4%3D1647246705446%2Cvi3%3Dactive%2Cvi2%3Dfalse%2Cvi1%3Dfalse%2Ccd8%3Dchat%2Ccd6%3D0%2Ccd5%3Daway%2Ccd3%3Dfalse%2Ccd2%3D0%2Ccd1%3D0%2C; _hjSession_827061=eyJpZCI6IjRmODQ5YmViLTZiNTAtNDViNC05MGJmLTg2MDc5OGUzMDA5MyIsImNyZWF0ZWQiOjE2NDcyNDY3MDYzMTMsImluU2FtcGxlIjpmYWxzZX0=; _hjAbsoluteSessionInProgress=0; _ga=GA1.2.148288380.1647224561; _ga_FCVGHSWXEQ=GS1.1.1647246703.2.1.1647246876.0; _oklv=1647248709537%2CA8LKaju1IlAi5udQ3h7B70HoaMa4bjbj',
            "sec-ch-ua": '" Not A;Brand";v="99", "Chromium";v="99", "Google Chrome";v="99"',
            "sec-ch-ua-mobile": '?0',
            "sec-ch-ua-platform": '"Windows"',
            "sec-fetch-dest": 'document',
            "sec-fetch-mode": 'navigate',
            "sec-fetch-site": 'none',
            "sec-fetch-user": '?1',
            "upgrade-insecure-requests": '1',
            "user-agent": 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.51 Safari/537.36'
        }

        response = requests.get(url, headers = header)
        soup = BeautifulSoup(response.content, "html.parser")

        result = []

        for collection in json.loads(soup.text):
            if collection["countryCode"] == "TWSE":
                holiday = JsonHelper()
                holiday.Date = collection["date"]
                holiday.Description = collection["content"]

                result.append(holiday.toJSON())
                pass
            else:
                pass
            #end if
        #end loop

        #print(json.dumps(result, ensure_ascii = False))
        return result
    #end def
    
    def Insert(holidayList):
        if not isinstance(holidayList, list):
            raise Exception("Invalid input")
        #end if

        return DAL.Insert(holidayList)
    #end def

    def GetAll():
        return DAL.SelectAll()
    #end def
#end class