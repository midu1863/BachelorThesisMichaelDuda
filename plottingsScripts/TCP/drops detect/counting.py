import re
import glob
import matplotlib.pyplot as plt

def run():
    # Specify the file pattern (e.g., all files with a .pcap extension)
    file_pattern = '*packet.tot'

    # Use glob to get a list of files that match the pattern
    file_list = glob.glob(file_pattern)

    differences = []
    labels = []
    for i in range(0, len(file_list), 2):
        # Ensure that there are at least two elements left
        if i + 1 < len(file_list):
            file_1 = file_list[i]
            file_2 = file_list[i + 1]

            # Read the integer values from the files (replace this with your actual reading logic)
            with open(file_1, 'r') as file:
                number_1 = int(file.readline().strip())

            with open(file_2, 'r') as file:
                number_2 = int(file.readline().strip())
            label = ""
            tmp = file_1.split('.')[0].split('-'[0])
            if len(tmp) == 5:
                label = str(tmp[0] + " " + " " + tmp[1] + " " + tmp[3])
            else:
                label = str(tmp[0] + " " + tmp[2])
            # Print the difference between the two numbers
            difference = number_1 - number_2 
            percentage = difference/number_1
            differences.append(percentage)
            labels.append(label)    


    sorted_indices = sorted(range(len(labels)), key=lambda i: custom_sort(labels[i]))
    differences = [differences[i] for i in sorted_indices]
    labels = [labels[i] for i in sorted_indices]
    plt.bar(labels, differences, color='blue')
    plt.xlabel('Test scenario')
    plt.ylabel('(Ingress total-Egress total)/(Ingress total)')
    plt.title('Difference between Ingress and Egress on sw2')
    plt.xticks(rotation=45, ha='right')
    plt.savefig("dropsIntern.png", format="png", bbox_inches="tight")


def custom_sort(item):
    parts = re.findall(r'(\d+)([A-Za-z]+)', item)
    numeric_part = int(parts[0][0])
    string_part = parts[0][1]
    return (numeric_part, string_part)

def main():
    run()

if __name__ == "__main__":
    main()