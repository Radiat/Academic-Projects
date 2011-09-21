all: args_error defaults value value_and_error
args_error: test0 test1 test2 test3 test4 test5 
defaults: test6 test7 test8 test9
value: test10 test11 test12 test13 test14
value_and_error: test15 test16    
PYTHON = nice python
# Description of tests: 
#
# 
#args_error:
#  These tests cover errors in the arguments which should be reported
#  to standard error and the program should stop
#test 0:  unknown flags 
#test 1:  extra args
#test 2:  args without parameters
#test 3:  args with incorrectly formatted parameters
#test 4:  dates outside of valid range
#test 5:  date range is negative (end before start)
#
#args_defaults:
#   These tests check the default values and should not give an error
#test 6:  default values for dates
#test 7:  default values for start date but end specified
#test 8:  default values for end date but start specified
#test 9:  default values for -t  (compares output to test8)
#
#value tests - basic cases all within a single file
# test 10: averages for temp
# test 11: average for  prec 
# test 12: average for humidity
#
# test 13: averages for multiple files
# test 14: averages where values are *all* in the month following the enddate 
# test 15: including nd value - does it get reported
# test 16: averages for valid ranges with no valid data points (battery problem)



test0: 
	@echo ""
	@echo "================================================================"
	@echo "   $@"
	@rm -f $@.stud.out 
	@touch $@.stud.out
	@# unknown flags
	-${PYTHON} average_weather.py -b -j > $@.stud.out 2>$@.stud.err
	@echo "Should give usage or report extra or unknown option flags"
	@echo "------------------------------------"
	@cat $@.stud.err
	@echo "------------------------------------"
	@echo "Should not have any output below this line"
	@cat $@.stud.out
	@echo "------------------------------------"

test1: 
	@echo ""
	@echo "================================================================"
	@echo "   $@"
	@rm -f $@.stud.out 
	@touch $@.stud.out
	@# extra arguments
	-${PYTHON} average_weather.py -h test1.stud.out extraArg 2 2>$@.stud.err
	@echo "Should give usage or report extra arguments"
	@echo "------------------------------------"
	@cat $@.stud.err
	@echo "------------------------------------"
	@echo "Should not have any output below this line"
	@cat $@.stud.out
	@echo "------------------------------------"

test2: 
	@echo ""
	@echo "================================================================"
	@echo "   $@"
	@rm -f $@.stud.out 
	@touch $@.stud.out
	@# arguments without parameters
	-${PYTHON} average_weather.py -s  >$@.stud.out 2>$@.stud.err
	@echo "Should give usage or report that -s flag needs a parameter"
	@echo "------------------------------------"
	@cat $@.stud.err
	@echo "------------------------------------"
	@echo "Should not have any output below this line"
	@cat $@.stud.out
	@echo "------------------------------------"

test3: 
	@echo ""
	@echo "================================================================"
	@echo "   $@"
	@rm -f $@.stud.out 
	@touch $@.stud.out
	@# arguments with incorrectly formatted parameters
	-${PYTHON} average_weather.py -s 2004/20/05 >$@.stud.out 2>$@.stud.err
	@echo "Should give usage or report that -s parameter is not a valid date"
	@echo "------------------------------------"
	@cat $@.stud.err
	@echo "------------------------------------"
	@echo "Should not have any output below this line"
	@cat $@.stud.out
	@echo "------------------------------------"

test4: 
	@echo ""
	@echo "================================================================"
	@echo "   $@"
	@rm -f $@.stud.out 
	@touch $@.stud.out
	@# dates outside valid range
	-${PYTHON} average_weather.py -s 2001/05/05 >$@.stud.out 2>$@.stud.err
	@echo "Should report that start date is before valid period"
	@echo "------------------------------------"
	@cat $@.stud.err
	@echo "------------------------------------"
	@echo "Should not have any output below this line"
	@cat $@.stud.out
	@echo "------------------------------------"

test5: 
	@echo ""
	@echo "================================================================"
	@echo "   $@"
	@rm -f $@.stud.out 
	@touch $@.stud.out
	@# date range is negative (end before start)
	-${PYTHON} average_weather.py -s 2006/05/31 -e 2006/05/04  $@.stud.out 2>$@.stud.err
	@echo "Should report that end date is before start date"
	@echo "------------------------------------"
	@cat $@.stud.err
	@echo "------------------------------------"
	@echo "Or else should report no valid measurements in range"
	@cat $@.stud.out
	@echo "------------------------------------"

test6: 
	@echo ""
	@echo "================================================================"
	@echo "   $@"
	@rm -f $@.stud.out 
	@touch $@.stud.out
	@# default values for dates
	-${PYTHON} average_weather.py -t  $@.stud.out  2>$@.stud.err
	@echo "Should report duration of 908 days below this line to get marks"
	@echo "------------------------------------"
	@cat $@.stud.out
	@echo "------------------------------------"
	@echo "Should have no output below line: test6.stud.err"
	@cat $@.stud.err

test7: 
	@echo ""
	@echo "================================================================"
	@echo "   $@"
	@rm -f $@.stud.out 
	@touch $@.stud.out
	@# default start date but specified end date
	-${PYTHON} average_weather.py  -e 2003/11/04 -t  $@.stud.out  2>$@.stud.err
	@echo "Should report 4 days with temp about 8.2 below this line"
	@echo "------------------------------------"
	@cat $@.stud.out
	@echo "------------------------------------"
	@echo "Should have no output below line: test7.stud.err"
	@cat $@.stud.err

