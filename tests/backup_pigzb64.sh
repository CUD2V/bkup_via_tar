#!/bin/bash

today=$(date +%Y-%m-%d)
yesterday=$(date -d "-1 day" +%Y-%m-%d)

bkup_path=/root/backup/$(hostname)_backup/pigz_64
#bkup_path=/media/data_mount/backup/$(hostname)_backup
#bkup_path=/media/data_mount/backup/$(hostname)_backup/pigz
mkdir -p $bkup_path

archive=$bkup_path/$(hostname)-$today.tar.gz
oldmetadata=$bkup_path/$(hostname)-$yesterday.metadata
newmetadata=$bkup_path/$(hostname)-$today.metadata

logfile=$bkup_path/$(hostname)-$today-pigz.log
exec 1>$logfile
exec 2>&1

echo $(date)

if [ "$(date +%A)" != "Sunday" ]; then
  if test -f "$oldmetadata"; then
    cp $oldmetadata $newmetadata
  fi
fi

# also see if -9 helps with performance (better compression ratio)
# also try larger and smaller block sizes -b 256 -b 512 -b 64 default is 128
tar \
  --exclude-from=tar_exclude \
  --exclude-tag-under=.exclude-under-from-tar-dump \
  --create \
  --preserve-permissions \
  --xattrs \
  -I 'pigz -p 24 -b 64' \
  --file=$archive \
  --listed-incremental=$newmetadata \
  --one-file-system \
  --ignore-failed-read \
  /home

echo $(date)

# now need to copy files from local filesystem to data.ucdenver.pvt
# should probably do an md5sum to make sure copy is good
