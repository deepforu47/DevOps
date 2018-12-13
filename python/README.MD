## json2yaml ##
```
$ head debug-pod.json
{
    "apiVersion": "v1",
    "kind": "Pod",
    "metadata": {
        "creationTimestamp": "2018-12-12T10:02:01Z",
        "generateName": "debug-5c5449d488-",
        "labels": {
            "app": "debug",
            "confighash": "dummy",
            "pod-template-hash": "1710058044",
            
$ python ./json-to-yaml.py debug-pod.json | head
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: '2018-12-12T10:02:01Z'
  generateName: debug-5c5449d488-
  labels:
    app: debug
    confighash: dummy
    pod-template-hash: '1710058044'
    secrethash: dummy            
```
