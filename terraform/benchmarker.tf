resource "sakuracloud_server" "isucon12f-benchmarker" {
  name = var.benchmarker_name
  zone = var.zone

  core   = 4
  memory = 8
  disks  = [sakuracloud_disk.isucon12f-benchmarker.id]

  network_interface {
    upstream = "shared"
  }

  network_interface {
    upstream = sakuracloud_switch.isucon12f-switch.id
  }


  user_data = join("\n", [
    "#cloud-config",
    local.benchmarker-cloud-config,
    yamlencode({
      ssh_pwauth : false,
      ssh_authorized_keys : [
        file(var.public_key_path),
      ],
    }),
  ])
}

resource "sakuracloud_disk" "isucon12f-benchmarker" {
  name = var.benchmarker_name
  zone = var.zone

  size              = 20
  source_archive_id = data.sakuracloud_archive.ubuntu.id
}

data "http" "benchmarker-cloud-config-source" {
  url = "https://raw.githubusercontent.com/saitamau-maximum/isucon-12-final-tf/main/cloud-init/benchmarker.cfg"
}

locals {
  benchmarker-cloud-config = replace(data.http.benchmarker-cloud-config-source.body, "#cloud-config", "")
}

output "benchmarker_ip_address" {
  value = sakuracloud_server.isucon12f-benchmarker.ip_address
}