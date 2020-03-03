#!/bin/sh -ev

pwd
type git

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
