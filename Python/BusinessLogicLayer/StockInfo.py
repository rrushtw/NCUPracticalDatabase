import json

from datetime import datetime
from dateutil.relativedelta import relativedelta
from time import sleep
from DataAccessLayer.Company import Company as ICompany
from DataAccessLayer.StockInfo import StockInfo as IStock

class StockInfo:
    def FetchAll(year, month):
        datetimeNow = datetime.now()
        todayString = datetime.strftime(datetimeNow, "%Y%m%d")
        targetMonth = datetime.strptime(str(year) + '-' + str(month) + '-01', "%Y-%m-%d")

        beginDate = targetMonth
        endDate = targetMonth + relativedelta(months = 1) + relativedelta(days = -1)
        for company in ICompany.GetAll():
            try:
                fetchData = IStock.FetchStockInfo(company["CompanyId"], targetMonth)
            except Exception as ex:
                print(ex)
                continue

            localData = IStock.GetStockByTimeAndId(company["CompanyId"], beginDate, endDate)

            targetList = []
            isExist = False
            for f in fetchData:
                if f["Date"] == todayString and datetimeNow.hour < 14:
                    continue
                #end if

                for l in localData:
                    if f["Date"] == l["Date"]:
                        isExist = True
                        break #end checking in inner loop
                    #end if
                #end loop 

                if not isExist:
                    targetList.append(f)
                else:
                    isExist = False #reset flag
                #end if
            #end loop
            
            if len(targetList) > 0:
                affectedRows = IStock.Insert(targetList)
                print("AffectedRows: " + str(affectedRows) + " in CompanyId: " + company["CompanyId"])
            else:
                print("Skip CompanyId: " + company["CompanyId"])
            #end if

            sleep(5)
        #end loop
    #end def
#end class