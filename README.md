# arocluster

## Automation for a quick and simple ARO deployment

*Make sure you have already used az login*

### How to use install it and run

```sh
git clone https://github.com/dqmicrosoft/arocluster.git
cd arocluster
chmod +x deployaro.sh
./deployaro.sh
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




