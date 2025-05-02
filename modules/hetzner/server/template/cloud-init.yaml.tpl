#cloud-config

debug: True

package_update: true
package_upgrade: true

%{ if operator_user ~}
users:
  - name: "${operator_user}"
    ssh_authorized_keys:
    %{ for key in ssh_keys ~} 
      - ${key}
    %{ endfor ~}
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    groups: [users, admin]
    shell: /bin/bash
%{ endif ~}

runcmd:
  - sed -i '$ a\AllowUsers ${operator_user}' /etc/ssh/sshd_config
