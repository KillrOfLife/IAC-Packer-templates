#cloud-config
autoinstall:
  version: 1
  locale: en_US
  refresh-installer:
      update: true
  keyboard:
    layout: us
  ssh:
    install-server: true
    allow-pw: true
    disable_root: true
    ssh_quiet_keygen: true
    allow_public_ssh_keys: true
  storage:
    layout:
      name: lvm
  network:
    version: 2
    ethernets:
      all-en:
        dhcp4: true
        match: 
          name: en*
      all-eth:
        dhcp4: true
        match: 
          name: eth*
  disable_root: true
  user-data:
    package_upgrade: true
    timezone: ${TZ}
    ssh_pwauth: true
    users:
      - name: ${user}
        groups: [adm, sudo]
        lock-passwd: false
        sudo: ALL=(ALL) NOPASSWD:ALL
        shell: ${shell}
        # mkpasswd --method=SHA-512 --rounds=4096
        passwd: ${password}
        
  packages:
%{ for package in packages ~}
    - ${package}
%{ endfor ~}
    - qemu-guest-agent
    - sudo
    - git
    - cifs-utils
    - ansible
    - python3-dev 
    - python3-pip 
    - python3-setuptools
    # - thefuck


  
