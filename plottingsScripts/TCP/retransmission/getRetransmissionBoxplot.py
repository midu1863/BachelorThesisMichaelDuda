import glob
import matplotlib.pyplot as plt

# Replace '*.txt' with the actual file pattern you want to match
file_pattern = '*.rets'

# Use glob to get a list of files that match the pattern
file_list = glob.glob(file_pattern)
print(file_list)
# Create a subplot with len(file_list) subplots


# Iterate over files and create a histogram for each file
for i, file_path in enumerate(file_list):
    # Read the float values from the file
    with open(file_path, 'r') as file:
        float_values = [float(line.strip()) for line in file]
    fig, axes = plt.subplots()
    [x for x in float_values if x < 60.0]
    # Create a histogram for each file
    axes.hist(float_values,bins=60,  range=(0,60), color='blue', edgecolor='black')
    tmp = file_path.split('.')[0].split('-'[0])
    if len(tmp) == 5:
        tmp  = str(tmp[0] + " " + tmp[1])
    else:
        tmp = str(tmp[0])
    # Add labels and title for each subplot
    axes.set_yscale('log')
    axes.set_xlabel('Time in seconde')
    axes.set_ylabel('Counts of retransmission')
    axes.set_xlim(0, 60)
    axes.set_ylim(1,2100)
    
    axes.set_title(f'Histogram of retransmission over time - {tmp}')

    # Adjust layout for better spacing
    plt.tight_layout()
    # Show the plot
    plt.savefig(f'retransmissionsHistogram_{tmp}.png', format="png", bbox_inches="tight")