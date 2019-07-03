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

echo "Input a latitude: "
read LAT
echo "Input a longitude: "
read LNG
RADIUS=1000
ALTITUDE=500
ACCURACY=100
SPEED=-1
HEADING=-1

echo $(echo $KEYS | jq -r ".token")

RESPONSE=$(curl --request GET \
	--url "${BASE_URL}bird/nearby?latitude=$LAT&longitude=$LNG&radius=$RADIUS" \
	--header "Authorization: Bird $(echo $KEYS | jq -r ".token")" \
	--header "Device-Id: $UUID" \
	--header "App-Version: $VERSION" \
	--header "Location: {\"latitude\":\"$LAT\",\"longitude\":\"$LNG\",\"altitude\":\"$ALTITUDE\",\"accuracy\":\"$ACCURACY\",\"speed\":\"$SPEED\",\"heading\":\"$HEADING\"}")

echo $RESPONSE
