import json

# from FolderName.FileName import ClassName
from Model.HolidayModel import HolidayModel
from Model.MSSQLHelper import MSSQLHelper

class Holiday_DAL():
    def SelectAll():
        command = "SELECT * FROM Holiday WITH(NOLOCK);"
        result = MSSQLHelper.ExecSQLs(command)
        return result
        #end def

    def SelectByTime(object):
        command = "SELECT * FROM Holiday WITH(NOLOCK) WHERE [Date] BETWEEN '" + object.BeginTime + "' AND '" + object.EndTime + "';"
        result = MSSQLHelper.ExecSQLs(command)
        return result
        #end def

    def Insert(object):
        command = "INSERT INTO Holiday ([Date], [Description]) VALUES "

        for row in object:
            command += "('" + row["Date"] + "', '" + row["Description"] + "'), "
            #end for

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