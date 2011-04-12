#!/usr/bin/env python

# ZIP Ranges PList generator
#
# Converts a full ZIP/State mapping database into an abbreviated list of
# ZIP ranges. Input in SQLite, output in Apple XML property list.
#
# Original ZIP code DB: http://databases.about.com/od/access/a/zipcodedatabase.htm
# MDB to SQLite conversion tool: http://code.google.com/p/mdb-sqlite/

import sqlite3
import plistlib

input_file = 'zipcodes.sqlite'
output_file = 'zipranges.plist'

zip_query = """
SELECT `ZIP Code`, `State Abbreviation`, `State Name`
FROM `ZIP Codes`
INNER JOIN States 
	ON States.`State Code` = `Zip Codes`.`State Code`
"""

conn_in = sqlite3.connect(input_file)
c_in = conn_in.cursor()

plist = dict(
		ranges = [],
		)

def addRange(start, end, state, statecode):
	print "Adding range", start, end, "for state", state, "(" + statecode + ")"
	range = dict(
			start = start,
			end = end,
			state = state,
			code = statecode,
			)
	plist["ranges"].append(range)

range_min = 0
range_max = 0
last_state = ""
last_state_code = ""
total_ranges = 0
total_zips = 0

c_in.execute(zip_query)

for row in c_in:
	curr_zip = row[0]
	curr_state_code = row[1]
	curr_state = row[2]

	if curr_state != last_state:
		if last_state != "":
			addRange(range_min, range_max, last_state, last_state_code)
			total_ranges += 1
		range_min = curr_zip
		last_state = curr_state
		last_state_code = curr_state_code
	
	range_max = curr_zip
	total_zips += 1

if range_max:
	addRange(range_min, range_max, last_state, last_state_code)
	total_ranges += 1

plistlib.writePlist(plist, output_file)

print "Created", total_ranges, "ZIP ranges for", total_zips, "ZIP codes"

