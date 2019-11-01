#!/bin/bash

today=$(date +%Y-%m-%d)
yesterday=$(date -d "-1 day" +%Y-%m-%d)

bkup_path=/media/data_mount/backup/$(hostname)_backup

archive=$bkup_path/$(hostname)-$today.tar.gz
oldmetadata=$bkup_path/$(hostname)-$yesterday.metadata
newmetadata=$bkup_path/$(hostname)-$today.metadata


if [ "$(date +%A)" != "Sunday" ]; then
  if test -f "$oldmetadata"; then
    cp $oldmetadata $newmetadata
  fi
fi

tar \
  --exclude-from tar_exclude \
  --exclude-tag-under=.exclude-under-from-tar-dump \
  --create \
  --preserve-permissions \
  --xattrs \
  --gzip \
  --file=$archive \
  --listed-incremental=$newmetadata \
  /

