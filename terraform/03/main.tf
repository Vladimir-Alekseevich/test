resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

# data "yandex_compute_image" "ubuntu" {
#   family = var.vm_web_image
# }

 data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_disk" "secondary_disk" {
  count = var.instance_count
      name = "secdisk-${count.index}"
      type = "network-hdd"
      size = var.secondary_disk
}
