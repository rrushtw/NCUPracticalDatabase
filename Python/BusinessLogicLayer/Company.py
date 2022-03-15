import json

# from FolderName.FileName import ClassName
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.service import Service
from bs4 import BeautifulSoup
from Model.JsonHelper import JsonHelper
from DataAccessLayer.Company import Company as DAL

class Company:
    def FetchCompanies():
        result = []
        url = "https://www.cmoney.tw/etf/e210.aspx?key=0050"

        options = Options()
        options.add_argument("--headless")  # 執行時不顯示瀏覽器
        options.add_argument("--disable-notifications")  # 禁止瀏覽器的彈跳通知
        chrome = webdriver.Chrome(service=Service('./chromedriver'), options=options)

        chrome.get(url)
        try:
            # 等元件跑完再接下來的動作，避免讀取不到內容
            WebDriverWait(chrome, 10).until(EC.presence_of_element_located((By.CSS_SELECTOR, 'table[class="tb tb1"] tr')))
            companyList = chrome.find_elements(By.CSS_SELECTOR, 'table[class="tb tb1"] tr')
            for company in companyList:
                soup = BeautifulSoup(company.get_attribute('innerHTML'), "html.parser")

                if not soup.find("td", {"key":"CommKey"}):
                    continue

                if soup.find("td", {"key":"Type"}).text.strip() != "股票":
                    continue

                temp = JsonHelper()
                temp.CompanyId = soup.find("td", {"key":"CommKey"}).text.strip()
                temp.CompanyName = soup.find("td", {"key":"CommName"}).text.strip()
                
                result.append(json.loads(temp.toJSON()))
                #end loop
            #end try
        except Exception as e:
            print("Exception:")
            print(e)
            print("End Exception")
            #end exception

        chrome.close()
        return result
        #end def
    
    def Insert(companyList):
        if not isinstance(companyList, list):
            raise Exception("Invalid input")
            #end if
            
        return DAL.Insert(companyList)
        #end def

    def GetAll():
        return DAL.GetAll()
    #end def
#end class