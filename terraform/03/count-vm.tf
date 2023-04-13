resource "yandex_compute_instance" "example" {
  name        = "netology-develop-platform-web-${count.index}"
  platform_id = "standard-v1"

  count = 1

  resources {
    cores  = 2
    memory = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      name = "first"
      type = "network-hdd"
      size = 5
    }
  }
/*
 [ for <ITEM> in <LIST> : <OUTPUT_KEY> => <OUTPUT_VALUE> ]
 for_each = {for vm in var.vm: vm.name => vm}

  dynamic "secondary_disk" {
    for_each = {name = secdisk-${count.index}}
    content {
      disk_id     = yandex_compute_disk.${each.value}.id
      }
  }
*/
  dynamic "secondary_disk" {
    for_each = lookup(each.value, "secondary_disk")
    content {
      disk_id = yandex_compute_disk.vm-disk.id
      auto_delete = true
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key)}"
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
  allow_stopping_for_update = true
}

resource "yandex_compute_disk" "secondary_disk" {
  count = var.instance_count
      name = "secdisk-${count.index}"
      type = "network-hdd"
      size = var.secondary_disk
}
