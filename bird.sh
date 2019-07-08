#!/bin/sh
echo "Input a valid, previously-unused-for-Bird, email (doesn't need to be real): "
read EMAIL
UUID=$(uuidgen)
#UUID=${UUID^^}
PLATFORM=ios
VERSION="4.41.0"
AGENT="Bird/4.41.0 (co.bird.Ride; build:37; iOS 12.3.1) Alamofire/4.41.0"
BASE_URL=https://api.birdapp.com/

KEYS=$(curl --request POST \
	--url "${BASE_URL}user/login" \
	--header "Device-Id: $UUID" \
	--header "Platform: $PLATFORM" \
	--header "Content-Type: application/json" \
	--header "App-Version: $VERSION" \
	--header "User-Agent: $AGENT" \
	--data "{\"email\": \"$EMAIL\"}")

echo "Here are your token and ID. You can store these somewhere safe for future use, or you can always reauthenticate with a new email:\n"
echo $KEYS
echo "\n"

echo "Input a latitude (bot left): "
read LATBL
echo "Input a longitude (bot left): "
read LNGBL
echo "Input a latitude (top right): "
read LATTR
echo "Input a longitude (top right): "
read LNGTR


STEP=0.012
STEP2=0.012
RADIUS=1000
ALTITUDE=0
ACCURACY=100
SPEED=-1
HEADING=-1

while true
do

STEP=0.012
	for x in `seq $LATBL $STEP $LATTR`
	do
STEP2=0.012
		echo $x
		for y in `seq $LNGBL $STEP2 $LNGTR`
		do
			echo $y
			JSON_NAME=$(date +%s)_$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 4 | head -n 1)_b.json
			curl --request GET \
				--url "${BASE_URL}bird/nearby?latitude=$x&longitude=$y&radius=$RADIUS" \
				--header "Authorization: Bird $(echo $KEYS | jq -r ".token")" \
				--header "Device-Id: $UUID" \
				--header "App-Version: $VERSION" \
				--header "Location: {\"latitude\":\"$x\",\"longitude\":\"$y\",\"altitude\":\"$ALTITUDE\",\"accuracy\":\"$ACCURACY\",\"speed\":\"$SPEED\",\"heading\":\"$HEADING\"}" \
			>> $JSON_NAME
			done
		done
		node bird_parser.js
		rm *_b.json
$(curl --request POST \
	--url "${BASE_URL}user/login" \
	--header "Device-Id: $UUID" \
	--header "Platform: $PLATFORM" \
	--header "Content-Type: application/json" \
	--header "App-Version: $VERSION" \
	--header "User-Agent: $AGENT" \
	--data "{\"email\": \"$EMAIL\"}")
done
