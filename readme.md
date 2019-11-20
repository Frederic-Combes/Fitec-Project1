## How to:

Start the virtual machines:
    vagrant up

Provision server0:
    vagrant rsync && vagrant provision server0

Run the Ansible '''install.yml'''
   vagrant ssh server0
   cd src/ansible
   ansible-playbook -i inventories/cluster.yml install.yml

