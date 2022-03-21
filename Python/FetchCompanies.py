import json

from BusinessLogicLayer.Company import Company

class FetchCompanies:
    companyList = Company.FetchCompanies()
    affectedRows = Company.Insert(companyList)
    print("AffectedRows: " + str(affectedRows))
    #end class