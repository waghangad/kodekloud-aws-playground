# KodeKloud AWS Playground

This repository provides automation scripts and workflows to set up an AWS Playground environment with Terraform and GitHub Actions.

---

## 🚀 Prerequisites
- An active AWS Playground account
- AWS Access Key and Secret Access Key
- AWS CLI and kubectl installed locally
- GitHub Actions enabled for this repository

---

## 📦 Setup Instructions

1. **Create AWS Credentials**
   - Generate an **Access Key** and **Secret Access Key** in your AWS Playground account.
   - Store them securely (e.g., GitHub Secrets for CI/CD).

2. **Provision State Management**
   - Create an **S3 bucket** to store Terraform state files.
   - Create a **DynamoDB table** for state locking.
   - Use the CloudFormation template located at:
     ```
     scripts/cloudformation.yml
     ```

3. **Update AWS Auth Config**
   - Replace the placeholder AWS Account ID in:
     ```
     scripts/aws-auth-cm.yml
     ```

4. **Trigger EKS Cluster Workflow**
   - From GitHub Actions, use **Workflow Dispatch** to trigger the **Create EKS Cluster** workflow.
   - This will provision:
     - An **EKS Cluster**
     - A **Node Group**

5. **Connect to EKS Cluster**
   - Once the cluster and node group are created, configure your local CLI:
     ```bash
     aws eks update-kubeconfig --region us-east-1 --name demo-eks
     ```
   - This updates your kubeconfig file so you can interact with the cluster using `kubectl`.

---
# 🛠 Step-by-Step Installation Guide for Karpenter

This guide explains how to install and configure **Karpenter** on an AWS EKS cluster to enable dynamic node provisioning.

---

## 1. Prerequisites
- An existing **EKS cluster** (v1.27+ recommended).
- `kubectl` and **AWS CLI** configured.
- **Helm** installed locally.
- OIDC provider enabled for your cluster:

```bash
eksctl utils associate-iam-oidc-provider \
  --cluster demo-eks \
  --region us-east-1 \
  --approve
```

---

## 2. Create IAM Role for Karpenter
Karpenter requires permissions to launch EC2 instances.

```bash
eksctl create iamserviceaccount \
  --cluster demo-eks \
  --region us-east-1 \
  --name karpenter \
  --namespace karpenter \
  --attach-policy-arn arn:aws:iam::aws:policy/AmazonEKSClusterPolicy \
  --attach-policy-arn arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy \
  --attach-policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly \
  --approve
  ```

  ---

## 3. Install Karpenter via Helm
  Add the Karpenter Helm repo and install:

`helm repo add karpenter https://charts.karpenter.sh`
`helm repo update`

```bash
helm install karpenter karpenter/karpenter \
  --namespace karpenter \
  --create-namespace \
  --set serviceAccount.create=false \
  --set serviceAccount.name=karpenter \
  --set clusterName=demo-eks \
  --set clusterEndpoint=$(aws eks describe-cluster \
      --name demo-eks \
      --region us-east-1 \
      --query "cluster.endpoint" \
      --output text) \
  --set aws.defaultInstanceProfile=KarpenterNodeInstanceProfile-demo-eks
  ```

---

## 4. Define Provisioner and NodeClass
Karpenter uses Provisioner and EC2NodeClass CRDs to define scaling behavior.

Example provisioner.yaml:
```bash
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
metadata:
  name: default
spec:
  requirements:
    - key: "karpenter.k8s.aws/instance-family"
      operator: In
      values: ["t2", "t3"]
  limits:
    resources:
      cpu: 1000
  providerRef:
    name: default
```

`kubectl apply -f provisioner.yaml`

---

### ⚠️ Risks & Considerations
- IAM Permissions: Ensure the role has correct policies; missing permissions will block node provisioning.
- Instance Quotas: Karpenter may fail if your AWS account has EC2 limits.
- Cluster Autoscaler: Do not run both Cluster Autoscaler and Karpenter together.

---

### ✅ Summary
- Enable OIDC and create IAM roles.
- Install Karpenter via Helm.
- Define Provisioner and NodeClass to control scaling.
- Karpenter will now automatically launch right-sized EC2 nodes when pods are unschedulable.

