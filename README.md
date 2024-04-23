# Veilid Terraform Scaleway

A quick and easy way to have one or more [veilid](https://veilid.com/) nodes bootstrapped and running in Scaleway.

## Cost

Scaleway is one of the more expensive options for running cheap instances, and the default configuration here will cost a little over $7/month. Since Scaleway charges for attached IPv4 addresses, we're not setting up one in the default configuration, but you can enable one if you need IPv4 access for SSH (see Connecting section below).


## Set up

If you don't have a [Scaleway](https://www.scaleway.com) account, then sign up for one of those first.

Next, you'll need to set up API keys, so just follow [this guide](https://www.scaleway.com/en/docs/identity-and-access-management/iam/how-to/create-api-keys/).

You'll also need Terraform, so [this page](https://developer.hashicorp.com/terraform/install) will help you do that if you don't have it installed yet.

## Running the commands

1. copy the API key values into a local `.env` file. You can use the `.env.example` as a template. Copy in the values and then rename to `.env` (already set in the `.gitignore`).

2. Then run `source .env` and the variables should be set up correctly in your shell.

3. Add your public ssh key contents to the `ssh_authorized_keys` section in `setup-veilid.yaml`. Skip this step if you don't care about SSH access to the node(s).

> If you want to use a separate SSH key, then generate one in this folder like `ssh-keygen -t ed25519 -o -a 100 -f veilid-key`. Then use that key in `setup-veilid.yaml`.

4. After that, you should be ready to run `terraform init && terraform apply`.

## Connecting

The IP addresses for the nodes will be at the bottom of the terraform output. They'll look something like:

```sh
Outputs:

public_ipv4_address = []
public_ipv6_address = [
  "2001:bc8:1210:1414::",
]
```

If you need to enabled IPv4 access for ssh, you can change the value for `needIpv4 = false` to `needIpv4 = true` in `main.tf`. Re-run `terraform apply` and you should see:

```sh
Outputs:

public_ipv4_address = [
  "51.159.148.206",
]
public_ipv6_address = [
  "2001:bc8:1202:e60c::1",
]
```

You can access the node(s) via `ssh -i PATH_TO_PRIVATE_KEY veilid@PUBLIC_IP_ADDRESS`.
