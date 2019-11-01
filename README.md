# bkup_via_tar
Bash script and supporting files for backing up an Ubuntu Server using tar.

The objective:

  * A level 0 dump of the /home directory once a week,
  * A level 0 dump of most of the system once a week.
  * A daily level 1 dump of /home

Script will be expected to work on two similar yet independent systems.

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

Note that the subdir path is archived, but non of the files are.
