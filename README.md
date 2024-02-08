# Veilid Terraform Scaleway

A quick and easy way to have one or more [veilid](https://veilid.com/) nodes bootstrapped and running in Scaleway.

## Set up

If you don't have a [Scaleway](https://www.scaleway.com) account, then sign up for one of those first.

Next, you'll need to set up API keys, so just follow [this guide](https://www.scaleway.com/en/docs/identity-and-access-management/iam/how-to/create-api-keys/).

You'll also need Terraform, so [this page](https://developer.hashicorp.com/terraform/install) will help you do that if you don't have it installed yet.

## Running the commands

Once that's all set up, the easiest way to get those credentials ready for terraform is to just copy them into a local `.env` file. You can use the `.env.example` as a template. Copy in the values and then rename to `.env` (already set in the `.gitignore`).

Then run `source .env` and the variables should be set up correctly in your shell.

After that, you should be ready to run `terraform init && terraform apply`.

The IP addresses for the nodes will be at the bottom of the terraform output. They'll look something like:

```sh
Outputs:
public_ip_address = [
  "51.159.183.201",
  "51.159.140.208",
]
```

You can access them via `ssh -i PATH_TO_PRIVATE_KEY veilid@PUBLIC_IP_ADDRESS`.
