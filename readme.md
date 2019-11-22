## How-to:

Start the virtual machines:

```bash
vagrant up
```

Another provision run may be necessary for DCHP ip to be attributed:
```bash
vagrant provision
```

Rerun all playbooks (after modifying anyone for instance):

```bash
vagrant provision control
```

Manually run a single ansible `playbook_name.yml` playbook:

```bash
vagrant ssh control
cd src/ansible
ansible-playbook -i inventories/cluster.yml playbook_name.yml
```
