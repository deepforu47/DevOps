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

