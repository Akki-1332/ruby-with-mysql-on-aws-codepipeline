
# Task Description :

- Create custom VPC with 2 subnets Private and Public.
- Upload ruby on rails application using MySql database on Github.
- Launch Frontend Application in Public subnet and MySQL Database in Private subnet.
- Use CodePipeline to deploy Application.

---

Let's see how we can achieve it...

## Step 1 :
## Launching infrastructure on AWS

> Install AWS cli and configure it.

Insall [aws cli](https://aws.amazon.com/cli/) and configure it with the user credentials with suitable IAM role. ( In my case Power User Access )

AWS credentails will be used by Terraform to launch infrastructure.

> Install [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) in your system

In now go to Terraform Directory ( ruby-with-mysql-on-aws-codepipeline/terraform/custom_vpc/ ).

I have explained everything related to terraform there.

```sh
READ ALL THE INSTRUCTIONS AND RUN ALL THE REQUIRED COMMANDS ACCORDINGLY.
```
Now we have `VPC with 2 subnets (public and private)` 

- Now launch two instances ( Amazon linux 2 AMI )
    - One in `public subnet for frontend`
    - Second in `private subnet for MySQL Database`.
- Note:- We won't be having public connectivity to MySQL DB instance, so we'll need to `SSH` to public instance in order to connect to DB instance. 

_Complete rails application code is uploaded on this repo itself._

---

## Step 2 :
## Configuring MySQL database

Login (SSH) to public subnet instance (Frontend instance) then login to private instance (DB instance) with it's private IP.

![Instances](./images/Screenshot%20from%202022-06-24%2013-35-51.png "Frontend and DB Instances")

Login to DB instance from Frontend instance.

```sh
ssh -i "key.pem" ec2-user@private-ip
```
`key.pem` is the private key file to `SSH` into server.<br>
`private-ip` is the private ip of DB instance.

Now Run these commands :

```sh
sudo yum install https://dev.mysql.com/get/mysql80-community-release-el7-5.noarch.rpm -y
sudo amazon-linux-extras install epel -y
sudo yum -y install mysql-community-server
sudo systemctl enable --now mysqld
sudo grep 'temporary password' /var/log/mysqld.log
sudo mysql_secure_installation -p
```
After MySQL installation, we'll be creating a new user and will provide permissions to it.

```sh
mysql --user=root --password=root_password (setup during Installation)

CREATE USER 'akki'@'localhost' IDENTIFIED BY 'Akki@1234';
GRANT ALL PRIVILEGES ON *.* TO 'akki'@'localhost' WITH GRANT OPTION;
CREATE USER 'akki'@'%' IDENTIFIED BY 'Akki@1234';
GRANT ALL PRIVILEGES ON *.* TO 'akki'@'%' WITH GRANT OPTION;
ALTER USER 'akki'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Akki@1234';
ALTER USER 'akki'@'%' IDENTIFIED WITH mysql_native_password BY 'Akki@1234';
FLUSH PRIVILEGES;
```

Here a general user `akki` with password `Akki@1234` will be created.

---

## Step 3 :
## Configuring Frontend 

For the **Frontend** part we'll be using `aws codepipeline`.<br>
In order to use `codepipeline` we will setup `codedeploy` first.

- Navigate to **Applications** on _codedeploy_ page.<br>
- click on `create application`
- Give a suitable name and choose `EC2/On-premise` as Compute platform.

![Code Deploy Application](./images/Screenshot%20from%202022-06-24%2013-59-00.png "Create a new codedeploy Application")

> In order to move further, we'll need to create `IAM Roles`.

- Navigate to roles on IAM page.
- click `create role`.
- Select `AWS service` as **Trusted entity type**.

![Code Deploy Role](./images/Screenshot%20from%202022-06-24%2014-07-12.png "Create a new role which gives power to codedeploy to access ec2 services")

- Select `codedeploy` as **Use cases for other AWS services**.

![Code Deploy Role Permissions](./images/Screenshot%20from%202022-06-24%2014-07-34.png "Create a new role which gives power to codedeploy to access ec2 services")

- On the next page `permissions` will be automatically selected.
- On the next page give any suitable name for the role like _codedeploy-role-power-to-ec2_ etc.
- and then create role.

## Deployment Group

Now we'll be having a new codedeploy application, navigate to `Create Deployment Group` on the application page.

- Enter a deployment group name.
- Select the above created role as service role.
- choose `In-place` Deployment type.
- select `Amazon EC2 instances` as `Environment configuration`.
- Provide key-value to select the frontend instance.
- we can disable load balancing part as of now.
- we can leave rest of the things in default state.

![Code Deploy Deployment Group](./images/Screenshot%20from%202022-06-24%2014-21-01.png "Create a new deployment group.")

![Code Deploy Deployment Group](./images/Screenshot%20from%202022-06-24%2014-22-46.png "Create a new deployment group.")

```sh
Before creating deployment we need to setup codedeploy agent in our frontend instance also we will need to asign a role to it.
```

## Create new IAM role for frontend instance to connect with codedeploy.

- create a new role on IAM page.
- choose `aws service` as **Trusted entity type**
- choose `ec2` as **Common use cases**
- choose `AmazonEC2RoleforAWSCodeDeploy` policy.
- provide a suitable name to role like _ec2_codedeployrole_custom_.
- OR, we can use given policy to create the same rule.
```sh
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:ListBucket"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
```

## Attach role to frontend instance.

- Navigate to ec2 page.
- select `frontend instance` and modify IAM role.

![Modify IAM role](./images/Screenshot%20from%202022-06-24%2014-49-21.png "Modify IAM role.")

- select above created role and save it. 

![Modify IAM role](./images/Screenshot%20from%202022-06-24%2014-54-29.png "Modify IAM role.")

## Configure codedeploy agent in frontend instance.

- SSH to frontend instance.
RUN :

```sh
sudo yum update -y
sudo yum install -y ruby wget
wget https://aws-codedeploy-ap-south-1.s3.ap-south-1.amazonaws.com/latest/install
# link above varies region to region.
chmod +x ./install
sudo ./install auto
sudo service codedeploy-agent status
```

## Deployment

Now navigate to Deployment group page, it's time to create deployment.

- Click on `create deployment`
- Choose the deployment group.
- Choose `My application is stored in GitHub` as `Revision type`
- Provide any name as `GitHub token name` and then `Connect to GitHub`
- Choose Repository name (Akki-1332/ruby-with-mysql-on-aws-codepipeline) and latest commit id (e7aa208e2f358820752d62ad2368f781d0f56fb5).

![Deployment](./images/Screenshot%20from%202022-06-24%2014-29-22.png "Create a new deployment")

- Save it and Deployment will start.

```sh
Codedeploy uses `Appspec.yml` file to configure anything on selected host. In the Appspec file i have given specified the path of scripts.
Scripts are stored in `scripts` folder.<br>
These scripts are going to install all the dependencies and will start the server automatically on port 3000.
```

Once the deployment succeed. We can move to final stage of creating `code pipeline`.

## Step 3 :
## Configuring code pipeline

- Navigate to codepipeline page and click on `create pipeline`.
- Give a suitable name to pipeline.
- Select `New Service Role` option for service role.
- Enter a unique role name.
- In `Advanced settings` choose `default location` as `artifact store`.
- On the Next page select `Github (version 1)` as source provider.
- Click on `connect to github` and allow it.
- Now look for the repository (In my case [repository](Akki-1332/ruby-with-mysql-on-aws-codepipeline))
- Choose `GitHub webhooks (recommended)` as `Change detection options`

![Code Pipeline Source Code Provider](./images/Screenshot%20from%202022-06-24%2016-21-51.png "Code Pipeline Source Code Provider")

- On next page `Skip Build Stage` as it's not required.
- Now choose `AWS Codedeploy` as `Deploy Provider`
- Now choose `Region`, `Application` and `Deployment Group` and then click next, now review it and create Pipeline.

Now CodePipeline will run automatically as soon as the code changes on Github. <br><br>

---

# **Thank You**

I hope you find it useful. If you have any doubt in any of the step then feel free to contact me.
If you find any issue in it then let me know.

<!-- [![Build Status](https://img.icons8.com/color/452/linkedin.png)](https://www.linkedin.com/in/choudharyaakash/) -->


<table>
  <tr>
    <th><a href="https://www.linkedin.com/in/choudharyaakash/"><img src="https://img.icons8.com/color/452/linkedin.png" alt="linkedin" width="30"/><a/></th>
    <th><a href="mailto:choudharyaakash316@gmail.com"><img src="https://img.icons8.com/color/344/gmail-new.png" alt="Mail" width="30"/><a/>
</th>
  </tr>
</table>
