# bkup_via_tar
Bash script and supporting files for backing up an Ubuntu Server using tar.

The objective:

  * A level 0 dump of the /home directory once a week,
  * A level 0 dump of most of the system once a week.
  * A daily level 1 dump of /home

Script will be expected to work on two similar yet independent systems.

## Cron configuration

```
# m h  dom mon dow   command
0 3 * * * cd /root/bkup_via_tar; /root/bkup_via_tar/backup.sh 2>&1 >> /media/data_mount/backup/skylark_backup/logs/`date +\%Y\%m\%d\%H\%M\%S`-tar-cron.log 2>&1
root@skylark:~/backup/skylark_backup#
```

## Notes
One of the options for users to exclude data from the backup process is to add
the a file named `.exclude-under-from-tar-dump`.

For example, say you have a simple project:

    adir/
    |-- subdir
    |   |-- cfile
    |   |-- dfile
    |   `-- .exclude-under-from-tar-dump
    |-- afile
    `-- bfile

There are two files, afile and bfile, on the project root directory `adir`.  The
is one subdir with the files cfile, dfile, and the hidden file .exclude-under-from-tar-dump

The resulting structure in the archive will be:

    adir/
    adir/subdir/
    adir/afile
    adir/bfile

Note that the subdir path is archived, but none of the files are.

