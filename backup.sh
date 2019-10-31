#!/bin/bash

today=$(date +%Y-%m-%d)
yesterday=$(date -d "-1 day" +%Y-%m-%d)
archive=$(hostname)-$today.tar
archive2=$(hostname)-$today-2.tar
metadata=$(hostname)-$today.metadata
metadata2=$(hostname)-$today-2.metadata

tar --create --file=$archive --listed-incremental=$metadata ../Biostatistics
cp $metadata $metadata2
tar --create --file=$archive2 --listed-incremental=$metadata2 ../Biostatistics
