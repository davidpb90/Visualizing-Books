# Set up AWS

## Create account

Free Tier

## Create PostgreSQL RDS instance

https://aws.amazon.com/getting-started/tutorials/create-connect-postgresql-db/

## Upload Files to S3

## Create EC2 instance 

# Set up PostgreSQL

## SSH to EC2 instance

## Install aws cli

- Install python: apt get install python

- Install pip: 
https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-install-linux.html

curl -O https://bootstrap.pypa.io/get-pip.py

python get-pip.py --user

Add the executable path, ~/.local/bin, to your PATH variable:

$ ls -a ~ //To get name of PROFILE_SCRIPT (.profile)
Bash – .bash_profile, .profile, or .bash_login.
export PATH=LOCAL_PATH:$PATH
$ source ~/PROFILE_SCRIPT

- Install aws clis:

https://docs.aws.amazon.com/cli/latest/userguide/installing.html

$ pip install awscli --upgrade --user

## Configure aws cli

1. SSH to EC2 instance

2. https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html

In Terminal: 
$ aws configure
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-west-2
Default output format [None]: json

## Download S3 files to EC2 instance

https://stackoverflow.com/questions/20257226/how-to-import-data-files-from-s3-to-postgresql-rds

1. SSH into EC2 instance
2. In terminal:
$ aws s3 cp s3://bucket/file.csv /mydirectory/file.csv

## Download psql

1. SSH into EC2 instance
2. https://github.com/snowplow/snowplow/wiki/Setting-up-PostgreSQL
In Terminal:
$ sudo apt-get install postgresql

## Connect to PostgreSQL DB instance

https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ConnectToPostgreSQLInstance.html

$ psql \
   --host= \
   --port=5432 \
   --username=### \
   --password \
   //--dbname=

## Create table

https://www.digitalocean.com/community/tutorials/how-to-create-remove-manage-tables-in-postgresql-on-a-cloud-server

BookVis => CREATE TABLE final_around_the_world (
	id int PRIMARY KEY,
	gutenberg_id int,
	title varchar(100),
	chapter int,
	word varchar(25),
	pos varchar(25),
	token_id varchar(25),
	sentiment varchar(25),
	sentiment_bin varchar(10),
	freq_chapter int,
	topic int,
	freq_book int
);

https://stackoverflow.com/questions/20257226/how-to-import-data-files-from-s3-to-postgresql-rds
	
BAD

psql -h host_name -U user_name  -c '\COPY final_around_the_world FROM ''final_around_the_world.csv'' WITH NULL AS "NA" CSV HEADER' 

https://stackoverflow.com/questions/26451166/how-to-deal-with-missings-when-importing-csv-to-postgres

GOOD

psql -h host_name -U user_name  -c '\COPY final_around_the_world FROM ''final_around_the_world.csv'' WITH (FORMAT CSV, NULL "NA",  HEADER)'

//"" Around NA did the trick!!!



















