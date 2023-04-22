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

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.secondary_disk
    content {
      device_name = "virtual_disk_${secondary_disk.key}"
      disk_id     = yandex_compute_disk.secondary_disk[secondary_disk.key].id
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
      name = "virtual_disk_${count.index}"
      type = "network-hdd"
      size = 1
}
