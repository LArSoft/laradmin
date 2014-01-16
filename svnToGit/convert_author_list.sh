#!/bin/bash

# format of svn2git author list:
# user = Joe User <user@fnal.gov>


for author in `cat larsoft.authors`
do
   echo "author is $author"
   name=`grep $author /usr/local/share/obtain/unix.uid.list  | head -1 | cut -f3 -d":"`
   echo "$author = $name <$author@fnal.gov>" >> larsoft.git.author.list
done

exit 0
