#!/bin/sh

export GIT_CHECK_EACH_NBMINUTES="${GIT_CHECK_EACH_NBMINUTES:="5"}"
export GIT_REPOSITORY="${GIT_REPOSITORY:=""}"

echo "$(jq -r -M '.name' /usr/share/nginx/html/package.json) version: $(jq -r -M '.version' /usr/share/nginx/html/package.json)"
echo "Used parameters:"
echo "----------------"
env | grep -E "GIT"
echo "----------------"

if [ "$GIT_REPOSITORY" = "" ];
then
  >&2 echo "Error: GIT_REPOSITORY parameter is mandatory."
  exit 1
fi

# to be ok with git clone with ssh auth
cp -f /root/.ssh/id_rsa.orig /root/.ssh/id_rsa
cp -f /root/.ssh/id_rsa.pub.orig /root/.ssh/id_rsa.pub
chmod 600 /root/.ssh/id_rsa
chmod 644 /root/.ssh/id_rsa.pub

/create-htmlreport.periodically.sh &

# exec the CMD (see Dockerfile comming from nginx docker image)
exec "$@"