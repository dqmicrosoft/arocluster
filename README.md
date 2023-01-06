# arocluster

## Automation for a quick and simple ARO deployment

*Make sure you have already run az login*

### How to install it and run

```sh
git clone https://github.com/dqmicrosoft/arocluster.git
cd arocluster
chmod +x deployaro.sh
./deployaro.sh
```

### The output after creation will beÇ
```sh
Here are the credentials

KubeadminPassword        KubeadminUsername
-----------------------  -------------------
q39Vk-HVQ8D-BqATH-pkEBS  kubeadmin

Login here in the console
https://console-openshift-console.apps.nmaoi3cv.westeurope.aroapp.io/
Or use CLI *you have to have it installed*
oc login https://api.nmaoi3cv.westeurope.aroapp.io:6443/ -u kubeadmin -p <kubeadmin password>
```

Create cluster simple for tests (uncomplicated)
```sh
./deployaro.sh -u 
```
Delete cluster for cleanup 
```sh
./deployaro.sh -d 
```
Create cluster with pull secret
```sh
./deployaro.sh -s pathToSecret 
```
Create private cluster
```sh
./deployaro.sh -p
```
Create private cluster with pull secret 
```sh
./deployaro.sh -x pathToSecret 
```
*Private cluster still has to be more developed.*




