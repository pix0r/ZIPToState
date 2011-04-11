#!/usr/bin/env python

# ZIP Ranges database generator
#
# Converts a full ZIP/State mapping database into an abbreviated list of
# ZIP ranges. Input and output both SQLite databases.
#
# Original ZIP code DB: http://databases.about.com/od/access/a/zipcodedatabase.htm
# MDB to SQLite conversion tool: http://code.google.com/p/mdb-sqlite/

import sqlite3

input_file = 'zipcodes.sqlite'
output_file = 'zipranges.sqlite'
dbvers = '0.1'

zip_query = """
SELECT `ZIP Code`, `State Abbreviation`, `State Name`
FROM `ZIP Codes`
INNER JOIN States 
	ON States.`State Code` = `Zip Codes`.`State Code`
"""

conn_in = sqlite3.connect(input_file)
conn_out = sqlite3.connect(output_file)

c_in = conn_in.cursor()
c_out = conn_out.cursor()

def addRange(cursor, start, end, state, statecode):
	print "Adding range", start, end, "for state", state, "(" + statecode + ")"
	params = (start, end, state, statecode,)
	cursor.execute("INSERT INTO zipranges VALUES (?, ?, ?, ?)", params)

c_out.execute('DROP TABLE IF EXISTS zipranges')
c_out.execute('CREATE TABLE zipranges (start int, end int, state varchar(100), code char(2));')
c_out.execute('DROP TABLE IF EXISTS dbversion')
c_out.execute('CREATE TABLE dbversion (vers char(20))')
c_out.execute('INSERT INTO dbversion VALUES (?)', (dbvers,))

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
			addRange(c_out, range_min, range_max, last_state, last_state_code)
			total_ranges += 1
		range_min = curr_zip
		last_state = curr_state
		last_state_code = curr_state_code
	
	range_max = curr_zip
	total_zips += 1

if range_max:
	addRange(c_out, range_min, range_max, last_state, last_state_code)
	total_ranges += 1

conn_out.commit()

print "Created", total_ranges, "ZIP ranges for", total_zips, "ZIP codes"

