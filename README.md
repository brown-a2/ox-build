[![OxBuild Platform Deployment](https://github.com/ministryofjustice/hale-platform/actions/workflows/cd.yaml/badge.svg?branch=main)](https://github.com/ministryofjustice/hale-platform/actions/workflows/cd.yaml)

# OxBuild Platform

This repository provides all the code required to run an instance of WordPress multisite in kubernetes. It uses the [WordPress official Alpine image](https://hub.docker.com/_/wordpress), and is modified to launch a multisite network. It uses PHP dependency manager Composer to pull in all the themes and plugins used by the multisite.

## Deploy to a kubernetes environment

This uses Helm charts to manage kubernetes manifest files. This repo is used to deploy infrastructure changes (ie helm chart/kubernetes changes) and changes to the application, as it pulls in the latest version of the OxBuild theme and plugins.

To deploy to one of our environments, push a code change to one of the corresponding branches in this repo which will trigger GitActions that deploy the code into the kubernetes cluster.

## Deploy locally on a Mac using Docker

To run this WordPress instance locally, follow our guidance on [local development](https://github.com/ministryofjustice/hale-platform/wiki/Local-development).
