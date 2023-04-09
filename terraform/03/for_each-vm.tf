resource "yandex_compute_instance" "vm" {
  for_each = {
    "vm1" = { var.vm.cpu = "4", var.vm.ram = "2", var.vm.disk = "5" }
    "vm2" = { var.vm.cpu = "2", var.vm.ram = "1", var.vm.disk = "7" }
 }

  name = each.key
  platform_id = "standard-v1"

  resources {
    cores  = each.value.vm_cpu
    memory = each.value.vm_ram
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      type = "network-hdd"
      size = each.value.vm_disk
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

