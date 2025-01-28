# Mark's Internship Hub

Welcome to Mark's repository for managing Kubernetes clusters using Flux.

## Table of Contents

- [Introduction](#introduction)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Flux Configuration](#flux-configuration)
  - [Bootstrap Flux](#bootstrap-flux)
  - [Apply Flux YAML Files](#apply-flux-yaml-files)
- [Deployment](#deployment)
- [Helm Charts](#helm-charts)
- [Terraform Configuration](#terraform-configuration)
  - [Terraform Setup](#terraform-setup)
  - [Terraform Deployment](#terraform-deployment)
  - [Terraform Destruction](#terraform-destruction)
- [TLS Configuration](#tls-configuration)
  - [Using cert-manager](#using-cert-manager)
  - [Using acme.sh](#using-acme.sh)
- [Contributing](#contributing)
- [License](#license)

## Introduction

This repository contains the configuration and scripts to manage Kubernetes clusters using Flux. Flux is a set of continuous and progressive delivery solutions for Kubernetes that are open and extensible. The project now uses three images: web, turing-service, and prisoner-service.

## Project Structure

The project utilizes Terraform, Kubernetes/Helm charts, Flux, Github Actions. The container which runs on AKS is built in another repository

## Getting Started

### Prerequisites

- Kubernetes cluster
- kubectl installed
- Flux CLI installed
- GitHub repository

### Installation

1. Clone this repository and navigate to the project directory.

2. Install dependencies and tools as needed.

## Flux Configuration

### Bootstrap Flux

To bootstrap Flux in your Kubernetes cluster, you need to ensure that Flux is installed and configured to monitor your GitHub repository. This involves setting up Flux to use your GitHub repository as the source of truth for your cluster configuration.

### Apply Flux YAML Files

Once Flux is bootstrapped, you need to apply the Flux configuration files to your cluster. These files define the Git repository and Helm releases that Flux will manage. By applying these files, you instruct Flux to continuously monitor and reconcile the state of your cluster with the desired state defined in your Git repository.

## Deployment

The deployment process is automated using GitHub Actions. The following workflows are used:

### Helm Deploy

This workflow is triggered by changes to the Kubernetes manifests or manually via the GitHub Actions interface. It performs the following steps:

- **Checkout Code**: Checks out the code from the repository.
- **Log in to Azure**: Logs in to Azure using service principal credentials.
- **Get AKS Credentials**: Retrieves the credentials for the AKS cluster.
- **Install Flux CLI**: Installs the Flux CLI.
- **Create Namespace**: Creates the namespace for the deployment if it does not already exist.
- **Create or Update GitHub Token Secret**: Creates or updates the secret for the GitHub token in the Kubernetes cluster.
- **Create or Update ACR Secret**: Creates or updates the secret for the Azure Container Registry (ACR) in the Kubernetes cluster.
- **Check if Flux is Bootstrapped**: Checks if Flux is bootstrapped and bootstraps it if necessary.
- **Apply Flux YAML Files**: Applies the Flux configuration files to the cluster.
- **Add Ingress-NGINX Helm Repository**: Adds the Ingress-NGINX Helm repository and updates it.
- **Install NGINX Ingress Controller**: Installs the NGINX Ingress Controller if it is not already installed.
- **Verify Deployment**: Verifies the deployment by checking the status of the pods, services, and ingress resources in the cluster. This includes checking for the three images: web, turing-service, and prisoner-service.

### Terraform Deploy

This workflow is triggered by changes to the Terraform configuration files or manually via the GitHub Actions interface. It performs the following steps:

- **Checkout Code**: Checks out the code from the repository.
- **Set up Terraform**: Sets up Terraform.
- **Log in to Azure**: Logs in to Azure using service principal credentials.
- **Terraform Init**: Initializes Terraform.
- **Terraform Apply**: Applies the Terraform configuration to deploy resources to Azure.

### Terraform Destroy

This workflow is triggered manually via the GitHub Actions interface. It performs the following steps:

- **Checkout Code**: Checks out the code from the repository.
- **Set up Terraform**: Sets up Terraform.
- **Log in to Azure**: Logs in to Azure using service principal credentials.
- **Terraform Init**: Initializes Terraform.
- **Terraform Destroy**: Destroys the Terraform-managed resources in Azure.

## Helm Charts

The Helm charts are used to package and deploy the Kubernetes resources for the application. The following directories and files are part of the Helm chart:

- `/charts`: Directory for Helm chart dependencies.
- `/templates`: Directory containing the Kubernetes resource templates.
  - `/templates/tests`: Directory for Helm test templates.
  - `_helpers.tpl`: Template helper functions.
  - `deployment.yaml`: Template for the Kubernetes Deployment resource.
  - `hpa.yaml`: Template for the Horizontal Pod Autoscaler resource.
  - `ingress.yaml`: Template for the Ingress resource.
  - `NOTES.txt`: Instructions displayed after the chart is deployed.
  - `service.yaml`: Template for the Kubernetes Service resource.
  - `serviceaccount.yaml`: Template for the ServiceAccount resource.
- `.helmignore`: File specifying files to ignore when packaging the Helm chart.
- `Chart.yaml`: Metadata about the Helm chart.
- `values.yaml`: Default configuration values for the Helm chart.

### Helm Chart Structure

- **charts**: This directory is used to store any dependencies for the Helm chart.
- **templates**: This directory contains the templates for the Kubernetes resources that will be deployed.
  - **tests**: Contains templates for Helm tests.
  - **_helpers.tpl**: Contains helper template functions that can be used throughout the chart.
  - **deployment.yaml**: Defines the Deployment resource for the application.
  - **hpa.yaml**: Defines the Horizontal Pod Autoscaler resource.
  - **ingress.yaml**: Defines the Ingress resource for routing external traffic.
  - **NOTES.txt**: Provides instructions and information after the chart is deployed.
  - **service.yaml**: Defines the Service resource to expose the application.
  - **serviceaccount.yaml**: Defines the ServiceAccount resource.
- **.helmignore**: Specifies files to ignore when packaging the Helm chart.
- **Chart.yaml**: Contains metadata about the Helm chart, such as the name, version, and description.
- **values.yaml**: Contains the default configuration values for the chart, which can be overridden by the user.

The `values.yaml` file includes configuration options for the service, image, ingress, autoscaling, and other Kubernetes resources. These values can be customized to suit the deployment requirements. The project now uses three images: web, turing-service, and prisoner-service.

By using Helm charts, we can easily package, configure, and deploy the application to Kubernetes clusters.

## Terraform Configuration

### Terraform Setup

The Terraform setup involves defining the necessary resources and configurations to deploy an AKS cluster and manage its state using Azure Storage. The main components include:

- **Random Pet Resources**: Used to generate unique names for the resource group, Kubernetes cluster, and DNS prefix.
- **Local Values**: Stores the generated names for use in resource definitions.
- **Resource Group**: Defines the Azure Resource Group where the resources will be deployed.
- **Kubernetes Cluster**: Defines the AKS cluster with a system-assigned identity and a default node pool.
- **Azure Storage Account and Container**: Used to store the Terraform state.

### Terraform Deployment

The Terraform deployment process includes the following steps:

1. **Initialize Terraform**: Initializes the Terraform configuration and backend.
2. **Apply Configuration**: Applies the Terraform configuration to create the defined resources in Azure.

### Terraform Destruction

The Terraform destruction process involves the following steps:

1. **Initialize Terraform**: Initializes the Terraform configuration and backend.
2. **Destroy Resources**: Destroys the Terraform-managed resources in Azure.

### Additional Information

- **terraform.tfvars**: This file contains sensitive information such as the Application ID, Tenant ID, Client Secret, and Subscription ID. It is used to provide values for the variables defined in the Terraform configuration. This file is local and not included in the repository.
- **azurek8s**: This file is used to connect to the AKS cluster using `kubectl`. It contains the necessary configuration to authenticate and interact with the cluster.

### Example terraform.tfvars

```plaintext
client_id       = "YOUR_CLIENT_ID"
client_secret   = "YOUR_CLIENT_SECRET"
tenant_id       = "YOUR_TENANT_ID"
subscription_id = "YOUR_SUBSCRIPTION_ID"
sql_admin_password = "YOUR_SQL_ADMIN_PASSWORD"
```

### Example azurek8s

This file is used locally to connect to the AKS cluster using `kubectl`.

```plaintext
# Contents of azurek8s file
```

### TLS Configuration

#### Using cert-manager

cert-manager is integrated with Flux and should be installed as part of your Flux setup. It automates the management and issuance of TLS certificates within your Kubernetes cluster.

#### Using acme.sh

acme.sh is an alternative tool for managing TLS certificates. Follow the steps below to use acme.sh instead of cert-manager:

1. **Install acme.sh**: Install acme.sh on your local machine or a server.
   ```sh
   curl https://get.acme.sh | sh -s email=YOUR_EMAIL --force
   ```
2. **Set Environment Variables**: Export the necessary environment variables for DNS validation.
   ```sh
   export NAMECOM_TOKEN="YOUR_NAMECOM_TOKEN"
   export NAMECOM_USERNAME="YOUR_USERNAME"
   ```
3. **Issue Certificate**: Use acme.sh to issue a certificate for your domain using DNS validation.
   ```sh
   acme.sh --issue --dns dns_namecom -d markmikula.software -d *.markmikula.software
   ```
4. **Install Certificate**: Install the issued certificate in your Kubernetes cluster as a secret.
   ```sh
   kubectl create secret tls markmikula.software-tls --cert=/path/to/fullchain.cer --key=/path/to/markmikula.software.key --namespace mark
   ```

### Important Information

To ensure the public IP works correctly with the ingress controller, run the following command:
```sh
kubectl patch svc ingress-nginx-controller --namespace ingress-nginx -p '{"spec":{"externalTrafficPolicy":"Local"}}'
```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

This project is licensed under the MIT License.
