#!/bin/sh
# Author : Kuldeep Sharma
# Description : Used to get list of available tags on all available repositries on Docker private registry.
#
# Usage:
#   $ ./docker-tag-list.sh -u user
if [ $# -lt 1 ]
then
cat << HELP

docker repo tags   --  list all tags for all available Docker images on a remote registry.

EXAMPLE: 
    - ./docker-tag-list.sh -u user

HELP
exit 1
fi
echo -n Password: 
read -s passwd
echo -e "\n"

for Repo in `curl -s  -X GET https://$1:$passwd@test.docker.reg/v2/_catalog  | awk -F":" '{$1="";  print}' | sed -e 's/,/\n/g' -e 's/{\|}\|\[\|\]\|\"\|\ "//g'` ; \
do
        Tag=`curl -s -S "https://$1:$passwd@test.docker.reg/v2/$Repo/tags/list"  | \
            sed -e 's/,"tags":/,\n/g' | \
            grep -v '"name"' | \
            sed -e 's/,/\n/g' -e 's/{\|}\|\[\|\]\|\ "\|\"//g'`

            echo -e "Tags List for Docker Repository $Repo:"
            echo  "${Tag}" |sed 's/^/---------> /' | nl
            echo -e "\n"

done
