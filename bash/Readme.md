# Sciprt to fetch the Build Pipeline details running of specific Build Agent
- Execution
  ```
  $chmod +x ./agent_for_build_pipelines.sh
  $./agent_for_build_pipelines.sh

- Output
```
  Fetching pipeline runs from 2025-03-07T08:21:00Z to 2025-03-17T08:36:00Z...
✅  (ID: 168731) was executed on aks-agents-69df87b86-wm692
✅  (ID: 168728) was executed on aks-agents-69df87b86-wm692
✅  (ID: 168721) was executed on aks-agents-69df87b86-wm692
✅  (ID: 168710) was executed on aks-agents-69df87b86-wm692
✅  (ID: 168709) was executed on aks-agents-69df87b86-wm692
✅  (ID: 168704) was executed on aks-agents-69df87b86-wm692
✅  (ID: 168695) was executed on aks-agents-69df87b86-wm692
✅  (ID: 168673) was executed on aks-agents-69df87b86-wm692

📌 Pipeline runs executed on agent aks-agents-69df87b86-wm692:

Pipeline Name                  | Build ID   | Pipeline URL
---------------------------------------------------------------------------------------------
 | 168731 | https://dev.azure.com/{ORG}/{Project}/_build/results?buildId=168731
 | 168728 | https://dev.azure.com/{ORG}/{Project}/_build/results?buildId=168728
 | 168721 | https://dev.azure.com/{ORG}/{Project}/_build/results?buildId=168721
 | 168710 | https://dev.azure.com/{ORG}/{Project}/_build/results?buildId=168710
 | 168709 | https://dev.azure.com/{ORG}/{Project}/_build/results?buildId=168709
 | 168704 | https://dev.azure.com/{ORG}/{Project}/_build/results?buildId=168704
 | 168695 | https://dev.azure.com/{ORG}/{Project}/_build/results?buildId=168695
 | 168673 | https://dev.azure.com/{ORG}/{Project}/_build/results?buildId=168673
```
