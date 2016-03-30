# Create backups of multiple wordpress sites on your server offline to Amazon S3 without using a plugin

# Requirements

- Have an Amazon S3 account
- wp-cli needs to be installed on your server. Visit http://www.wp-cli.org for more info
- aws cli needs to be installed and configured. Visit http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html
- Need to have ssh access on the server
- For each cpanel/wordpress site that you want to back up, you need to create a corresponding bucket name on S3. This script assumes that the S3 bucket name will be same as cpanel name. If not, then you need to create a file called "s3.txt" in public_html folder of the wordpress site and add the bucket name as the content. The script will then read the bucket name from this file if needed. Note that this bucket name will only store/sync the files backup. 
- On S3, create a separate folder called "db_backups" whgich will have a backup of all databases only by date. 

# How to run the script manually

    ./backups.sh
    
Alternatively, you can add a cron job to run daily. For example, to run it at 3 AM daily, add the following cron entry:

    00 2 * * * run_backups.sh

## Future enhancements (Nice to have)

- Automatically create an S3 bucket if a new cpanel/wordpress site is added on the server. Right now, the script requires the S3 bucket to exist othewrise will fail.
- Add more exception/error handling. Right now, there isn't much
