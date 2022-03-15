import json

# from FolderName.FileName import ClassName
from datetime import datetime
from Model.JsonHelper import JsonHelper
from Model.MSSQLHelper import MSSQLHelper

class Holiday():
    def __Cast(list):
        result = []

        for collection in list:
            temp = JsonHelper()
            temp.Date = datetime.strftime(collection[0], "%Y%m%d")
            temp.Description = collection[1]

            result.append(json.loads(temp.toJSON()))
        #end loop

        return result
    #end def

    def SelectAll():
        command = "SELECT * FROM Holiday WITH(NOLOCK);"

        result = Holiday.__Cast(MSSQLHelper.ExecSQLs(command))
        return result
    #end def

    def SelectByTime(object):
        command = "SELECT * FROM Holiday WITH(NOLOCK) WHERE [Date] BETWEEN '" + object.BeginTime + "' AND '" + object.EndTime + "';"

        result = Holiday.__Cast(MSSQLHelper.ExecSQLs(command))
        return result
    #end def

    def Insert(object):
        command = "INSERT INTO Holiday ([Date], [Description]) VALUES "

        for row in object:
            command += "('" + row["Date"] + "', '" + row["Description"] + "'), "
        #end loop

        command = command[:-2] #slice the last ", "
        command += ";"

        result = MSSQLHelper.ExecSQLsWithAffectedRows(command)
        return result
    #end def

    def Delete(object):
        command = "DELETE FROM Holiday WHERE [Date] = '" + object.Key + "';"
        result = MSSQLHelper.ExecSQLsWithAffectedRows(command)
        return result
    #end def

#end class