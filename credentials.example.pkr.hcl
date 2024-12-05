proxmox_api_url          = "https://x.x.x.x:8006/api2/json"
proxmox_api_token_id     = "root@pam!description"
proxmox_api_token_secret = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
proxmox_node        = "pve"
# proxmox_skip_tls_verify     = "true"
proxmox_iso_storage         = "local"
proxmox_vm_storage    = "local-lvm"
proxmox_network_bridge   = "vmbr0"

TZ = "US/Pacific"
packages =["neofetch", "zsh", "neovim", "screen", "fzf", "zoxide", "eza", "stow"]
shell = "/bin/zsh"

ssh_username = "ubuntu"
ssh_password = "ubuntu"
# mkpasswd --method=SHA-512 --rounds=4096 
hashed_password = "$6$rounds=4096$jEnM72qOA54aQ/ou$wGK4OQI94vNQIDWg6a7tpuTNRfjeYo6Acqp.57Kxi0SGzznHcf6.ZjTX5w9S/RQ3DniOrQ1SaKmiDH7n/FcjI0"

winrm_username = "Administrator"
winrm_password = "Localadminpass"