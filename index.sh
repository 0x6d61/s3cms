#!/bin/sh

POST_LENGTH=$(ls md | wc -l)

echo 'Content-type: text/html'  
echo ''
if [ $POST_LENGTH -gt 0 ] ; then
	POST_LINK=$(ls -lt md | sed "s/  */ /g" | awk '{print $9}' | sed '/^$/d' | sed 's/\(.*\)\.md/<a href="\/post.sh?id=\1">\1<\/a><br>/')
	cat template/index.html										|
	awk -v POST_LINK="$POST_LINK" '{
    if(match($0,":body")) {
        print POST_LINK
    }else{
        print $0
    }
}'    
else
	cat template/index.html 									|
	sed  's/:body/記事がありません/'
fi
