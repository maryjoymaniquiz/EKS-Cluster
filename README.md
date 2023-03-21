# EKS-Cluster

Deploying of module to spin up an EKS cluster in AWS using Terraform.

<b> Prerequisites </b>
 
    Terraform 
    
    AWS account with IAM permissions

    Kubectl 
    
<b> eks.tf </b> - It creates the EKS cluster with the roles attached to it, as well as the VPC configuration with the private and public subnets that are part of the network,tf.

<b> iam.tf </b> - It contains IAM roles and IAM policies that will be used in nodes.tf to create instances.

<b> main.tf </b> - It only contains the AWS provider where we will deploy the EKS.

<b> network.tf </b> - It creates security groups, public and private subnets, NAT and NAT gateways, route tables, and route table associations.

<b> nodes.tf </b> It includes the creation of three instances that will be part of the eks cluster; the instance type is t2.micro, and it is determined by the policies that are created. 


Once assuming Role is done, use terraform init command to initialize modules, backend and provider plugins
    
    terraform init

Use terraform apply command to execute the action. It is used to deploy your module

    terraform apply
    
> Enter yes to perform the actions that are shown in the terraform plan.

> To check if it has been successfully deployed, go to your AWS account and make sure that you are in the right region and role.

> Go to Elastic Kubernetes Service 

Install kubectl binary with curl on Linux if it  wasn’t installed yet

Download the latest release with the command:
    
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    
<b> Note: </b> To download a specific version, replace the $(curl -L -s https://dl.k8s.io/release/stable.txt) portion of the command with the specific version.

For example, to download version v1.26.0 on Linux, type:
    
    curl -LO https://dl.k8s.io/release/v1.26.0/bin/linux/amd64/kubectl

Download the kubectl checksum file using:
    
    curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

Install kubectl using the command:

    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl


To install and configure the kubectl in use the following AWS command

    eks –region <region> update-kubeconfig \ --name <eks-cluster-name>

To get the working nodes use the following command
    
    kubectl get nodes
    
    
    
