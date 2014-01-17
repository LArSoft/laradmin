#!/bin/bash

# to get the base svn author list:
# svn log --quiet http://cdcvs.fnal.gov/subversion/larsoftsvn | grep -E "r[0-9]+ \| .+ \|" | awk '{print $3}' | sort | uniq > larsoft.authors

# format of svn2git author list:
# user = Joe User <user@fnal.gov>


for author in `cat larsoft.authors`
do
   echo "author is $author"
   name=`grep :$author /usr/local/share/obtain/unix.uid.list  | head -1 | cut -f3 -d":"`
   echo "$author = $name <$author@fnal.gov>" >> larsoft.git.author.list
done

exit 0
