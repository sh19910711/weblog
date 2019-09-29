echo start
echo 'show databases;' | mysql -hdatabase.homepage2 -uroot -pmysql
echo 'create database homepage;' | mysql -hdatabase.homepage2 -uroot -pmysql
echo "create user homepage identified by 'homepage';" | mysql -hdatabase.homepage2 -uroot -pmysql
aws s3 cp s3://hiroyuki.sano.ninja/tmp/mysql/dump.sql.gz - | zcat | mysql -hdatabase.homepage2 -uroot -pmysql homepage
echo 'grant select on homepage.* to homepage;' | mysql -hdatabase.homepage2 -uroot -pmysql homepage
echo 'grant update on homepage.* to homepage;' | mysql -hdatabase.homepage2 -uroot -pmysql homepage
echo end
echo 'show databases;' | mysql -hdatabase.homepage2 -uroot -pmysql
