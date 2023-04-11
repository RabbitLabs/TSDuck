#!/usr/bin/env bash

# get files from S3
if  [[ -n $S3_ENDPOINT && -n $S3_BUCKET && -n $S3_ACCESS_KEY && -n $S3_ACCESS_TOKEN && -n $S3_SECRET_KEY ]]
    s3cmd --host=$S3_ENDPOINT --access_key=$S3_ACCESS_KEY --secret_key=$S3_SECRET_KEY --access_token=$S3_ACCESS_TOKEN --no-progress --recursive sync s3://$S3_BUCKET/ /data/
fi

# just in case make all script executable
chmod +x /autorun/*.sh

# run all scripts in background
for f in /autorun/*.sh; do
  bash "$f" &
done
