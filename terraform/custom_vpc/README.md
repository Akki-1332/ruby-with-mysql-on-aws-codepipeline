# Terraform 

Till now you have already install `aws cli` and `terraform` in your system.

Now it's time to launch infrastructure with the help of Terraform.

What terraform is going to perform :

- Create a new `VPC`
- Create `2 subnets`
- Create `Internet Gateway` and `Nat Gateway`
- Create 2 `Routing Tables`
- Associate `Routing Tables` to `Subnets` to make them `Public` and `Private` subnets.

## Step 1 :
## Login to AWS cli

- create a aws profile with `aws` command. We'll require `Access Key` and `Secret Key` with the powers required for it. ( I've choosed `power user access` policy for my user ).

```sh
aws configure --profile akki
```
- It's gonna ask for `Access Key`, `Secret Key` , `Default Region`  and  `Default output format`

- OR
    - You can directly provide credentials to the file.

``` sh
vim  ~/.aws/credentials
```

- Provide credentails like this :

```sh
[default]
aws_access_key_id=AKIAIOSFODNN7EXAMPLE
aws_secret_access_key=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

[akki]
aws_access_key_id=AKIAI44QH8DHBEXAMPLE
aws_secret_access_key=je7MtGbClwBF/2Zp9Utk/h3yCo8nvbEXAMPLEKEY
```

- Once AWS configuration is done. we can move to second step.

## Step 2:
## Lauch infrastructure

- Make sure, you are in `terraform/custom_vpc` directory and `terraform` is installed properly and you have set it in `PATH`.
- Open `provider.tf` file and update `profile` name. ( Provide your AWS profile name )
- Now open `variable.tf` file and update the `default` value of the variables, if required.
- Once you have done the above mentioned points. RUN

```sh
terraform init
terraform plan
terraform apply
```

After approving terraform, your infrastructure will be launched on the AWS accout in the region defined in your `variable.tf` file.

- In case you want to delete the launched infrastructure, Don't try to do it manually rather than that RUN :

```sh
terraform destroy
```

---

# **Thank You**

I hope you find it useful. If you have any doubt in any of the step then feel free to contact me.
If you find any issue in it then let me know.

<!-- [![Build Status](https://img.icons8.com/color/452/linkedin.png)](https://www.linkedin.com/in/choudharyaakash/) -->


<table>
  <tr>
    <th><a href="https://www.linkedin.com/in/choudharyaakash/" target="_blank"><img src="https://img.icons8.com/color/452/linkedin.png" alt="linkedin" width="30"/><a/></th>
    <th><a href="mailto:choudharyaakash316@gmail.com" target="_blank"><img src="https://img.icons8.com/color/344/gmail-new.png" alt="Mail" width="30"/><a/>
</th>
  </tr>
</table>