test8: 
	@echo ""
	@echo "================================================================"
	@echo "   $@"
	@rm -f $@.stud.out 
	@touch $@.stud.out
	@# default end date but specified start date
	-${PYTHON} average_weather.py -s 2006/05/04 -t  $@.stud.out  2>$@.stud.err
	@echo "Should report 28 days with temp about 14 below this line"
	@echo "------------------------------------"
	@cat $@.stud.out
	@echo "------------------------------------"
	@echo "Should have no output below line: test8.stud.err"
	@cat $@.stud.err

test9: 
	@echo ""
	@echo "================================================================"
	@echo "   $@"
	@rm -f $@.stud.out 
	@touch $@.stud.out
	@# does temp by default
	-${PYTHON} average_weather.py -s 2006/05/04 -e 2006/05/31  $@.stud.out 2>$@.stud.err
	@echo "Should have no output below this line to pass test"
	@echo "------------------------------------"
	-@diff test8.stud.out test9.stud.out
	@echo "------------------------------------"

test10: 
	@echo ""
	@echo "================================================================"
	@echo "   $@"
	@# value for temperature average
	@rm -f $@.stud.out 
	@touch $@.stud.out
	-${PYTHON} average_weather.py -s 2004/05/20 -e 2004/05/26 -t $@.stud.out  2>$@.stud.err
	@echo "Should report 7 days w/ average about 13.8 below this line" 
	@echo "------------------------------------"
	@cat $@.stud.out
	@echo "------------------------------------"
	@echo "Should have no output below line: test10.stud.err"
	@cat $@.stud.err

test11: 
	@echo ""
	@echo "================================================================"
	@echo "   $@"
	@# value for precipitation average 
	@rm -f $@.stud.out 
	@touch $@.stud.out
	-${PYTHON} average_weather.py -s 2004/05/20 -e 2004/05/26 -p $@.stud.out  2>$@.stud.err
	@echo "Should report average precip about 5.5 below this line" 
	@echo "------------------------------------"
	@cat $@.stud.out
	@echo "------------------------------------"
	@echo "Should have no output below line: test11.stud.err"
	@cat $@.stud.err

test12: 
	@echo ""
	@echo "================================================================"
	@echo "   $@"
	@# value for humidity average
	@rm -f $@.stud.out 
	@touch $@.stud.out
	-${PYTHON} average_weather.py -s 2004/05/20 -e 2004/05/26 -h $@.stud.out  2>$@.stud.err
	@echo "Should report an average humidity about 98 below this line" 
	@echo "------------------------------------"
	@cat $@.stud.out
	@echo "------------------------------------"
	@echo "Should have no output below line: test12.stud.err"
	@cat $@.stud.err

test13: 
	@echo ""
	@echo "================================================================"
	@echo "   $@"
	@# averages for multiple files
	@rm -f $@.stud.out 
	@touch $@.stud.out
	-${PYTHON} average_weather.py -s 2006/01/26 -e 2006/03/17 -t $@.stud.out  2>$@.stud.err
	@echo "Should report a duration of 51 days and an average about -1 below this line" 
	@echo "------------------------------------"
	@cat $@.stud.out
	@echo "------------------------------------"
	@echo "Should have no output below line: test13.stud.err"
	@cat $@.stud.err

test14: 
	@echo ""
	@echo "================================================================"
	@echo "   $@"
	@# averages where values are *all* in the month following the enddate 
	@rm -f $@.stud.out 
	@touch $@.stud.out
	-${PYTHON} average_weather.py -s 2004/12/25 -e 2004/12/30 -h $@.stud.out  2>$@.stud.err
	@echo "Should report a duration of 6 days and an average about 93 below this line" 
	@echo "------------------------------------"
	@cat $@.stud.out
	@echo "------------------------------------"
	@echo "Should have no output below line: test14.stud.err"
	@cat $@.stud.err

test15: 
	@echo ""
	@echo "================================================================"
	@echo "   $@"
	@# including nd value - does it get reported
	@rm -f $@.stud.out 
	@touch $@.stud.out
	-${PYTHON} average_weather.py -s 2005/02/01 -e 2005/02/20 -h $@.stud.out  2>$@.stud.err
	@echo "Should report a duration of 12 days and an average about 83 below this line" 
	@echo "------------------------------------"
	@cat $@.stud.out
	@echo "------------------------------------"
	@echo "Should report \"nd\" errors below this line"
	@echo "------------------------------------"
	@cat $@.stud.err

test16: 
	@echo ""
	@echo "================================================================"
	@echo "   $@"
	@# averages for valid ranges with no valid data points (battery problem)
	@rm -f $@.stud.out 
	@touch $@.stud.out
	-${PYTHON} average_weather.py -s 2005/02/01 -e 2005/02/06 -h $@.stud.out  2>$@.stud.err
	@echo "Should either say nothing or report that no data are available below this line" 
	@echo "------------------------------------"
	@cat $@.stud.out
	@echo "------------------------------------"
	@echo "Should report \"nd\" errors below this line"
	@echo "------------------------------------"
	@cat $@.stud.err

clean:
	@echo "Deleting student results files"
	rm -f test*.stud.out
	rm -f test*.stud.err
