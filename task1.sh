#!/bin/bash
#We assume proper csv file, without line breaks and special symbols inside column values
#For more complex and general cases better use programming language with built-in csv parsing library
#Also according to script logic first line is a header
#AWK has problems with "", so we remove quotes and commas inside column values)

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
awk '
BEGIN{FS=OFS=","} 
    {
        $3=tolower($3)
        #extracting name and surname
        split($3,arr," ")
        for(x in arr)
        sub(arr[x],toupper(substr(arr[x],1,1))substr(arr[x],2),$3)
        #generating email
        $5=substr(arr[1],1,1) arr[2] "@abc.com"
        #counting names occurences
        ++namesCount[$3]
        #saving record
        records[NR] = $0
    }
END{
   #loop all saved records
   for (i=1; i<=NR; ++i) {
      n = split(records[i], a, /,/)
      #fixing email in header
      if (i == 1)
         a[5]="email"
      #fixing emails for duplicates
      if (namesCount[a[3]] > 1)
         sub("@",a[2]"@",a[5])
      #printing all lines
      for (k=1; k<=n; ++k)
         printf "%s", a[k] (k < n ? FS : ORS)
    }
    }
    ' $path/accounts_temp.csv > $path/accounts_new.csv
rm $path/accounts_temp.csv
