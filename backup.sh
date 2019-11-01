#!/bin/bash

today=$(date +%Y-%m-%d)
yesterday=$(date -d "-1 day" +%Y-%m-%d)

archive=$(hostname)-$today.tar.gz
metadata=$(hostname)-$today.metadata

if test -f "$(hostname)-$yesterday.metadata"; then
  cp $(hostname)-$yesterday.metadata $metadata
fi

if [ "$(date +%A)" == "Sundary" ]; then
  level=0
else
  level=1
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
  --level=$level \
  ../Biostatistics



#archive2=$(hostname)-$today-2.tar.gz
#metadata2=$(hostname)-$today-2.metadata
#cp $metadata $metadata2
#tar --create --file=$archive2 --listed-incremental=$metadata2 ../Biostatistics
