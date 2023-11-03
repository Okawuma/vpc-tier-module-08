# vpc-tier-module-08
stands a 3-tier VPC with NAT,ASG,SG,ALB,and NLB.
+ https://github.com/Mozenty/vpc-tier-module-08
# Project name: 
## Using Terraform and Jenkins to automate the provisioning of a basic 3 Tier AWS Virtual Private Cloud (VPC).
### Project objectives:
+ Infrastructure as code: Use of terraform to define a VPC and its components; ensures repeatability and version control.
+ High Availability: VPC resources are designed to be highly available across multiple Availability Zones.
+ CI/CD Integration: The infrastructure is integrate with CI/CD pipelines, i will use Jenkins.
+ Security: Security Groups for EC2, Network ACLs for subnet level,VPN or Direct Connect for secure access from on-prem resources.
    + storing of state file in s3 and locking it using a dynamo-db table.
+ Scalability: The architecture has auto-scaling groups, load balancers.
    + possibly even multi-region support for future growth.
+ Cost-Efficiency: Cost-saving measures like reserved instances for resources that are continously running or spot instances for statelss apps.
+ Monitoring and Logging: Implementation of AWS CloudWatch, CloudTrail, and possibly third-party solutions like datadog, splunk.
### Steps taken:
+ First, please see reference to the architecture.
[https://github.com/Mozenty/vpc-tier-module-08/blob/main/vpc.drawio.png]
### create the vpc main.tf file and the varaibles.tf side by side
### Inside the main.tf file, create the following resources:
#### - create the vpc.
#### - create internet gateway and attach it to the vpc
## Inside the variables file

1. use data source to get a list of all availability zones in prefered regions.
2. create public subnet in az1 (all AZs are indexed [0,1])
3. create public subnet in az2
4. create route table and add a public route
5. associate public subnet az1 to the "public route table"
6. associate public subnet az2 to the "public route table"
7. create a private application subnet in az1
8. create a private application subnet in az2
9. create a private database subnet in az1
10. create a private database subnet in az2

####  (review the main.tf file code and save)
####  On the other hand, create variables as follows;
#### - for the region and project_name.
#### - create variable for the public_subnet_az1_cidr
#### - create variable for the public_subnet_az2_cidr
#### - create variable for the private_app_subnet_az1_cidr
#### - create variable for the private_app_subnet_az2_cidr
#### - create variable for the private_db_subnet_az1_cidr
#### - create variable for the private_db_subnet_az2_cidr
##### (review the variable file code and save)
## Develop the output.tf file 
(this allows us to export some values from this vpc, and we can reference them when we create other resources)
### The first output will export our region.
#### - export the project name
#### - export the vpc id as referenced in the main.tf file
#### - export the id of the public_subnet_az1
#### - export the id of the public_subnet_az2
#### - export the id of the private_app_subnet_az1
#### - export the id of the private_app_subnet_az2
#### - export the id of the private_db_subnet_az1
#### - export the id of the private_db_subnet_az2
### create a reference for the internet_gateway in the output file.
              output "aws_internet_gateway" { 
                     value = aws_internet_gateway.igw-interview 
                            } # no id is needed.
### reference the created vpc module above in another project if necessary.
*  This will demonstrate the re-usability of terraform modules
* The ease of application and replication that Iac i terraform gives
#### I created another folder called(appleSCH-website).
#### The appleSCH-website project will store its terraform state file in an s3.
### - configure aws provider for the apple-sch-website project.
####  I opened a backend.tf file in the project folder for the state file
#### - Log into the Amazon console and create an s3 bucket.
#### - Enter the bucket name, key, region and profile in the backend.tf file.
#### - Its possible to enable state locking using a dynamoDB. 
+ This prevents multiple team members from applying changes simultaneously, which could result in an inconsistent or corrupt state.
+ Reduce the risk of state corruption that could occur if multiple write operations happen concurrently.
+ Locking adds an extra layer of protection against unintended modifications, helping ensure that critical resources are not accidentally destroyed or altered.
+ Good for auditing changes and understanding sequence of events incase of troubleshooting.
#### - create vpc for the appleSCH-website project
#### - reference the vpc module already created under the interview project folder
#### (double period takes one up two directories)
#### - list all variables for the vpc
#### - create the terraform.tfvars file

Enter the values for your vpc according to there keys.
## Set up of my Jenkins server for the terraform pipeline.
### Jenkins Installation And Setup In AWS EC2 ubuntu Instance.
##### Prerequisite
+ AWS in Acccount.
+ Created an Amazon-Linux EC2 t2.medium Instance with 4GB RAM.
+ Create Security Group and open Required ports.
   + 8080 for Jenkins and 80 for ssh.
+ Attach Security Group to EC2 Instance.
+ Install java openJDK openjdk-11-jdk
##### Script for Jenkins Installation
              #!/bin/bash
       sudo yum update -y # Update software packages on the ec2.
       #Add Jenkins repo
       sudo wget -O /etc/yum.repos.d/jenkins.repo \
           https://pkg.jenkins.io/redhat-stable/jenkins.repo
       #Import a key file from Jenkins-CI to enable installation from the package 
       sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
       # upgrade system packages once more
       sudo yum upgrade -y
       # Installation of Java (Amazon Linux 2)
       sudo amazon-linux-extras install java-openjdk11 -y
       # Install Java (Amazon Linux 2023):
       sudo dnf install java-11-amazon-corretto -y
       # install jenkins
       sudo yum install jenkins -y
       # Enable the Jenkins service to start at boot
       sudo systemctl enable jenkins
       # Start Jenkins as a service
       sudo systemctl start jenkins 
       # check the status of the Jenkins service using the command
       sudo systemctl status jenkins
###### End of Jenkins installation.
#### Install terraform binary in Jenkins using script below;
            #!/bin/bash
    sudo yum update
    sudo yum install -y curl unzip
    curl -LO https://releases.hashicorp.com/terraform/1.5.6/terraform_1.5.6_linux_amd64.zip
    unzip terraform_1.5.6_linux_amd64.zip
    sudo mv terraform /usr/local/bin/
    echo "1.5.6. is the latest Terraform version as @ June/2023"
    terraform version
##### Obtain initial password of jenkins using the code below:
      [ec2-user@jenkins ~]$ cat /var/lib/jenkins/secrets/initialAdminPassword
##### create first admin user for jenkins UI.
Name : otillia
+ p/w for : otillia user.
+ login and download suggested plugins.
+ Besure to download the Terraform plugin as well, to aid in the terraform & jenkins integration.
+ Create and attach IAM roles with the policies listed belowa to the Jenkins EC2 instance in AWS.
###### Policies included in the IAM role:
+ i) AmazonEC2FullAccess
+ ii) AmazonS3FullAccess
+ ii) AmazonDynamoDBFullAccess
#### Create the jenkins pipeline job using script below.
