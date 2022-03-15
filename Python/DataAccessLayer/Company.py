import json

# from FolderName.FileName import ClassName
from datetime import datetime
from Model.JsonHelper import JsonHelper
from Model.MSSQLHelper import MSSQLHelper

class Company():
    def __Cast(list):
        result = []

        for collection in list:
            temp = JsonHelper()
            temp.CompanyId = collection[0]
            temp.CompanyName = collection[1]
            temp.IndustryType = collection[2]
            temp.Remark = collection[3]

            result.append(json.loads(temp.toJSON()))
        #end loop

        return result
    #end dif

    def GetAll():
        command = "SELECT * FROM Company WITH(NOLOCK);"
        result = Company.__Cast(MSSQLHelper.ExecSQLs(command))
        return result
        #end def
    
    def GetSingleById(companyId):
        command = "SELECT * FROM Company WITH(NOLOCK) WHERE companyId = '" + companyId + "';"
        result = Company.__Cast(MSSQLHelper.ExecSQLs(command))
        return result
        return result
        #end def

    def Insert(object):
        command = "INSERT INTO Company (CompanyId, CompanyName, IndustryType, Remark) VALUES "

        for row in object:
            if "IndustryType" in row and "Remark" in row:
                command += "('" + row["CompanyId"] + "', '" + row["CompanyName"] +  "', '" + row["IndustryType"] + "', '" + row["Reamrk"] + "'), "
            elif "IndustryType" in row and "Remark" not in row:
                command += "('" + row["CompanyId"] + "', '" + row["CompanyName"] +  "', '" + row["IndustryType"] + "', NULL), "
            elif "IndustryType" not in row and "Remark" in row:
                command += "('" + row["CompanyId"] + "', '" + row["CompanyName"] +  "', NULL, '" + row["Remark"] + "'), "
            else:
                command += "('" + row["CompanyId"] + "', '" + row["CompanyName"] +  "', NULL, NULL), "
                #end if
            #end for

        command = command[:-2] #slice the last ", "
        command += ";"

        result = MSSQLHelper.ExecSQLsWithAffectedRows(command)
        return result
        #end def

    def Delete(companyId):
        command = "DELETE FROM Company WHERE CompanyId = '" + companyId + "';"
        result = MSSQLHelper.ExecSQLsWithAffectedRows(command)
        return result
        #end def

    #end class