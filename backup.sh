#!/bin/bash

today=$(date +%Y-%m-%d)
yesterday=$(date -d "-1 day" +%Y-%m-%d)

archive=$(hostname)-$today.tar.gz
metadata=$(hostname)-$today.metadata


if [ "$(date +%A)" != "Sunday" ]; then
  if test -f "$(hostname)-$yesterday.metadata"; then
    cp $(hostname)-$yesterday.metadata $metadata
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
  --listed-incremental=$metadata \
  /

