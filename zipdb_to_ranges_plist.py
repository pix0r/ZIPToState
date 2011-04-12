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
	ORDER BY `ZIP Code` ASC
"""

conn_in = sqlite3.connect(input_file)
c_in = conn_in.cursor()

plist = []

c_in.execute(zip_query)

last_state = ""
total_zips = 0
total_ranges = 0

for row in c_in:
	curr_zip = row[0]
	curr_state_code = row[1]
	curr_state = row[2]
	total_zips += 1
	if curr_state != last_state:
		plist.append(dict(
			zip = curr_zip,
			state = curr_state,
			code = curr_state_code,
			))
		last_state = curr_state
		total_ranges += 1

plistlib.writePlist(plist, output_file)

print "Created", total_ranges, "ZIP ranges for", total_zips, "ZIP codes"

