# -*- mode: ruby -*-
# vi: set ft=ruby sw=2 st=2 et :

Vagrant.configure("2") do |config|
    config.vm.box = "debian/buster64"
    config.vm.box_check_update = false


    config.vm.provider "virtualbox" do |vb|
        vb.gui = false
    end

    # Configure cluster nodes s0.infra ... s4.infra
    5.times do |id|
        config.vm.define "s#{id}.infra" do |machine|
            machine.vm.provider "virtualbox" do |vb|
                vb.gui = false                                                          # No GUI
                vb.memory = "2048"                                                      # Give less RAM
                vb.cpus = 1                                                             # Give less CPU
            end

            machine.vm.hostname = "s#{id}.infra"

            # Provisioning
            if id == 0
                machine.vm.network "private_network",  ip: "192.168.50.#{100 + id}"
                machine.vm.network "forwarded_port", guest: 80, host: 80
            else
                machine.vm.network "private_network",  ip: "192.168.50.#{100 + id}", auto_config: false
            end


            machine.vm.synced_folder "provision-files/", "/provision-files", type: "rsync"  # Sync the contents of sync-master to /provision-files
            machine.vm.synced_folder ".", "/vagrant", disabled: true                    # Disable default folder syncing

            machine.vm.provision "shell", path: "provision-scripts/provision-base-packages.sh"
            machine.vm.provision "shell", path: "provision-scripts/provision-authorize-keys.sh"
            machine.vm.provision "shell", path: "provision-scripts/provision-hosts.sh"
            if id == 0
                machine.vm.provision "shell",
                  path: "provision-scripts/provision-dhcp.sh",
                  env: {"PERFORM_DHCLIENT" => "false"}
            else
                machine.vm.provision "shell",
                  path: "provision-scripts/provision-dhcp.sh",
                  env: {"PERFORM_DHCLIENT" => "true"}
            end
        end
    end

    config.vm.define "control" do |machine|
        machine.vm.provider "virtualbox" do |vb|
            vb.gui = false
            vb.memory = "2048"
            vb.cpus = 1
        end

        machine.vm.hostname = "control"
        machine.vm.network "private_network", ip: "192.168.50.50"
        machine.vm.synced_folder ".", "/vagrant", disabled: true
        machine.vm.synced_folder "provision-files-ansible/", "/provision-files", type: "rsync"

        machine.vm.provision "shell", path: "provision-scripts/provision-base-packages.sh"
        machine.vm.provision "shell", path: "provision-scripts/provision-ansible-package.sh"
        machine.vm.provision "shell", path: "provision-scripts/provision-authorize-keys.sh"
        machine.vm.provision "shell", path: "provision-scripts/provision-add-keys.sh"
        machine.vm.provision "shell", path: "provision-scripts/provision-hosts.sh"
        machine.vm.provision "shell", path: "provision-scripts/provision-dhcp.sh", env: {"PERFORM_DHCLIENT" => "false"}
        machine.vm.provision "shell", path: "provision-scripts/provision-ansible-play.sh"
    end
end
