#!/bin/sh
PATH=/usr/local/shellshoccar/bin:$PATH

TMP=/tmp/${0##*/}.$$

printf '%s' "${QUERY_STRING:-}"     |
cgi-name               > $TMP      

id=$(nameread id $TMP | tr -d "/" |tr -d ".")

rm -rf $TMP

TITLE=$(cat "md/${id}.md" | sed 's/:title \(.*\)/\1/' | head -n 1)
CREATE=$(cat "md/${id}.md" | sed 's/:create \(.*\)/\1/' | awk '{if(NR==2){print $0}}')

POST=$(./md2html.sh "md/${id}.md"          |
awk '
BEGIN{
    body_nr=0
}
{
    body[NR]=$0;
    if(body_nr == 0 && $0 == ":body") {
        body_nr=NR
    }
}
END{
    for(i=body_nr+1;i<=length(body);i++){
        print body[i]
        }
}')
POST=$(printf "${POST}" | sed 's/\//\\\//g')

#view
echo 'Content-type: text/html'
echo ''
cat template/post.html                     |
sed "s/:title/$TITLE/"                     |
sed "s/:create/$CREATE/"                   |                  
awk -v POST="$POST" '{
    if(match($0,":body")) {
        print POST
    }else{
        print $0
    }
}'