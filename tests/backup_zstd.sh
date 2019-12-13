#!/bin/bash

today=$(date +%Y-%m-%d)
yesterday=$(date -d "-1 day" +%Y-%m-%d)

bkup_path=/root/backup/$(hostname)_backup
mkdir -p $bkup_path

archive=$bkup_path/$(hostname)-$today.tar.gz
oldmetadata=$bkup_path/$(hostname)-$yesterday.metadata
newmetadata=$bkup_path/$(hostname)-$today.metadata

logfile=$bkup_path/$(hostname)-$today-zstd.log
exec 1>$logfile
exec 2>&1

echo $(date)

if [ "$(date +%A)" != "Sunday" ]; then
  if test -f "$oldmetadata"; then
    cp $oldmetadata $newmetadata
  fi
fi

tar \
  --exclude-from=tar_exclude \
  --exclude-tag-under=.exclude-under-from-tar-dump \
  --create \
  --preserve-permissions \
  --xattrs \
  -I zstd \
  --file=$archive \
  --listed-incremental=$newmetadata \
  --one-file-system \
  --ignore-failed-read \
  /home

echo $(date)

# now need to copy files from local filesystem to data.ucdenver.pvt
# should probably do an md5sum to make sure copy is good