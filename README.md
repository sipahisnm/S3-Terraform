# S3-Terraform

### In this task, I created an **s3 bucket** and provide access to a text file  that we put in it.In accordance with this purpose, I created an EC2 and installed **TERRAFORM** , to use it local machine. First ,I will explain the Steps to Install Terraform on Amazon Linux.
------

## Prerequisite to Install Terraform on Amazon Linux:

- You must have Installed Amazon Linux Operating System on VM/Server.
- SSH access with sudo / root permission
- Internet access required to download the Terraform package.

## Part 1 - Install Terraform
- Launch an EC2 instance using the Amazon Linux 2 AMI with security group allowing SSH connections.

 - Connect to your instance with SSH.
```
 ssh -i "sinem-aws.pem" ec2-user@ec2-44-211-222-28.compute-1.amazonaws.com 
 ```
 - Update the installed packages and package cache on your instance.

 ```
 sudo yum update -y
 ```
 - Install yum-config-manager to manage your repositories.
 ```
  sudo yum install -y yum-utils
  ```
 - Use yum-config-manager to add the official HashiCorp Linux repository to the directory of /etc/yum.repos.d.
 ```
 sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
 ```
 - Install Terraform.
 ```
 sudo yum -y install terraform
 ```
 - Verify that the installation
 ```
 terraform version
 ```

## Part 2 - Build S3 Bucket with Terraform 

- This S3 bucket will have universal read permissions, and no write permissions except for one role.
### Write first configuration
- The set of files used to describe infrastructure in Terraform is known as a Terraform configuration. You'll write your 
first configuration file to launch a single AWS EC2 instance.

- Each configuration should be in its own directory. Create a directory **("S3-Terraform")** for the new configuration and 
change into the directory.
```
mkdir S3-Terraform && cd S3-Terraform && touch main.tf
```
### Providers

- The provider block configures the name of provider, in our case aws, which is responsible for creating and managing 
resources. A provider is a plugin that Terraform uses to translate the API interactions with the service. A provider is 
responsible for understanding API interactions and exposing resources. Because Terraform can interact with any API, you can 
represent almost any infrastructure type as a resource in Terraform.

- The profile attribute in your provider block refers Terraform to the AWS credentials stored in your AWS Config File, which 
you created when you configured the AWS CLI. HashiCorp recommends that you never hard-code credentials into *.tf 
configuration files.
- I used an AWS credentials file to specify my credentials. 
- The default location is **$HOME/.aws/credentials** on Linux
- I configure my credential with this 
```
aws configure
```
- The **profile** attribute will matching **AWS_PROFILE** environment variable
- I used **profile** attribute in provider.tf file
```
provider "aws" {
  region = var.region
  profile = var.profile
}
```
### Resources
- The resource block defines a piece of infrastructure. A resource might be a physical component such as an EC2 instance.

- The resource block must have two **required** data for EC2. : the **resource type** and the **resource name**. In the 
example, the resource type is aws_instance and the local name is tf-ec2. The prefix of the type maps to the provider. In our 
case "aws_instance" automatically tells Terraform that it is managed by the "aws" provider.
- I created 7 resources for this purpose
   * S3 bucket [aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
     ```
      resource "aws_s3_bucket" "example" {
        bucket = var.bucket_name
         }
      ```
   * S3 bucket policy [aws_s3_bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy)
     ```
      resource "aws_s3_bucket_policy" "allow_read_access" {
        bucket = aws_s3_bucket.example.id
        policy = "${file("s3bucketpolicy.json")}"
      }
     ```
   * IAM Role [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)
     ```
        resource "aws_iam_role" "s3_access_role" {
          name               = var.role_name
          assume_role_policy = "${file("iamrole.json")}"
        }
      ```
   * IAM Policy [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)
      ```
       resource "aws_iam_policy" "policy" {
          name        = var.policy_name
          description = "A test policy"
          policy      = "${file("iampolicy.json")}"
             }
       ```     
   * Attacment [aws_iam_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment)
       ```
       resource "aws_iam_policy_attachment" "test-attach" {
         name       = var.attachment
         roles      = ["${aws_iam_role.s3_access_role.name}"]
         policy_arn = "${aws_iam_policy.policy.arn}"
        } 
       ```

   * S3 object [aws_s3_object](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object)  (I created 2 object )
       ```
          resource "aws_s3_object" "examplebucket_object" {
             key    = "/sinem.txt"
             bucket = aws_s3_bucket.example.id
             source = "sinem.txt"
             content_type  = "text/html"
             #acl = "public-read" # if we want to make read permission only for some objetc in the bucket we can use inline acl

            }
        ```    
   
- Go to the **S3-Terraform** directory and run the terraform comment
 ```
 terraform init
 ```
 ```
 terraform plan
 ```
 ```
 terraform apply
 ```
 - In the terminal you will see the endpoint for bucket and object you can run this comment to see the file
 ```
 curl example-sinem.s3.amazonaws.com/sinem.txt
 ```
        