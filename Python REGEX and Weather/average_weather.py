""" This script gets the UTM Geology data given a certain start and
end date specified in the arguments, and depending on those arguments
can display or print to file the average temperature, humidity or
precipitation."""

""" Note to the unfortunate marker with this file: I am unfortunately
aware and have experienced the long execution time on this file. However,
when I made a bunch of print statements to track the variables, they
went as slow as the load time would suggest. Any feedback to this 
regard is greatly appreciated! Please wait for the file to 
completely execute as I experienced a maximum wait time of 2 minutes"""

import sys, getopt, datetime, urllib, re

sDate = '2003/11/01'    #default input date
eDate = '2006/05/31'    #default output date
ifTemp = False    #if temperature is asked for in the args
ifPrec = False    #if precipitation is asked for
ifHumi = False    #if humidity is asked for
fileOut = ''    #string that specifies what the filename should be
day = ''    #string that represents the normal formatted date
jDay = ''    #same as above but as a Julian date
month = ''    #string but numerical form of the month
nameMonth = ''    #name of the month
year = ''    #string but numerical form of the last 2 digits of year
wholeyear = ''    #whole numerical year
temp = 0.0    #float that represents the running total for temperature
prec = 0.0    #float that represents the precipitation
humi = 0.0    #float for the total humidity
countValid = 0    #int counter for how many valid entries have been collected
newLine = ""    #test string for taking in a new line from the url grabber

""" This method translates different aspects of a Date object
into it's appropriate variables. Returns jDay, day, month, nameMonth,
year, wholeyear all as a String"""
def dateParse(newMonth):
    day = newMonth.strftime("%A")
    jDay = newMonth.strftime("%j")
    temp = int(jDay)
    jDay = str(temp)
    month = newMonth.strftime("%m")
    nameMonth = newMonth.strftime("%B").lower()
    year = newMonth.strftime("%Y")
    year = year[2:]
    wholeyear = newMonth.strftime("%Y")
    return jDay, day, month, nameMonth, year, wholeyear

""" This method grabs a new file from the UTM site that usually 
represents the next
month from the current one. Returns the urlopen object."""
def setNewMonth(newMonth):
    dateParse(newMonth)
    currMonth = urllib.urlopen("http://eratos.erin.utoronto.ca/UTMMS/"\
                               +nameMonth+year+".txt")
    currMonth.readline()
    currMonth.readline()
    return currMonth

""" Getting the arguments from the command line"""
option, single = getopt.getopt(sys.argv[1:], "s:e:thp")

""" Translating the flags"""
for o, s in option:
    if o == "-s":
        sDate = s
    if o == "-e":
        eDate = s
    if o == "-t":
        ifTemp = True
    if o == "-h":
        ifHumi = True
    if o == "-p":
        ifPrec = True

""" Setting default behaviour in case of no flag specified"""
if not (ifTemp or ifHumi or ifPrec):
    ifTemp = True

""" Last optional argument, for file writing"""
if single:
    fileOut = open(str(single[0]), "w")

""" Basis date manipulation"""
splitDate = sDate.split('/')
then = datetime.date(int(splitDate[0]), int(splitDate[1]), int(splitDate[2]))

jDay, day, month, nameMonth, year, wholeyear= dateParse(then)

currMonth = urllib.urlopen("http://eratos.erin.utoronto.ca/UTMMS/"\
                           +nameMonth+year+".txt")
currMonth.readline()    #clearing the first two junk lines
currMonth.readline()

splitDate = eDate.split('/')
now = datetime.date(int(splitDate[0]), int(splitDate[1]), int(splitDate[2]))


newLine = currMonth.readline()    #Basis read

""" Loop that is active if the entry date is not equal to the end date.
The entry date iterates when either the 2400 line is read, or EOF
(empty string)"""
while not(then == now):
    """ First 2400 line?"""
    match = re.match(wholeyear+"\s+"+jDay+"\s+2400.+", newLine)
    if match:
        """ Second 2400 valid line?"""
        matchValid = re.match(wholeyear+"\s+"+jDay+"\s+2400\s+(?P<temp>\S+)"\
                     +"\s+(?P<humidity>\S+)\s+\S+\s+\S+\s+(?P<precip>\S+)",\
                      currMonth.readline())
        then = then + datetime.timedelta(days=1)
        if matchValid:
            countValid += 1
            """Next 3 if statements is for checking which type and for validity
            """
            if ifTemp:
                try:
                    temp += float(matchValid.group('temp'))
                except ValueError:
                    sys.stderr.write("On "+str(then)+\
                         ", a non-numeric value for temperature was found.")
                    countValid -= 1
                    
            if ifHumi:
                try:
                    humi += float(matchValid.group('humidity'))
                except ValueError:
                    sys.stderr.write("On "+str(then)\
                         +", a non-numeric value for humidity was found.")
                    countValid -= 1
            if ifPrec:
                try:
                    prec += float(matchValid.group('precip'))
                except ValueError:
                    sys.stderr.write("On "+str(then)\
                         +", a non-numeric value for precipitation was found.")
                    countValid -= 1
    
    """ Obtaining new date information, if new"""
    jDay, day, month, nameMonth, year, wholeyear = dateParse(then)
    newLine = currMonth.readline()
    if not newLine:    #if empty string
        then = then + datetime.timedelta(days=1)
        currMonth = setNewMonth(then)
        newLine = currMonth.readline()
        
""" If argument for writing to file is missing, print to screen"""
if not single:
    if not (temp or humi or prec):
        print "Since there was no data, an average cannot be obtained."
    if ifTemp:
        print ""
        print "There were "+ str(countValid)+" number of valid temperature measurements"\
        +" during this period. The average temperature is "+ str(temp/countValid) + "."
    if ifHumi:
        print ""
        print "There were "+ str(countValid)+" number of valid humidity measurements"\
        +" during this period. The average humidity is "+ str(humi/countValid) +"."
    if ifPrec:
        print ""
        print "There were "+ str(countValid)+" number of valid precipitation measurements"\
        +" during this period. The average precipitation is "+ str(prec/countValid) +"."
else:   #if argument is specified
    if not (temp or humi or prec):
        fileOut.write("Since there was no data, an average cannot be obtained.")
    if ifTemp:
        fileOut.write("There were "+ str(countValid)\
                      +" number of valid temperature measurements"\
        +" during this period. The average temperature is "+ str(temp/countValid) + ".")
    if ifHumi:
        fileOut.write("There were "+ str(countValid)+\
                      " number of valid humidity measurements"\
        +" during this period. The average humidity is "+ str(humi/countValid) +".")
    if ifPrec:
        fileOut.write("There were "+ str(countValid)+\
                      " number of valid precipitation measurements"\
        +" during this period. The average precipitation is "+ str(prec/countValid) +".")

    