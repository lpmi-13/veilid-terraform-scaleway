
resource "scaleway_instance_security_group" "veilid" {
  project_id = local.project_id

  name = "veilid-securitygroup"

  inbound_default_policy  = "drop"
  outbound_default_policy = "accept"

  dynamic "inbound_rule" {
    for_each = local.needIpv4 ? [true] : []
    content {
      action   = "accept"
      port     = "22"
      ip_range = "0.0.0.0/0"
    }
  }

  inbound_rule {
    action   = "accept"
    port     = "22"
    ip_range = "::/0"
  }

  dynamic "inbound_rule" {
    for_each = local.needIpv4 ? [true] : []
    content {
      action   = "accept"
      port     = "5151"
      protocol = "TCP"
      ip_range = "0.0.0.0/0"
    }
  }

  inbound_rule {
    action   = "accept"
    port     = "5151"
    protocol = "TCP"
    ip_range = "::/0"
  }

  dynamic "inbound_rule" {
    for_each = local.needIpv4 ? [true] : []
    content {
      action   = "accept"
      port     = "5151"
      protocol = "UDP"
      ip_range = "0.0.0.0/0"
    }
  }

  inbound_rule {
    action   = "accept"
    port     = "5151"
    protocol = "UDP"
    ip_range = "::/0"
  }

  dynamic "inbound_rule" {
    for_each = local.needIpv4 ? [true] : []
    content {
      action   = "accept"
      port     = "5150"
      protocol = "TCP"
      ip_range = "0.0.0.0/0"
    }
  }

  inbound_rule {
    action   = "accept"
    port     = "5150"
    protocol = "TCP"
    ip_range = "::/0"
  }

  dynamic "inbound_rule" {
    for_each = local.needIpv4 ? [true] : []
    content {
      action   = "accept"
      port     = "5150"
      protocol = "UDP"
      ip_range = "0.0.0.0/0"
    }
  }

  inbound_rule {
    action   = "accept"
    port     = "5150"
    protocol = "UDP"
    ip_range = "::/0"
  }
}
