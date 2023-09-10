# Log in to EC2 instance using Session Manager

## Usage
```sh
$ terraform plan
$ terraform apply
$ aws ssm start-session --target $(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=hello" "Name=instance-state-name,Values=running"\
    --query 'Reservations[].Instances[].[InstanceId]' \
    --output text
)
```
