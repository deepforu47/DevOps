## JSON to YAML ##
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
Note - This script is in python2, so you will get error if try to execute with python3. If you want to change this to python3, there is in built tool called "2to3-2.7".
```
$ python3 ./json-to-yaml.py debug-pod.json | head
  File "./json-to-yaml.py", line 7
    print yaml.safe_dump(json.load(f), default_flow_style=False)
             ^
SyntaxError: invalid syntax
$ 2to3-2.7 -w json-to-yaml.py
RefactoringTool: Skipping optional fixer: buffer
RefactoringTool: Skipping optional fixer: idioms
RefactoringTool: Skipping optional fixer: set_literal
RefactoringTool: Skipping optional fixer: ws_comma
RefactoringTool: Refactored json-to-yaml.py
--- json-to-yaml.py     (original)
+++ json-to-yaml.py     (refactored)
@@ -4,4 +4,4 @@
 import yaml

 with open(sys.argv[1]) as f:
-  print yaml.safe_dump(json.load(f), default_flow_style=False)
+  print(yaml.safe_dump(json.load(f), default_flow_style=False))
RefactoringTool: Files that were modified:
RefactoringTool: json-to-yaml.py
$ python3 ./json-to-yaml.py debug-pod.json | head
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
