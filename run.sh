#!/usr/bin/env bash

# get files from S3
if  [[ -n $S3_ENDPOINT && -n $S3_BUCKET ]] then
    echo "Getting files from S3 ..."
    if [[ -n $S3_SECRET_KEY && -n S3_ACCESS_KEY ]] then
      s3cmd --host=$S3_ENDPOINT --host-bucket=$S3_BUCKET.$S3_ENDPOINT --access_key=$S3_ACCESS_KEY --secret_key=$S3_SECRET_KEY --no-progress --recursive sync s3://$S3_BUCKET/ /data/
    else if [[ -n $S3_ACCESS_TOKEN ]] then
        s3cmd --host=$S3_ENDPOINT --no-progress --recursive --access_token=$S3_ACCESS_TOKEN sync s3://$S3_BUCKET/ /data/
      fi
    fi
fi

# run all scripts in background
for f in /autorun/*.sh; do
  echo "run script $f ..."

  bash "$f" &
done

echo "Started ..."

sleep infinity