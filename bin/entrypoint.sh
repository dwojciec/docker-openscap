#!/bin/bash -x

set -x

oc project openshift
docker pull $IMAGE

oscap-docker image-cve $IMAGE --results oval.xml --report image.html $*
SUCCESS=$?
ls -l

if [ $SUCCESS == 0 ]; then
  echo "Success! Promoting image to Service Catalog"
  oc import-image `basename $IMAGE` --from=$IMAGE --confirm
  EMAIL_SUBJECT="Promoted image $IMAGE to Service Catalog"
else
  echo "Security breach! Removing image from Service Catalog"
  oc delete istag `basename $IMAGE`
  EMAIL_SUBJECT="Security Breach! Removed image $IMAGE from Service Catalog"
fi

#/usr/bin/html2text -o /var/log/openscap.txt image.html 
echo -e "From: openscap_image-staging@schiphol.nl
To: $EMAIL_RESULT
Date: $(date)
Subject: $EMAIL_SUBJECT
MIME-Version: 1.0
Content-Type: text/html; charset=utf-8

$(cat image.html)" | ssmtp -r $EMAIL_RESULT

exit $SUCCESS
