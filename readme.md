## How to:

Start the virtual machines:
    ```bash
    vagrant up```

Provision server0:
    ```bash
    vagrant rsync && vagrant provision server0```

Run the Ansible `install.yml`
    ```bash
    vagrant ssh server0
    cd src/ansible
    ansible-playbook -i inventories/cluster.yml install.yml```
