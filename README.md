# K8s cluster with Kubespray

Spinnng up a cluster setup on virtualbox via Vagrant. Testing ground before testing on actual servers :_skull

- Install Vagrant CLI
- Install virtualbox on Mac (version 7.0.0)
- `vagrant up --provider=virtualbox`

- `for i in 11 21 22;do ssh devops@192.168.50.$i hostname;done`

## UTM setup alternative (mac M1)

- `vagrant plugin install vagrant_utm`
- `vagrant up`
- `vagrant destroy -f`
- `vagrant reload node-2 --provision`

`sed -i 's/ansible==9.8.0/ansible>=2.9,<2.10/' requirements.txt`

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


declare -a IPS=("127.0.0.1:2222" "127.0.0.1:2200" "127.0.0.1:2201")

ansible-playbook \
  -i inventory/mycluster/hosts.yaml cluster.yml \
  -u vagrant -b

ansible-playbook -i inventory/mycluster/hosts.yaml cluster.yml -u vagrant -b
```

## Once setup is done

```bash

sudo cp /etc/kubernetes/admin.conf ~/
cat admin.conf

## in cluster
kubectl get nodes --kubeconfig=admin.conf

kubectl get po -A --kubeconfig=admin.conf

## outside

scp -P 2222 vagrant@127.0.0.1:~/admin.conf ~/.kube/mycluster.conf

export KUBECONFIG=~/.kube/mycluster.conf 
export KUBECONFIG=/Users/mohameda/.kube/mycluster.conf

kubectl get nodes --kubeconfig=/Users/mohameda/.kube/mycluster.conf --insecure-skip-tls-verify

kubectl get nodes --kubeconfig=/etc/kubernetes/admin.conf --insecure-skip-tls-verify
kubectl get po -A --kubeconfig=/etc/kubernetes/admin.conf --insecure-skip-tls-verify


vagrant destroy -f
```
