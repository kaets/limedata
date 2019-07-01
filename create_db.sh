#!/bin/sh

DB_NAME=test.db
if [ ! -f "$DB_NAME" ]
then 
	sqlite3 test.db "CREATE TABLE lime(id VARCHAR(30) PRIMARY KEY, lat REAL, lng REAL, fetched_at INTEGER, status TEXT, last_three CHARACTER(3), last_activity_at INTEGER, type_name TEXT, battery_level TEXT, meter_range INTEGER, rate_plan TEXT);"
fi

JSON_FILES=*_l.json

for f in $JSON_FILES
do
	echo "Processing $f..."
	for row in $(jq '.data.attributes.bikes[].attributes' $f)
	do
	#	echo $row | jq ".attributes"
		echo $row
	#	$LAT=$(jq -c ".lat | $row")
	#	$LNG=$(jq -c ".lng | $row")
	#	$FETCHED=$(echo $f | cut -d'_' -f 1)
	#	$STATUS=$(jq -c ".status | $row")
	#	$LAST_THREE=$(jq -c ".last_three | $row")
	#	$LAST_ACTIVITY=$(date -d $(jq -c ".last_activity_at | $row") +"%s")
	#	$TYPE=$(jq -c ".type_name | $row")
	#	$BATTERY=$(jq -c ".battery_level | $row")
	#	$RANGE=$(jq -c ".meter_range | $row")
	#	$RATE=$(jq -c ".rate_plan | $row")
	#	sqlite3 test.db "INSERT INTO lime VALUES($LAT,$LNG,$FETCHED,$STATUS,$LAST_THREE,$LAST_ACTIVITY,$TYPE,$BATTERY,$RANGE,$RATE);"
	done
done
