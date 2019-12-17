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

if [[ $# > 1 || ( $# -eq 1 && "$1" != 'copy' ) ]]
then
    echo "Script accepts only 1 optional argument: $0 [copy]"
    exit 2
fi

if [[ "$1" == 'copy' ]]
then
    echo "Attempting to copy $archive to $archivedest"
    cp $archive $archivedest
    cp $newmetadata $dest_path
    cp -rp $bkup_path/*.log $dest_path
fi

# due to recent issues with SMB mounted storage location, verify that copy worked
echo "Creating sha256 sum for $archive"
file1sha=(`shasum -a 256 $archive`)
echo "Creating sha256 sum for $archivedest"
file2sha=(`shasum -a 256 $archivedest`)

if [[ "$file1sha" == "$file2sha" && "$file1sha" != "" ]]
then
    echo "Local and Remote files have the same content - removing local"
    echo "$archivedest has sha256: $file1sha"
    rm $archive
    rm $newmetadata
else
    echo "Files are NOT the same or cannot calculate sha256"
    echo "$archive has sha256: $file1sha"
    echo "$archivedest has sha256: $file2sha"
fi

echo $(date)
