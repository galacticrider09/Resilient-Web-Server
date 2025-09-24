Resilient Web Server which can auto heal and expand itself. 
Using AWS CloudFormation. 

Task 1 :
1.1 : create a public S3 bucket which holds the index.html file.
      <img width="1145" height="535" alt="Screenshot 2025-09-24 at 11 09 21 AM" src="https://github.com/user-attachments/assets/b57a7b45-790f-4dd3-a973-ab68918ca103" />
      The database stack was created using the aws clf and /database.yaml template was used.
      <img width="1441" height="312" alt="Screenshot 2025-09-25 at 1 48 31 AM" src="https://github.com/user-attachments/assets/16d6106b-e4bb-48be-87eb-1c4d3a78d180" />
      This S3 bucket was created.
      <img width="745" height="252" alt="Screenshot 2025-09-24 at 11 22 36 AM" src="https://github.com/user-attachments/assets/d7275a0d-3fa7-4c6d-b54f-3b7b35a57b89" />
      Bucket policy.

1.2 : Connect it to an sns topic and configure it to send updates when an object is uploaded in the S3 bucket.
      notification.yaml template was used to create and connect the sns topic to the S3.
      You get an sns subscription confirmation email just after creating this stack.
      <img width="387" height="401" alt="Screenshot 2025-09-24 at 11 32 34 AM" src="https://github.com/user-attachments/assets/fcec7e22-72ac-4f41-9a47-e096072821e6" />
      This topic sends upload updates on the mail (index.html was uploaded).
      <img width="1376" height="452" alt="Screenshot 2025-09-24 at 11 54 08 AM" src="https://github.com/user-attachments/assets/d91f038a-2125-4a6a-9159-5021080e0997" />

Task 2 :Create a IAM role with S3 and CloudWatch full access.
        iamrole.yaml is the template used for this.
        <img width="1416" height="615" alt="Screenshot 2025-09-25 at 1 59 55 AM" src="https://github.com/user-attachments/assets/76c5950f-091c-4171-b833-c424f2520c06" />

Task 3 :
3.1 : Create a VPC with IGW , 3 public subnets , route table pointing the subnets to the IGW and a security group.
      This was accomplished using networking.yaml . 
      This file was created using parameters which can be changed in future to create these resources with different parameters.
      Vpc-info.json has the info of the VPC and its elements that were created.

Task 4 : Create a User data script for the EC2 launch template(commonly used for installing software or configuring services).
        user_data.sh is the User data script used in this case. It installs the httpd , aws cli and syncs the S3 to the instance.

Task 5 : Create EC2 Launch Template. 
        The EC2 instance Configs  :  - Amazon Linux ami 
                                     - T3.micro
                                     - role with s3 and cloudwatch access
                                     - User data script(created earlier)
                                     - Security group(task 3.1)
        instance-launchtemp.yaml does the work.
        <img width="1487" height="519" alt="Screenshot 2025-09-25 at 2 30 46 AM" src="https://github.com/user-attachments/assets/ca9a5f8d-d703-4a2f-817c-40fef44bb236" />

Task 6 : Create auto scaling group with 2 initial instances scale out to 5 if needed, with all 3 subnets selected in the project VPC.
        auto-scaling-group.yaml after this stack is created the ASG is configured and it creates the initial 2 instences.
        <img width="1492" height="209" alt="Screenshot 2025-09-24 at 3 35 24 PM" src="https://github.com/user-attachments/assets/cff12e95-68e3-497a-aa2b-76e5ff5f2eab" />  

Task 7 : Create SNS topic which sends the auto scaling group status updates on specified email.
         sns-instance-updates.yaml 
         <img width="1381" height="607" alt="Screenshot 2025-09-25 at 12 58 42 AM" src="https://github.com/user-attachments/assets/439c7340-687a-41f1-8694-710f52ebbd9c" />
         this sends updates like these on email.

Task 8 : Create Classic Load Balancer configs :  - Public
                                                 - Project Vpc selected
                                                 - with all subnets in that vpc selected
                                                 - Security Group(task 3.1)
                                                 - Add CLB to auto scaling group
        classic-load-balancer.yaml is the template to create this stack.

  we have to update the ASG stack with this CLB arn for this to work.

  <img width="1479" height="714" alt="Screenshot 2025-09-25 at 2 46 31 AM" src="https://github.com/user-attachments/assets/86067712-49a0-4e77-a5ca-5341aa2c2849" />




TESTING : - 


test 1 : Test to check if we get 2 different servers providing output

<img width="1310" height="496" alt="Screenshot 2025-09-25 at 1 17 11 AM" src="https://github.com/user-attachments/assets/ea50f89d-fd65-4bff-ad49-4cf2a90b2325" />
site 1 with different server and ip.

<img width="1236" height="354" alt="Screenshot 2025-09-25 at 1 17 18 AM" src="https://github.com/user-attachments/assets/2f37b62a-351e-47e3-b2a7-a00cb572c511" />
site 2 with different server and ip.


test 2 : Increase CPU utilisation of the instances to check if the new instance gets created.
<img width="1508" height="394" alt="Screenshot 2025-09-25 at 1 23 28 AM" src="https://github.com/user-attachments/assets/d77a319a-055e-40e3-9e48-bfaff103d34b" />
increased the cpu utilisation to 100% .
<img width="1437" height="448" alt="Screenshot 2025-09-25 at 1 32 44 AM" src="https://github.com/user-attachments/assets/daf493ca-80d6-45cd-926c-5127ed2bb5f1" />
average CPU utilisation of 3 instances. 
<img width="1488" height="154" alt="Screenshot 2025-09-25 at 1 30 15 AM" src="https://github.com/user-attachments/assets/911a4a74-20a8-43e2-9044-20a1463eedca" />
New instance was initialised and created.


Thanks for reading.


        
