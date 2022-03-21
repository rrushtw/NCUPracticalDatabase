import pymssql

class MSSQLHelper:
    def ExecProc(procedureName, parameterList):
        result = []

        try:
            # having connection
            connection = pymssql.connect(server="127.0.0.1", user="test", password="test", database="PracticalDatabase", port="1433", charset="utf8")
            cursor = connection.cursor()

            command = "EXEC " + procedureName

            # Append parameters
            if (parameterList == None or len(parameterList) == 0):
                pass
            else:
                isFirst = True

                for parameter in parameterList:
                    if isFirst:
                        command += " '" + parameter + "'"
                        isFirst = False
                        pass
                    else:
                        command += ", '" + parameter + "'"
                        pass
                    #end loop
                #end if else

            # Execute command and store result in cursor
            cursor.execute(command)

            # load data to result
            row = cursor.fetchone()
            while row:
                result.append(row)
                row = cursor.fetchone()
                #end loop

            connection.commit()  #end execute
            connection.close()  #end connection
            #end try
        except Exception as ex:
            print("Exception happened.")
            print(ex.args[0])
            #end exception

        return result
        #end def

    def ExecSQLs(SQLCommand):
        result = []

        try:
            # having connection
            connection = pymssql.connect(server="127.0.0.1", user="test", password="test", database="PracticalDatabase", port="1433", charset="utf8")
            cursor = connection.cursor()

            # Execute command and store result in cursor
            cursor.execute(SQLCommand)

            # load data to result
            for row in cursor:
                result.append(row)
            #end loop

            connection.commit()  #end execute
            connection.close()  #end connection
            #end try
        except Exception as ex:
            print("Exception happened.")
            print(ex.args[0])
            #end exception

        return result
        #end def
    
    def ExecSQLsWithAffectedRows(SQLCommand):
        rowCount = 0

        try:
            # having connection
            connection = pymssql.connect(server="127.0.0.1", user="test", password="test", database="PracticalDatabase", port="1433", charset="utf8")
            cursor = connection.cursor()

            # Execute command and store result in cursor
            cursor.execute(SQLCommand)

            rowCount = cursor.rowcount

            connection.commit()  #end execute
            connection.close()  #end connection
            #end try
        except Exception as ex:
            print("Exception happened:")
            print(ex)
            print("End Exception")
            #end exception

        return rowCount
        #end def
    #end class
