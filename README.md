# Mark's Internship Hub

Welcome to Mark's repository for managing Kubernetes clusters using Flux.

## Table of Contents

- [Introduction](#introduction)
- [Technologies Used](#technologies-used)
- [Helm Charts](#helm-charts)
- [Terraform Configuration](#terraform-configuration)
- [Terraform Resources](#terraform-resources)
- [Kubernetes Resources](#kubernetes-resources)
- [Flux Configuration and Workflows](#flux-configuration-and-workflows)
- [GitHub Actions Workflows](#github-actions-workflows)
- [Purpose and Contents](#purpose-and-contents)
- [Key Features and Benefits](#key-features-and-benefits)
- [License](#license)

## Introduction

This repository contains configuration and scripts to manage Kubernetes clusters using Flux. The project uses three images: web, turing-service, and prisoner-service.

## Technologies Used

This project uses the following technologies and approaches:
- **Azure**: The project provisions and manages Azure Kubernetes Service (AKS) clusters.
- **Docker**: Docker is used to containerize the application components.
- **GitHub Actions**: GitHub Actions are used for CI/CD pipelines to automate the deployment process.
- **Terraform**: Terraform is used for provisioning and managing the infrastructure on Azure.
- **Kubernetes/Helm charts**: Helm charts are used to package and deploy the Kubernetes resources for the application.
- **Flux**: Flux is used for continuous deployment of the application to the Kubernetes cluster.

## Helm Charts

The Helm charts are used to package and deploy the Kubernetes resources for the application. These charts handle Deployments, Services, and Ingress configurations for all three images.

## Terraform Configuration

This folder contains high-level Terraform definitions for provisioning AKS and related Azure resources.

## Terraform Resources

The Terraform configuration in this project includes the following resources:
- **azurerm_resource_group**: Creates resource groups in Azure.
- **azurerm_virtual_network**: Creates a virtual network in Azure.
- **azurerm_user_assigned_identity**: Creates a user-assigned identity for the AKS cluster.
- **azurerm_kubernetes_cluster**: Creates the Azure Kubernetes Service (AKS) cluster.
- **azurerm_storage_account**: Creates a storage account for storing Terraform state files.
- **azurerm_container_registry**: Creates an Azure Container Registry (ACR) for storing Docker images.

## Kubernetes Resources

The Kubernetes resources managed by this project include:
- **Deployments**: Manages the deployment of application components.
- **Services**: Exposes the application components to the network.
- **Ingress**: Manages external access to the services.
- **HorizontalPodAutoscaler**: Automatically scales the number of pods based on resource usage.
- **ServiceAccount**: Manages service accounts for the application components.

## Flux Configuration and Workflows

The Flux configuration and workflows in this project include:
- **GitRepository**: Defines the source repository for the Flux configuration.
- **Kustomization**: Manages the application of Kubernetes manifests.
- **HelmRelease**: Manages the deployment of Helm charts.
- **HelmRepository**: Defines the Helm repositories used by the project.
- **GitHub Actions**: Automates the deployment process using CI/CD pipelines.

## GitHub Actions Workflows

The GitHub Actions workflows in this project include:
- **Terraform Deploy**: Automates the deployment of infrastructure using Terraform.
- **Terraform Destroy**: Automates the destruction of infrastructure using Terraform.
- **App Deploy**: Automates the deployment of the application to the Kubernetes cluster using Helm and Flux.

## Purpose and Contents

The purpose of this project is to provide a comprehensive solution for managing Kubernetes clusters using Flux. The project contains the following components:
- **Terraform Configuration**: High-level Terraform definitions for provisioning AKS and related Azure resources.
- **Helm Charts**: Helm charts for packaging and deploying the Kubernetes resources for the application.
- **GitHub Actions**: CI/CD pipelines for automating the deployment process.
- **Flux Configuration**: Configuration files for managing the continuous deployment of the application to the Kubernetes cluster.

## Key Features and Benefits

- **Scalability**: The project is designed to handle large-scale deployments with ease.
- **Automation**: The use of GitHub Actions and Flux ensures that the deployment process is fully automated.
- **Flexibility**: The project can be easily adapted to different environments and requirements.
- **Reliability**: The use of Terraform and Helm ensures that the infrastructure and application are deployed consistently and reliably.
- **Security**: The project follows best practices for security, including the use of Azure's security features and Kubernetes' RBAC.

## License

This project is licensed under the MIT License.
