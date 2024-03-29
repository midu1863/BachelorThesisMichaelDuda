import os
import glob
import matplotlib.pyplot as plt
import re

# Define the file pattern (e.g., all files with a .txt extension)
file_pattern = '*.rets'

# Use glob to get a list of files that match the pattern
file_list = glob.glob(file_pattern)
print(file_list)
values = []
labels = []

# Iterate through selected files
for filepath in file_list:
    # Read the single value from the file
    with open(filepath, 'r') as file:
        value_1 = int(file.readline().strip())
        value_2 = int(file.readline().strip())

    percentage = value_2 / value_1
    print(percentage)
    values.append(percentage)
    tmp = filepath.split('.')[0].split('-'[0])
    if len(tmp) == 5:
        labels.append(str(tmp[0] + " " + " " + tmp[1]))
    else:
        labels.append(str(tmp[0]))

# Define a custom sort function for labels
def custom_sort(item):
    parts = re.findall(r'(\d+)([A-Za-z]+)', item)
    numeric_part = int(parts[0][0])
    string_part = parts[0][1]
    return (numeric_part, string_part)

# Use the custom sort function to reorder labels and values
sorted_indices = sorted(range(len(labels)), key=lambda i: custom_sort(labels[i]))
labels = [labels[i] for i in sorted_indices]
values = [values[i] for i in sorted_indices]

# Create a bar diagram for each value
plt.bar(labels, values, color='blue')

# Add labels and title
#plt.yscale('log')
plt.ylabel('Count of retransmission packet')
plt.xlabel('Test scenario')
plt.xticks(rotation=45)
plt.savefig("retransmissions.png", format="png", bbox_inches="tight")
