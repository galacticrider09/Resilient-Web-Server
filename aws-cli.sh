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

