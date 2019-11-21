## How to:

Start the virtual machines:

```bash
vagrant up
```

Provision server0 (after modifying the ansible install playbook):

```bash
vagrant rsync server0 && vagrant provision server0
```

Run the Ansible `install.yml` playbook:

```bash
vagrant ssh server0
cd src/ansible
ansible-playbook -i inventories/cluster.yml install.yml
```
