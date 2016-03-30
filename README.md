# Create backups of multiple wordpress sites on your server offline to Amazon S3 without using a plugin

# Requirements

- Have an Amazon S3 account
- wp-cli needs to be installed on your server. Visit http://www.wp-cli.org for more info
- aws cli needs to be installed and configured. Visit http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html
- Need to have ssh access on the server

# How to run the script

## Manual option
    ./backups.sh
    
Alternatively, you can add a cron job
