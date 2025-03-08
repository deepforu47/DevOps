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
## Script to get the Build Pipeline Run on specific Build Agent get_adoagent_for_build_pipeline.py

```
import requests
import base64
import getpass
from tabulate import tabulate

# Get user input
ORGANIZATION = input("Enter Azure DevOps Organization: ").strip()
PROJECT = input("Enter Azure DevOps Project: ").strip()
AGENT_NAME = input("Enter Agent Name to Filter: ").strip()
START_TIME = input("Enter Start Time (YYYY-MM-DDTHH:MM:SSZ): ").strip()
END_TIME = input("Enter End Time (YYYY-MM-DDTHH:MM:SSZ): ").strip()
PAT = getpass.getpass("Enter your Personal Access Token (PAT): ").strip()

# Azure DevOps API Base URL
BASE_URL = f"https://dev.azure.com/{ORGANIZATION}/{PROJECT}/_apis"

# Encode PAT for authentication
AUTH_HEADER = {
    "Authorization": "Basic " + base64.b64encode(f":{PAT}".encode()).decode(),
    "Content-Type": "application/json"
}

# Function to get all pipeline runs within the time range
def get_pipeline_runs():
    url = f"{BASE_URL}/build/builds?minTime={START_TIME}&maxTime={END_TIME}&7.1-preview.1"
    response = requests.get(url, headers=AUTH_HEADER)
    if response.status_code != 200:
        print(f"❌ Failed to fetch pipeline runs: {response.text}")
        return []
    
    builds = response.json().get("value", [])
    return [(b["id"], b["definition"]["name"]) for b in builds]

# Function to get the agent that ran a specific pipeline run
def get_pipeline_agent(build_id):
    url = f"{BASE_URL}/build/builds/{build_id}/timeline?7.1-preview.1"
    response = requests.get(url, headers=AUTH_HEADER)
    
    if response.status_code != 200:
        print(f"⚠️ No timeline found for Build ID {build_id}")
        return None
    
    records = response.json().get("records", [])
    for record in records:
        if record.get("type") == "Job" and record.get("workerName"):
            return record["workerName"]
    return None

# Main function
def main():
    print(f"\nFetching pipeline runs from {START_TIME} to {END_TIME}...\n")
    
    pipelines = get_pipeline_runs()
    matched_pipelines = []

    for build_id, pipeline_name in pipelines:
        agent = get_pipeline_agent(build_id)
        if agent == AGENT_NAME:
            pipeline_url = f"https://dev.azure.com/{ORGANIZATION}/{PROJECT}/_build/results?buildId={build_id}"
            matched_pipelines.append((pipeline_name, build_id, pipeline_url))
            print(f"✅ {pipeline_name} (ID: {build_id}) was executed on {AGENT_NAME}")

    # Display results
    if not matched_pipelines:
        print(f"\nNo pipeline runs were found on agent {AGENT_NAME} within the specified time range.")
    else:
        print("\n📌 Pipeline runs executed on agent:", AGENT_NAME)
#        print(f"{'Pipeline Name':<30} | {'Build ID':<10} | Pipeline URL")
#        print("-" * 90)
#        for name, build_id, url in matched_pipelines:
#            print(f"{name:<30} | {build_id:<10} | {url}")
        print(tabulate(matched_pipelines, headers=["Pipeline Name", "Build ID", "Pipeline URL"], tablefmt="grid"))


if __name__ == "__main__":
    main()

```
