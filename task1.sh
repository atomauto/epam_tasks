#!/bin/bash
#We assume proper csv file, without line breaks and special symbols inside column values
#For more complex and general cases better use programming language with built-in csv parsing library
#Also according to script logic first line is a header
#AWK has problems with "", so I've made two solutions
#First solution is this file (strict study solution "task1.sh", where we remove quotes and commas inside column values)
#Second solition is inside file "task1_irl.sh" (real-life solution, where we use google and extra library)

#Help message for user
function usage() {
    echo "Usage: $0 accounts_file_with_path, e.g. '$0 accounts.csv'"
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
#Preparing file for awk (remove "" and commas inside "" and extra spaces)
#NOTICE: it's extra modification, which isn't mentioned in task, in IRL I would communicate about it with Department head
cat $1 | sed ':a;s/^\(\([^"]*,\?\|"[^",]*",\?\)*"[^",]*\),/\1 /;ta;s/  */ /g' | tr -d "\"" >$path/accounts_temp.csv
#Update column name and generate email by pattern
cat $path/accounts_temp.csv | awk '
            BEGIN{
                FS=","
                OFS=","
                marker=777} 
            {
            $3=tolower($3)
            split($3,arr," ")
            for(x in arr)
            sub(arr[x],toupper(substr(arr[x],1,1))substr(arr[x],2),$3)
            $5=substr(arr[1],1,1) arr[2] "@abc.com"
            if (names[$3] == marker) {
                sub("@",$2"@",$5)
                sub("@",location[$3]"@",email[$3])
            }
            names[$3] = marker
            location[$3] = $2
            email[$3] = $5
            }
            ' >$path/accounts_new.csv
            #                 print("DEBUG " location[$3]"@ "email[$3])
            # ' >$path/accounts_new.csv

#Adding location_id for duplicate emails
# cat $path/accounts_new.csv >$path/accounts_temp.csv
# duplicate_emails=$(cat $path/accounts_temp.csv | awk -F , '{print $5}' | uniq -d)
# cat $path/accounts_temp.csv | awk -F , 'NR == 1 {p=$5; next} p == $5 {$5=substr($3,"@") $2 $5} {p=$5} {print}'
rm $path/accounts_temp.csv
