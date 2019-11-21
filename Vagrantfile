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
            machine.vm.network "private_network", ip: "192.168.50.#{100+id}"

            # Provisioning
            if id == 0
                machine.vm.network "forwarded_port", guest: 80, host: 80

                machine.vm.provision "shell", path: "provision-ansible.sh"
                machine.vm.synced_folder "provision-files-ansible/", "/provision-files", type: "rsync"  # Sync the contents of sync-master to /provision-files
            else
                machine.vm.provision "shell", path: "provision.sh"
                machine.vm.synced_folder "provision-files/", "/provision-files", type: "rsync"  # Sync the contents of sync-master to /provision-files
            end
            machine.vm.synced_folder ".", "/vagrant", disabled: true                    # Disable default folder syncing
        end
    end
end
