#!/bin/bash

today=$(date +%Y-%m-%d)
yesterday=$(date -d "-1 day" +%Y-%m-%d)

bkup_path=/root/backup/$(hostname)_backup
mkdir -p $bkup_path

dest_path=/media/data_mount/backup/$(hostname)_backup
mkdir -p $bkup_path

afn=$(hostname)-$today.tar.gz
archive=$bkup_path/$afn
archivedest=$dest_path/$afn
oldmetadata=$dest_path/$(hostname)-$yesterday.metadata
newmetadata=$bkup_path/$(hostname)-$today.metadata

logfile=$bkup_path/$(hostname)-$today.log
exec 1>$logfile
exec 2>&1

echo $(date)

if [ "$(date +%A)" != "Sunday" ]; then
  if test -f "$oldmetadata"; then
    cp $oldmetadata $newmetadata
  fi
fi


# slower compression which should result in better compression doesn't make a noticiable difference in end file size
tar \
  --exclude-from=tar_exclude \
  --exclude-tag-under=.exclude-under-from-tar-dump \
  --create \
  --preserve-permissions \
  --xattrs \
  -I 'pigz -p 24' \
  --file=$archive \
  --listed-incremental=$newmetadata \
  --one-file-system \
  --ignore-failed-read \
  /

cp $archive $archivedest
cp $newmetadata $dest_path
cp -rp $bkup_path/*.log $dest_path

# due to recent issues with SMB mounted storage location, verify that copy worked
file1sha=(`shasum -a 256 $archive`)
file2sha=(`shasum -a 256 $archivedest`)

if [ "$file1sha" == "$file2sha" ]
then
    echo "Local and Remote files have the same content - removing local"
    echo $archivedest $file1sha
    rm $archive
    rm $newmetadata
else
    echo "Files are NOT the same"
    echo $archive $file1sha
    echo $archivedest $file2sha
fi

echo $(date)
