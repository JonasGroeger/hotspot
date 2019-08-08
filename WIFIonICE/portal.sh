## This script logs you into the WifiOnICE portal of the Deutsche Bahn ICE service
## The call is directed just against wifionice.de with a referrer to detectportal.firefox.com

cookie="wifionice_cookie"

wget --quiet -T 120 --spider 'http://www.wifionice.de'

if [ $? == 0 ]; then
	echo "Connection to portal http://www.wifionice.de succeeded, retrieving CSRF token"
else
	echo "Could not connect to portal http://www.wifionice.de, maybe the timeout is too low"
	exit 1
fi

curl -s 'http://www.wifionice.de/de/?url=http%3A%2F%2Fdetectportal.firefox.com%2F' -H 'Connection: keep-alive' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3740.0 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: de-DE,de;q=0.9,en-US;q=0.8,en;q=0.7' --compressed --insecure --cookie-jar $cookie > /dev/null

csrf=$(cat wifionice_cookie | grep csrf | sed 's/.*csrf\s*//')

if [ $csrf != "" ]; then
	echo "Got a token! $csrf"
else
	echo "Didn't receive a token :( exiting"
	rm $cookie
	exit 2
fi

curl -s 'http://login.wifionice.de/de/' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' -H 'Origin: http://login.wifionice.de' -H 'Upgrade-Insecure-Requests: 1' -H 'Content-Type: application/x-www-form-urlencoded' -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3740.0 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3' -H 'Referer: http://login.wifionice.de/de/' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: de-DE,de;q=0.9,en-US;q=0.8,en;q=0.7' -H 'Cookie: csrf=$csrf' --data 'login=true&CSRFToken=$csrf&connect=' --compressed --insecure

wget --quiet --spider --timeout 10 'google.de'

if [ $? == 0 ]; then
	echo "You are online!"
else
	echo "Didn't get a response from google yet, maybe the connection is slow"
	rm $cookie
	exit 2
fi

rm $cookie