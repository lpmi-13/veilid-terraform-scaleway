locals {
  # you can find your project ID at https://console.scaleway.com/project/settings
  project_id     = "COPY_YOUR_PROJECT_ID_HERE"
  instance_count = 1

  region = "fr-par"
  # available regions are:
  # fr-par Paris
  # nl-ams Amsterdam
  # pl-waw Warsaw

  # fr-par-2 has a greener powersource than fr-par-1
  zone = "fr-par-2"
  # available zones are
  #
  # in fr-par
  # fr-par-1
  # fr-par-2
  # fr-par-3
  #
  # in nl-ams
  # nl-ams-1
  # nl-ams-2
  # nl-ams-3
  #
  # in pl-waw
  # pl-waw-1
  # pl-waw-2
  # pl-waw-3

}

terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = ">= 2.37.0"
    }
  }
  required_version = ">= 1.6"
}

provider "scaleway" {
  zone   = local.zone
  region = local.region
}

resource "scaleway_instance_ip" "public_ip" {
  count      = local.instance_count
  project_id = local.project_id
}

resource "scaleway_instance_security_group" "veilid" {
  project_id = local.project_id

  name = "veilid-securitygroup"

  inbound_default_policy  = "drop"
  outbound_default_policy = "accept"

  inbound_rule {
    action   = "accept"
    port     = "22"
    ip_range = "0.0.0.0/0"
  }

  inbound_rule {
    action   = "accept"
    port     = "5151"
    protocol = "TCP"
  }

  inbound_rule {
    action   = "accept"
    port     = "5151"
    protocol = "UDP"
  }

  inbound_rule {
    action   = "accept"
    port     = "5150"
    protocol = "TCP"
  }

  inbound_rule {
    action   = "accept"
    port     = "5150"
    protocol = "UDP"
  }

}

resource "scaleway_instance_server" "veilid" {
  count      = local.instance_count
  project_id = local.project_id

  name = "veilid-node-${count.index}"
  # this instance type might not be available in all the regions/zones, so you might need to change this if you change the zone from fr-par-2
  # it's currently priced at about €0.0137/hour, so that's why I picked it.
  type  = "DEV1-S"
  image = "ubuntu_jammy"

  tags = ["veilid"]

  ip_id = scaleway_instance_ip.public_ip[count.index].id

  security_group_id = scaleway_instance_security_group.veilid.id

  user_data = {
    cloud-init = file("./setup-veilid.yaml")
  }
}
