import json

from BusinessLogicLayer.Holiday import Holiday

class FetchHolidays:
    holidayList = Holiday.FetchHolidays()
    affectedRows = Holiday.Insert(holidayList)
    print("AffectedRows: " + str(affectedRows))
    #end class