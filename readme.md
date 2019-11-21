## How-to:

Start the virtual machines:

```bash
vagrant up
```

Provision server0 (after modifying the ansible install playbook):

```bash
vagrant rsync s0.infra && vagrant provision s0.infra
```

Run the Ansible `install.yml` playbook:

```bash
vagrant ssh s0.infra
cd src/ansible
ansible-playbook -i inventories/cluster.yml install.yml
```
