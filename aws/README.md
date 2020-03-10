# Lacework for AWS
The following are the manual steps to connect an AWS account into Lacework

### Step 1: Create CloudTrail Trail
From the AWS console select “CloudTrail”
From the left navbar select “Trails” and then the blue  “Create Trail” button
Enter a trail name
NOTE: Is is an AWS security best practice to apply trail to all regions
From the “Storage location” section at the bottom of the page
Select to create a new S3 bucket of use an existing bucket
Create new SNS Topic and enter a topic name
Click blue “Create” button on the bottom right of the page

### Step 2; Create SQS Queue
From AWS console go to the Simple Queue Service(SQS)
Click the blue “Create New Queue”
Enter queue name
Standard Queue type is fine
Click blue “Quick-Create Queue” from bottom right of page
From the SQS queue list click to select the new queue you’ve created and then click the grey “Queue Actions” button and select “Subscribe Queue to SNS Topic”
Choose the SNS Topic created with the CloudTrail trail

### Step 3: Create IAM (Cross-Account)Role (Enhance for govcloud)
From the AWS console go to Services > Security, Identity, & Compliance > IAM. The Welcome to Identity and Access Management page
From the left nav bar select “Roles” which will display the IAM Roles
Select the Blue “Create Role” button
You will have the choice of 4 types of Trusted Entities. Select “Another AWS Account”
(More info on this role type can be found here >> https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-user_externalid.html?icmpid=docs_iam_console)
		From here you will need the following
The AWS account ID that is using the cross account role
This is the Lacework AWS caller account ID
434813966438
Under “Options” click in the box to enable “Require external ID (Best practice when a third party will assume this role)”
Create an External ID
