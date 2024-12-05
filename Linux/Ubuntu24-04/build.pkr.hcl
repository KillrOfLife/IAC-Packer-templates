variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}

variable "TZ" {
  type = string
}

variable "packages" {
  type = list(string)
}

variable "shell" {
  type = string
}

variable "ssh_username" {
  type = string
}

variable "ssh_password" {
  type      = string
  sensitive = true
}

variable "hashed_password" {
  type = string
}

variable "proxmox_node" {
  type = string
}

variable "proxmox_vm_storage" {
  type = string
}

variable "proxmox_network_bridge" {
  type = string
}


source "proxmox-iso" "IAC-Ubuntu-24-04" {
  proxmox_url              = "${var.proxmox_api_url}"
  username                 = "${var.proxmox_api_token_id}"
  token                    = "${var.proxmox_api_token_secret}"
  insecure_skip_tls_verify = true

  node                 = "${var.proxmox_node}"
  # vm_id                = "90101"
  vm_name              = "IAC-Ubuntu-24-04"
  template_description = "V1"

  iso_file         = "local:iso/ubuntu-24.04-live-server-amd64.iso"
  iso_storage_pool = "local"
  unmount_iso      = true
  qemu_agent       = true

  scsi_controller = "virtio-scsi-pci"

  cores   = "2"
  sockets = "1"
  memory  = "2048"

  cloud_init              = true
  cloud_init_storage_pool = "${var.proxmox_vm_storage}"

  vga {
    type = "virtio"
  }

  disks {
    disk_size    = "20G"
    format       = "raw"
    storage_pool = "${var.proxmox_vm_storage}"
    type         = "virtio"
  }

  network_adapters {
    model    = "virtio"
    bridge   = "${var.proxmox_network_bridge}"
    firewall = "false"
  }

  boot_command = ["c", "linux /casper/vmlinuz -- autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'", "<enter><wait><wait>", "initrd /casper/initrd", "<enter><wait><wait>", "boot<enter>"]

  # boot                      = "c"
  # boot_wait                 = "6s"
  # communicator              = "ssh"

  # http_directory = "Linux/Ubuntu24-04/http"
  http_content ={
    "/meta-data"  = file("http/meta-data")
    "/user-data" = templatefile("http/user-data.tpl", { user = var.ssh_username, password = var.hashed_password, TZ=var.TZ, packages=var.packages, shell=var.shell})
  }

  http_port_min  = 11010
  http_port_max  = 11020

  ssh_username = "${var.ssh_username}"
  ssh_password = "${var.ssh_password}"

  # Raise the timeout, when installation takes longer
  ssh_timeout            = "30m"
  ssh_pty                = true
  ssh_handshake_attempts = 15
}

build {
  name = "pkr-ubuntu"
  sources = [
    "proxmox-iso.IAC-Ubuntu-24-04"
  ]

  # Waiting for Cloud-Init to finish
  provisioner "shell" {
    inline = ["while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done"]
  }

  # Provisioning the VM Template for Cloud-Init Integration in Proxmox #1
  provisioner "shell" {
    # execute_command = "echo -e '<user>' | sudo -S -E bash '{{ .Path }}'"
    inline = [
      "echo 'Starting Stage: Provisioning the VM Template for Cloud-Init Integration in Proxmox'",
      "sudo rm /etc/ssh/ssh_host_*",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo apt -y autoremove --purge",
      "sudo apt -y clean",
      "sudo apt -y autoclean",
      "sudo cloud-init clean",
      "sudo rm -f /etc/cloud/cloud.cfg.d/99-installer.cfg",
      "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
      "sudo rm -f /etc/netplan/00-installer-config.yaml",
      "sudo sync",
      "echo 'Done Stage: Provisioning the VM Template for Cloud-Init Integration in Proxmox'"
    ]
  }

  # Provisioning the VM Template for Cloud-Init Integration in Proxmox #2
  provisioner "file" {
    source      = "Linux/Ubuntu24-04/files/99-pve.cfg"
    destination = "/tmp/99-pve.cfg"
  }
  provisioner "shell" {
    inline = ["sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg"]
  }

  # provisioner "ansible-local" {
  #   playbook_file   = "Ansible/playbook.yml"
  # }

  provisioner "shell" {
    inline = [
      "sudo apt -y remove ansible",

      # "pipx install thefuck",
      # "pipx ensurepath",
      # "echo '' >> ~/.bashrc",

      ##ZSH configuration
      "git clone https://github.com/KillrOfLife/ZSH-dotfiles.git ~/dotfiles",
      "cd ~/dotfiles && stow .",




    ]
  }
}
