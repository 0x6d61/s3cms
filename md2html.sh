#!/bin/sh
set -u

file="$1"

case $file in
    /*|./*|../*)    :           ;;
    *)          file="./"$file  ;;
esac

cat "$file"                                                                 |
sed 's/\&/\&amp;/g'							                                |
sed 's/"/\&quot;/g'						                                    |
sed 's/</\&lt;/g'							                                |
sed 's/>/\&gt;/g'	                                                        |
sed 's/```\(.*\)```/<pre><code>\1<\/code><\/pre>/'                          |
awk '
BEGIN{
    code_flag=false
}
{
    a[NR]=$0
    if(match($0,"```") && a[NR-1] == "") {
        a[NR]="<pre><code>"
        code_flag=true
    }else if($0 == "" && match(a[NR-1],"```")) {
        a[NR-1]="</code></pre>"
        code_flag=false
    }
    if(code_flag==true && !match($0,"```")) {
        gsub("*", "\\&#042;", $0)
        a[NR]=$0
    }   
}
END{
    for(i=0;i<length(a);i++) {
        print a[i]
    }
}'                                                                          |
sed 's/^# \(.*\)/<h1>\1<\/h1>/'                                             |
sed 's/^### \(.*\)/<h3>\1<\/h3>/'                                           |
sed 's/^\*\*\*$/<hr>/'                                                      |
sed 's/^\* \* \*$/<hr>/'                                                    |
sed 's/^\*\*\*\*\*/<hr>/'                                                   |
sed 's/^\* \(.*\)/<li>\1<\/li>/'                                            |
awk '{
    a[NR]=$0
    if(match($0,"<li>") && a[NR-1] == "") {
        a[NR-1]="<ul>"
    }else if($0 == "" && match(a[NR-1],"</li>")) {
        a[NR]="</ul>"
    }
}
END {
    for(i = 0;i<length(a);i++) {
        print a[i]
        }
}'                                                                          |
sed 's/^[0-9]*\. \(.*\)/<li>\1<\/li>/'                                      |
awk '{
    a[NR]=$0
    if(match($0,"<li>") && a[NR-1] == "") {
        a[NR-1]="<ol>"
    }else if($0 == "" && match(a[NR-1],"</li>")) {
        a[NR]="</ol>"
    }
}
END {
    for(i = 0;i<length(a);i++) {
        print a[i]
        }
}'                                                                         |
sed 's/\!\[\(.*\)\](\(.*\) "\(.*\)")/<img src="\2" title="\3">\1<\/img>/'  |
sed 's/\!\[\(.*\)\](\(.*\))/<img src="\2">\1<\/img>/'                      |
sed 's/\[\(.*\)\](\(.*\) "\(.*\)")/<a href="\2" title="\3">\1<\/a>/'       |
sed 's/\[\(.*\)\](\(.*\))/<a href="\2">\1<\/a>/'                           | 
sed 's/^>\(.*\)/<blockquate>\1<\/blockquate>/'                             |
sed 's/\*\*\(.*\)\*\*/<strong>\1<\/strong>/'                               |      
sed 's/\*\(.*\)\*/<em>\1<\/em>/'                                           |
sed 's/~~\(.*\)~~/<del>\1<\/del>/'                                         |
sed 's/- - -/<hr>/'                                                        |
sed 's/---/<hr>/'                                                          |
sed 's/  $/<br>/'                                                          