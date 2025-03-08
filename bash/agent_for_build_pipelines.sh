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

echo "Fetching pipeline runs from $START_TIME to $END_TIME..."
BUILD_DATA=$(curl -s -H "$AUTH_HEADER" "$BUILDS_URL")

# Extract Build IDs and Names
BUILD_IDS=($(echo "$BUILD_DATA" | jq -r '.value[].id'))
BUILD_NAMES=($(echo "$BUILD_DATA" | jq -r '.value[].definition.name'))

# Initialize an empty list for matched builds
MATCHED_BUILDS=()

# Define column widths for formatting
COL1_WIDTH=40  # Pipeline Name
COL2_WIDTH=10  # Build ID
COL3_WIDTH=60  # Pipeline URL

# Loop through each build ID and check its agent
for INDEX in "${!BUILD_IDS[@]}"; do
    BUILD_ID=${BUILD_IDS[$INDEX]}
    BUILD_NAME=${BUILD_NAMES[$INDEX]}

    TIMELINE_URL="https://dev.azure.com/$ORGANIZATION/$PROJECT/_apis/build/builds/$BUILD_ID/timeline?7.1-preview.1"
    RESPONSE=$(curl -s -H "$AUTH_HEADER" "$TIMELINE_URL")

    # Check if response is empty or invalid
    if [[ -z "$RESPONSE" || "$RESPONSE" == "null" ]]; then
        echo "❌ Empty response for Build ID $BUILD_ID (Skipping...)"
        continue
    fi

    # Check if the response contains "records"
    if ! echo "$RESPONSE" | jq -e '.records' > /dev/null; then
        echo "❌ No 'records' field in timeline for Build ID $BUILD_ID (Skipping...)"
        continue
    fi

    # Extract the agent name
    WORKER_NAME=$(echo "$RESPONSE" | jq -r '.records[]? | select(.type=="Job") | .workerName' | head -n 1)

    if [[ "$WORKER_NAME" == "$AGENT_NAME" ]]; then
        PIPELINE_URL="https://dev.azure.com/$ORGANIZATION/$PROJECT/_build/results?buildId=$BUILD_ID"
        MATCHED_BUILDS+=("$BUILD_NAME | $BUILD_ID | $PIPELINE_URL")
        echo "✅ $BUILD_NAME (ID: $BUILD_ID) was executed on $AGENT_NAME"
    fi
done

# Display results in a properly formatted table
if [[ ${#MATCHED_BUILDS[@]} -eq 0 ]]; then
    echo "No pipeline runs were found on agent $AGENT_NAME within the specified time range."
else
    echo -e "\n📌 Pipeline runs executed on agent $AGENT_NAME:\n"

    # Print header
    printf "%-${COL1_WIDTH}s | %-${COL2_WIDTH}s | %-${COL3_WIDTH}s\n" "Pipeline Name" "Build ID" "Pipeline URL"
    printf -- "-%.0s" $(seq 1 $((COL1_WIDTH + COL2_WIDTH + COL3_WIDTH + 6)))  # Print separator line
    echo

    # Print each pipeline entry
    for ENTRY in "${MATCHED_BUILDS[@]}"; do
        IFS='|' read -r NAME ID URL <<< "$ENTRY"
        printf "%-${COL1_WIDTH}s | %-${COL2_WIDTH}s | %-${COL3_WIDTH}s\n" "$NAME" "$ID" "$URL"
    done
fi
