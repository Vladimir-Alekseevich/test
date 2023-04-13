resource "yandex_compute_instance" "vm" {
  for_each = {for vm in var.vm: vm.name => vm}

  name = "${each.value.name}"
  platform_id = "standard-v1"

  resources {
    cores  = "${each.value.cpu}"
    memory = "${each.value.ram}"
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type = "network-hdd"
      size = "${each.value.disk}"
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

