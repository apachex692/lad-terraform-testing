# Learning and Development: Terraform Testing

This repository contains necessary documentation to perform automated tests on Terraform scripts.

- **Author:** Sakthi Santhosh
- **Created on:** 26/12/2023

## Introduction

`terraform test` has been introduced with Terraform V1.6 and it is used to test Terraform scripts. Unlike `terraform plan` and `terraform apply`, testing is done locally on an ephemeral infractructure on memory. Various assertions can be placed in testing scripts to ensure desired behaviour.

## Terraform Setup

In this repository, Terraform scripts have been written to provision a static website in a S3 bucket.

## Testing Scripts

- Terraform looks for testing scripts in the `./` (root) or `./tests/` directory. Inside these directories, it looks for `*.tftest.hcl` file and executes them.
- Setup work for tests can be written as same as the provisioning scripts. These are called helper modules. For this project, the setup scripts for testing can be found at `./tests/setup/` directory. Here, we're creating a random prefix for S3 bucket as a setup process.
- In the test file, there are `run` blocks which represent a step in the process of provisioning. Inside this block, we can have multiple `assert` blocks that validate the correctness of the step.
- The `run.create_button` block assets three conditions:
    1. Bucket Name
    2. eTag of `index.html` (hash matching with local and bucket file)
    3. eTag of `error.html` (hash matching with local and bucket file)
- This block uses the `apply` command because we cannot test the assertions without applying (provisioning) the infrastructure.
- Values to variables can be assigned inside the `run` block. For example, the variable named `bucket_name` defined in `./variables.tf` is assigned a value here. The default value is overidden by this.
- The `run.website_is_running` block requires the `./tests/final/` helper module. This helper module makes a request (with `data` block in `./tests/fina/data.tf`) to the website URL created by the previous run block. This URL is accesses from the `run` block which references it from the `output` block in `./outputs.tf`.
- Here, the command applied is `plan` as the website is already running (from previous `run` block) and `plan` command lists out the execution plans alone which is sufficient for the assertions made in this block.

## Contributing

This is a personal project and I discourage public contributions. The repository has been kept public only for learning purpose.
