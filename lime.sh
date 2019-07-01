#!/bin/sh

BASE_URL="https://web-production.lime.bike/api/rider/v1/"

# Prompt for phone number to auth with Lime

echo "Please enter your phone number associated with your Lime account.
	You will get an authentication code texted to that number.
	If you don't have a Lime account associated with that number,
	make one!"

read PHONE

echo "Sending auth code to $PHONE..."

# Send the API request

curl --request GET \
	--url "${BASE_URL}login?phone=$PHONE"

# Receive auth code and get down to business

echo "Input the received auth code: "
read AUTH
echo "Input your international extension (US/CA is +1)"
read INTL

COOKIEJAR_PATH="~/.scooter_cookies"

echo $AUTH $INTL

TOKEN=$(curl --request POST \
	--cookie-jar $COOKIEJAR_PATH \
	--url "${BASE_URL}login" \
	--header "Content-Type: application/json" \
	--data "{\"login_code\": \"$AUTH\", \"phone\": \"$INTL$PHONE\"}" | jq -r ".token")

echo "Input a latitude to check scooters around!"
read LAT
echo "Input a longitude to check scooters around!"
read LNG

BOUNDING=0.1 # Observe scooters in a 0.1 degree-long bounding box
ZOOM=16 # Zoom level. When < 15, vehicles are clustered
while true
do
(curl --request GET \
	--url "${BASE_URL}views/map?ne_lat=${LAT%.1f+$BOUNDING}&ne_lng=${LNG%.1f+$BOUNDING}&sw_lat=${LAT%.1f-$BOUNDING}&sw_lng=${LNG%.1f-$BOUNDING}&user_latitude=${LAT}&user_longitude=${LNG}&zoom=16" \
	--cookie $COOKIEJAR_PATH \
	--header "authorization: Bearer $TOKEN") >> $(date +%s)_l.json
#| python -m json.tool) >> 
	
sleep 300
done



