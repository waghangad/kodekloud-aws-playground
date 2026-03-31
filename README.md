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
  --cluster <your-cluster-name> \
  --region <your-region> \
  --approve

## 2. Create IAM Role for Karpenter
Karpenter requires permissions to launch EC2 instances.

```bash
eksctl create iamserviceaccount \
  --cluster <your-cluster-name> \
  --region <your-region> \
  --name karpenter \
  --namespace karpenter \
  --attach-policy-arn arn:aws:iam::aws:policy/AmazonEKSClusterPolicy \
  --attach-policy-arn arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy \
  --attach-policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly \
  --approve
