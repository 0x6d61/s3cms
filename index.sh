#!/bin/sh

POST_LENGTH=$(ls md | wc -l)

echo 'Content-type: text/html'  
echo ''
if [ $POST_LENGTH -gt 0 ] ; then
	POST_LINK=$(ls md											|
	sed 's/\(.*\)\.md/<a href="\\\/post.sh?id=\1">\1<\\\/a>/')
	cat template/index.html										|
	sed "s/:body/$POST_LINK/"	
else
	cat template/index.html 									|
	sed  's/:body/記事がありません/'
fi
