## How-to:

Start the virtual machines:

```bash
vagrant up
```

Another provision run may be necessary for DCHP ip to be attributed:
```bash
vagrant provision
```

Rerun all playbooks (after modifying any, for instance):

```bash
vagrant provision control
```

Manually run a single ansible `playbook_name.yml` playbook:

```bash
vagrant ssh control
cd src/ansible
ansible-playbook -i inventories/cluster.yml playbook_name.yml
```

Demonstrate replication, load-balancing and "1 button up"
```bash
vagrant halt s1.infra
```
The  three websites are still available.
```bash
vagrant halt s2.infra
```
No servers are available, _devops.com_ returns
```html
<html>
    <body>
        <h1>503 Service Unavailable</h1>
        No server is available to handle this request.
    </body>
</html>
```
Starting the server _s1.infra_ and provisioning it with ansible
```bash
vagrant up --provision s1.infra
vagrant provision control
```
starts the server and websites are available again
