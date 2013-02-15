#!/bin/bash
#Sorts an rndc bind dump into A C MX and PTR records. The dump tool should have this option imo
#I also strip off the trailing period and remove the fluff I dont need from the middle of the records.


greps=("IN A" "IN CNAME" "IN MX" "IN PTR")
bind_server="$1"
bind_dump=/tmp/named_dump.db

prepare () {

if  [[ ! -f "$bind_dump" ]] 
        then
echo $bar
                ssh -l root "$bind_server" 'rndc dumpdb -zones'
                scp -q root@"$bind_server":/var/cache/bind/named_dump.db "$bind_dump"
fi

}

sortzones () {
for count in "${!greps[@]}";
do
        grep "${greps[count]}" $bind_dump | awk '{print $1 "     " $5}' | sed s',\. \ ,,g' | column -t > "${greps[count]}";

                echo -n "There are "; wc -l "${greps[count]}"

echo "${#greps[count]}"
done
}


prepare
sortzones

