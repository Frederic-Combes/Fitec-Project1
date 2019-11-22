## How-to:

Start the virtual machines:

```bash
vagrant up
```

Another provision run may be necessary for DCHP ip to be attributed:
```bash
vagrant provision
```

Provision ```control``` (after modifying the ansible playbooks):

```bash
vagrant provision control
```

Manually run the Ansible `install.yml` playbook:

```bash
vagrant ssh control
cd src/ansible
ansible-playbook -i inventories/cluster.yml playbook_name.yml
```
