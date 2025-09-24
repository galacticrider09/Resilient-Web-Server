#you need to have aws cli configured for executing any of these commands


aws cloudformation create-stack \
    --stack-name db-stack-996 \
    --template-body file://~/coding_folder/cloud-formation-templates/database.yaml\
    --capabilities CAPABILITY_IAM
#created DB stack using this command 👆


aws cloudformation create-stack \
    --stack-name noti-stack-996 \
    --template-body file://~/coding_folder/cloud-formation-templates/notification.yaml\
    --capabilities CAPABILITY_IAM
#this command creates the stack for sns notification. ☝️
#you get a sns subscription confirmation just after executing this



#After deploying this stack, you’ll still need to manually configure the existing bucket to send events to the SNS topic. Unfortunately, CloudFormation cannot fully attach a notification configuration to an existing bucket. 👉👇
aws s3api put-bucket-notification-configuration \
    --bucket project-bucket-996 \  
    --notification-configuration '{
        "TopicConfigurations": [
            {
                "TopicArn": "arn:aws:sns:ap-south-1:533266961622:noti-stack-996-MySNSTopic-AuBfYTJ4Wh7U",
                "Events": ["s3:ObjectCreated:*"]
            }
        ]
    }'

aws cloudformation create-stack \
    --stack-name iam-role-stack \
    --template-body file://~/coding_folder/cloud-formation-templates/iamrole.yaml\
    --capabilities CAPABILITY_NAMED_IAM
##this command creates the stack for iam role with ec2 and cloudwatch full access. ☝️

aws cloudformation create-stack \
    --stack-name networking-vpc-stack-996 \
    --template-body file://~/coding_folder/cloud-formation-templates/networking.yaml\
    --capabilities CAPABILITY_IAM
#created networking stack using this command 👆


aws cloudformation create-stack \
    --stack-name lauunch-template-stack-996 \
    --template-body file://~/coding_folder/cloud-formation-templates/instance-launchtemp.yaml\
    --capabilities CAPABILITY_IAM
#created launch template stack using this command 👆

aws cloudformation create-stack \
    --stack-name auto-sg-996 \
    --template-body file://~/coding_folder/cloud-formation-templates/auto-scaling-group.yaml\
    --capabilities CAPABILITY_IAM
#created  auto scaling group stack using this command 👆


#had to create something called instance profile for the role to work properly this is the cli command for that
aws iam create-instance-profile --instance-profile-name EC2-CW-fullaccess-996-project-role
aws iam add-role-to-instance-profile \
    --instance-profile-name EC2-CW-fullaccess-996-project-role \
    --role-name EC2-CW-fullaccess-996-project-role


aws cloudformation create-stack \
    --stack-name sns-asg-instance-creation \
    --template-body file://~/coding_folder/cloud-formation-templates/sns-instance-updates.yaml\
    --capabilities CAPABILITY_IAM
#created  sns updates for instance creation stack using this command 👆
#do this then i have to add a notification configerations in the auto-scaling-group.
aws cloudformation update-stack \
  --stack-name  auto-sg-996 \
  --template-body file://~/coding_folder/cloud-formation-templates/auto-scaling-group.yaml\
  --capabilities CAPABILITY_IAM
#we have to use this command to update the stack with changes
