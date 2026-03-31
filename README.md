# kodekloud-aws-playground

1. Once AWS Playground account is ready, create Access Key and Secrete Access Key.
2. Create AWS S3 bucket to store Terraform state file and AWS DynamoDB table for lock.
3. Use AWS CloudFormation template present at path `scripts/cloudformation.yml` to create S3 bucket and DynamoDB table.
4. Update new AWS Account ID in `scripts/aws-auth-cm.yml`
5. Trigger Create EKS Cluster workflow from GitHub Actions Workflow Distpatch.
6. Once EKS cluster and Node Group created.To connect EKS cluster from CLI use below command.
   `aws eks update-kubeconfig --region us-east-1 --name demo-eks`