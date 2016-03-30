#!/bin/bash

# Directory that holds your WordPress sites' root folders
PREFIX=/home

# Local db backups folder
LOCALDBBACKUPDIR=db_backups

# s3 db backups folder
S3DBBACKUPDIR=db_backups

currdate=$(date +'%Y%m%d')

if [ ! -d "$PREFIX/$LOCALDBBACKUPDIR/$currdate" ]; then
  mkdir $PREFIX/$LOCALDBBACKUPDIR/$currdate
fi

cd $PREFIX
for dir in $(ls -d */);
do
  :
  dir="${dir//\/}"
  printf "********* START Processing $dir **********\n"
 
  # Check if cpanel/site is suspended. No need to backup
  suspended=$(grep SUSPENDED /var/cpanel/users/$dir)
  if [ $suspended ]
    then
    printf "$dir is suspended. Skipping..\n"
    continue
  fi

  printf "Backing up $PREFIX/$dir\n"
  cd $PREFIX/$dir/public_html

  /usr/local/bin/php -d extension=phar.so /usr/local/bin/wp --path="$PREFIX/$dir/public_html/" db export --allow-root $PREFIX/$LOCALDBBACKUPDIR/$currdate/$dir.sql
 
  # files
  printf "Syncing uploads directory to S3...\n"
  if [ -f s3.txt ]
   then
    printf "s3 bucketname is different than cpanel username..\n"
    s3_bucket_name=$(cat s3.txt)
    
  else
    printf "s3 bucket name same as cpanel username..\n"
    s3_bucket_name=$dir
  fi
 
  /usr/local/bin/aws s3 sync /home/$dir/public_html/ s3://$s3_bucket_name/files --delete
  
  printf "********* END Processing $dir *********!\n"
done

# all databases upload to S3
printf "Syncing database backups to S3...\n"
/usr/local/bin/aws s3 sync $PREFIX/$LOCALDBBACKUPDIR s3://$S3DBBACKUPDIR --delete
