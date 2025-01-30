# Mark's Internship Hub

Welcome to Mark's repository for managing Kubernetes clusters using Flux.

## Table of Contents

- [Introduction](#introduction)
- [Project Structure](#project-structure)
- [Helm Charts](#helm-charts)
- [Terraform Configuration](#terraform-configuration)
- [Contributing](#contributing)
- [License](#license)

## Introduction

This repository contains configuration and scripts to manage Kubernetes clusters using Flux. The project uses three images: web, turing-service, and prisoner-service.

## Project Structure

The project utilizes Terraform, Kubernetes/Helm charts, Flux, and GitHub Actions. The container which runs on AKS is built in another repository.

## Helm Charts

The Helm charts are used to package and deploy the Kubernetes resources for the application. These charts handle Deployments, Services, and Ingress configurations for all three images.

## Terraform Configuration

This folder contains high-level Terraform definitions for provisioning AKS and related Azure resources.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

This project is licensed under the MIT License.
