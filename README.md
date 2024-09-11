# K8s cluster with Kubespray

- Install Vagrant CLI
- Install virtualbox on Mac (version 7.0.0)
- `vagrant up --provider=virtualbox`

- `for i in 11 21 22;do ssh devops@192.168.50.$i hostname;done`

# Deploy cluster by execute cluster.yml playbook

```
ansible-playbook -i inventory/mycluster/hosts.yml cluster.yml -b -v \
  --private-key=~/.ssh/private_key
```
