# K8s cluster with Kubespray

Spinnng up a cluster setup on virtualbox via Vagrant. Testing ground before testing on actual servers :_skull

- Install Vagrant CLI
- Install virtualbox on Mac (version 7.0.0)
- `vagrant up --provider=virtualbox`

- `for i in 11 21 22;do ssh devops@192.168.50.$i hostname;done`

## UTM setup alternative (mac M1)

- `vagrant plugin install vagrant_utm`
- `vagrant up`
- `vagrant reload node-2 --provision`

- Install UTM if using Mac

## Deploy cluster by execute cluster.yml playbook

```
ansible-playbook -i inventory/mycluster/hosts.yml cluster.yml -b -v \
  --private-key=~/.ssh/private_key
```

## SSH

```bash
vagrant ssh master-1


scp -P 2200 /path/to/node-config.yml vagrant@127.0.0.1:/home/vagrant/
pass: vagrant

sudo mkdir -p /vagrant
sudo mv /home/vagrant/node-config.yml /vagrant/


vagrant reload node-2 --provision
```

## Debugging

```bash
vagrant destroy node-2 -f

vagrant up --no-provision
vagrant destroy -f 

vagrant up node-2

vagrant ssh master

vagrant ssh node-1

vagrant ssh node-2

vagrant destroy -f
```

## Setup

```bash
vagrant up --no-provision ## provisions all nodes

###
ssh vagrant@127.0.0.1 -p 2222
ssh vagrant@127.0.0.1 -p 2200
ssh vagrant@127.0.0.1 -p 2201


for i in 11 21 22;do ssh vagrant@192.168.50.$i hostname;done

for port in 2222 2200 2201; do
  ssh vagrant@127.0.0.1 -p $port hostname
done

```
