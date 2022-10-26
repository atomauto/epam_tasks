#!/bin/bash

#Help message for user
function usage() {
    echo "Usage: $0 output_file_with_path, e.g. '$0 output.txt'"
}

#Only one argument is permitted
if [[ "$#" -ne 1 ]]; then
    usage
    exit 1
fi

if [[ "$1" == -h || "$1" == --help ]]; then
    usage
    exit 0
fi

path="$(dirname "${1}")"
cat $1 | awk '#AWK PROGRAMM for parsing txt to json
#IN Begin sections we initialize our counters, FS - field separator and RS - line separator
BEGIN{count=0;successNumber=0;failNumber=0;testBlock=1;FS=" ";RS="\n"}
    #NR is the current line number
    #We take second and third field from first line - test name
    NR==1{testName = $2" "$3}
    #TestBlock is flag of tests block ending
    (!testBlock){
    allDuration = $NF
    sub(",","",$11)
    sub("%","",$11)
    rating = $11
    }
    #We skip second parasite line, so NR>2
    (NR>2 && testBlock){
    if (index($1,"-") != 0)
    {testBlock=0;}
    else
    {
    if ($1 == "not") 
    {
    failNumber+=1;status[count]="false";
    name[count]=$4
    for (i=5;i<NF;i++) 
        name[count]=name[count]" "$i
    }
    else
    {
    successNumber+=1;status[count]="true";
    name[count] = $3
    for (i=4;i<NF;i++) 
        name[count]=name[count]" "$i
    }
    #removing comma in name
    name[count] = substr(name[count], 1, length(name[count])-1)
    duration[count]=$NF
    count += 1
    }
    }
    END{
    print "{\n\"testName\": \""testName"\","
    print "\"tests\": ["
    #loop for printing all test
    for (j=0;j<count;j++){
        print "{"
        print "\"name\": \""name[j]"\","
        print "\"status\": "status[j]","
        print "\"duration\": \""duration[j]"\""
        if (j==count-1) print "}"
        else print "},"
        }
    print "],"
    print "\"summary\": {"
    print "\"success\": "successNumber","
    print "\"failed\": "failNumber","
    print "\"rating\": "rating","
    print "\"duration\": \""allDuration"\""
    print "}"
    print "}"
    }' > $path/output.json