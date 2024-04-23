locals {
  # you can find your project ID at https://console.scaleway.com/project/settings
  project_id = "COPY_YOUR_PROJECT_ID_HERE"

  instance_count = 1

  # change this to "true" if you want to configure an IPv4 address for SSH access
  needIpv4 = false

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
      version = ">= 2.39.0"
    }
  }
  required_version = ">= 1.6"
}

provider "scaleway" {
  zone   = local.zone
  region = local.region
}

resource "scaleway_instance_ip" "public_ipv4" {
  count      = local.needIpv4 ? local.instance_count : 0
  type       = "routed_ipv4"
  project_id = local.project_id
}

resource "scaleway_instance_ip" "public_ipv6" {
  count      = local.instance_count
  type       = "routed_ipv6"
  project_id = local.project_id
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

  ip_ids            = local.needIpv4 ? [scaleway_instance_ip.public_ipv4[count.index].id, scaleway_instance_ip.public_ipv6[count.index].id] : [scaleway_instance_ip.public_ipv6[count.index].id]
  routed_ip_enabled = true

  security_group_id = scaleway_instance_security_group.veilid.id

  user_data = {
    cloud-init = file("./setup-veilid.yaml")
  }

  root_volume {
    # force a local volume instance of creating a new network attached drive
    size_in_gb  = 10
    volume_type = "l_ssd"
  }

  # adding this since terraform destroy might try to delete the security group before the instance,
  # which will fail
  depends_on = [scaleway_instance_security_group.veilid]
}
