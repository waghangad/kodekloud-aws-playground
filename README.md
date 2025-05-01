# kodekloud-aws-playground

1. Once AWS Playground account is ready, create Access Key and Secrete Access Key.
2. Create S3 buckets and DynamoDB tables.
   Bucket Name:  tf-state-eks-bucket-321
   Bucket Name:  tf-state-gen-bucket-321
   DynamoDB Table Name:  tf.lock
   Partition Key: LockID



  aws s3api create-bucket --bucket tf-state-eks-bucket-321 --region us-east-1

  aws s3api create-bucket --bucket tf-state-gen-bucket-321 --region us-east-1

  aws dynamodb create-table --table-name tf.lock --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
