#!/bin/bash

# Set variables
ORGANIZATION=""     # Replace with your Azure DevOps organization
PROJECT=""       # Replace with your project name
START_TIME=""  # Adjust your time range
END_TIME="2025-03-17T08:36:00Z"
AGENT_NAME="a"        # Replace with your target agent name
PAT=""  # Replace with your Azure DevOps PAT

# Encode PAT for authentication
AUTH_HEADER="Authorization: Basic $(echo -n ":$PAT" | base64)"

# Get all pipeline runs within the time range
BUILDS_URL="https://dev.azure.com/$ORGANIZATION/$PROJECT/_apis/build/builds?minTime=$START_TIME&maxTime=$END_TIME&7.1-preview.1"
#echo $BUILDS_URL

echo "Fetching pipeline runs from $START_TIME to $END_TIME..."
BUILD_IDS=$(curl -s -H "$AUTH_HEADER" "$BUILDS_URL" | jq -r '.value[].id')
BUILD_NAMES=($(echo "$BUILD_DATA" | jq -r '.value[].definition.name'))
#echo $BUILD_IDS
# Initialize an empty list for matched builds
MATCHED_BUILDS=()

# Loop through each build ID and check its agent
for BUILD_ID in $BUILD_IDS; do
    PIPELINE_URL="https://dev.azure.com/$ORGANIZATION/$PROJECT/_build/results?buildId=$BUILD_ID"
    TIMELINE_URL="https://dev.azure.com/$ORGANIZATION/$PROJECT/_apis/build/builds/$BUILD_ID/timeline?7.1-preview.1"
 #   echo "curl -s -H "$AUTH_HEADER" "$TIMELINE_URL" | jq -r '.records[] | select(.type=="Job") | .workerName' | head -n 1"
    WORKER_NAME=$(curl -s -H "$AUTH_HEADER" "$TIMELINE_URL" | jq -r '.records[] | select(.type=="Job") | .workerName' | head -n 1)
#    echo "Worker Name $WORKER_NAME"
    if [[ "$WORKER_NAME" == "$AGENT_NAME" ]]; then
        MATCHED_BUILDS+=("$BUILD_NAME | $BUILD_ID | $PIPELINE_URL")
        echo "✅ $BUILD_NAME (ID: $BUILD_ID) was executed on $AGENT_NAME"
    fi
done

# Display results
if [[ ${#MATCHED_BUILDS[@]} -eq 0 ]]; then
    echo "No pipeline runs were found on agent $AGENT_NAME within the specified time range."
else
    echo -e "\n📌 Pipeline runs executed on agent $AGENT_NAME:\n"
    printf "%-30s | %-10s | %s\n" "Pipeline Name" "Build ID" "Pipeline URL"
    echo "---------------------------------------------------------------------------------------------"
    for ENTRY in "${MATCHED_BUILDS[@]}"; do
        echo "$ENTRY"
    done
fi
