#!/bin/sh -ev

pwd
which git

git branch -d -r svn/trunk
git branch -d -r svn/Tag-3-February-2011-15.15CST
git branch -d -r svn/Tag-31-January-2011-17.40CST
git branch -a

# not sure if this helps at all, but it doesn't hurt
(
cd .git
rm -rf refs/remotes/ refs/original/ *_HEAD logs/
)
git for-each-ref --format="%(refname)" refs/original/ | xargs -n1 --no-run-if-empty git update-ref -d
git -c gc.reflogExpire=0 -c gc.reflogExpireUnreachable=0 -c gc.rerereresolved=0 -c gc.rerereunresolved=0 -c gc.pruneExpire=now gc "$@"

git gc --aggressive

git gc --prune=now
