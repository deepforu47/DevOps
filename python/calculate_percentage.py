__author__ = "Kuldeep Sharma"
__license__ = "GPL"
__version__ = "1.0.0"
__maintainer__ = "Kuldeep Sharma"
__status__ = "Production"
import re
with open("prometheusData-android.txt") as f:
    # Fetch first 5 lines from file
    lines = [next(f) for x in range(5)]

# Look for the line having string in "passed"
for match in lines:
    if re.match("(.*)passed(.*)", match):
        passed=int(match.split()[-1])

# Fetch last column
def extract_last_int(line):
    return int(line.split()[-1])

# Find out the total number of test cases
total=sum(map(extract_last_int, lines))

# Find out the Percentage
percentage = (passed / total) * 100

print(percentage)
