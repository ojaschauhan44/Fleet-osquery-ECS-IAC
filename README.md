# Osquery New Deployment for Tide Infrastructure

Follow the following steps to deply OSQuery

Download updated files from s3 bucket :[**S3 Bucket**](https://osquery-tide.s3.eu-west-2.amazonaws.com/Installation+files/)

   ## Windows

    Directly install the osquery package with admin privileges.         
    On Success (Check if osquery/logs folder is created in program files)


   ## Linux/Ubuntu

    Command : ```sudo dpkg -i osquery.deb```       
    On success check if ```/var/logs/osquery``` has been created

   ## MacOS

    Command (root user) : ```installer -pkg osquery.pkg -target /```
    On success check if ```/var/logs/osquery has been created```



##### And VOILA!! The host should appear in fleet server. Give it few minutes to sync up and you will be able to query the host normally.
test
