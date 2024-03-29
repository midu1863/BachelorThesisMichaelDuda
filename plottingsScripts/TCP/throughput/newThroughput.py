import re
import glob
import matplotlib.pyplot as plt

def parse_throughput_file(file_path):
    lns = []
    lns2 = []
    fig, ax = plt.subplots(figsize=(12, 6))
    
    for fl in sorted(file_path, reverse=True):
        print(fl)
        with open(fl, 'r') as file:
            content = file.read()

        # Use regular expressions to extract the relevant information
        data_matches = re.findall(r'\| *(\d+\.\d+) <> (\d+\.\d+) *\| *(\d+) *\|', content)
        number_matches = re.finditer(r'[-+]?\d*\.\d+|\d+', content)

        # Extract and store the numbers in the order they are found
        numbers = [match.group() for match in number_matches]
        numbers = numbers[4:]
        numbers = [float(element) for element in numbers]

        tmp = fl.split('.')[0].split('-'[0])
        if len(tmp) == 5:
            lns2.append(str(tmp[0] + " " + " " + tmp[1] + " " + tmp[3]))
        else:
            lns2.append(str(tmp[0] + " " + tmp[2]))
        
        x_values = numbers[0::3]
        x_values = [x for x in x_values if x < 60.0]
        y_values = numbers[2::3]

        if len(x_values) > len(y_values):
            x_values = x_values[:len(y_values)]
        elif len(x_values) < len(y_values):
            y_values = y_values[:len(x_values)]
        lns.append([(element * 8/1000/1000/0.1) for element in y_values])

    # Sort lns and lns2 based on the custom sort function
    sorted_indices = sorted(range(len(lns2)), key=lambda i: custom_sort(lns2[i]))
    lns = [lns[i] for i in sorted_indices]
    lns2 = [lns2[i] for i in sorted_indices]

    ax.boxplot(lns)
    ax.set_ylabel('Throughput (Mbps)')
    plt.title('Throughput on egress of sw2')
    #ax.set_yscale('log')
    #ax.set_ylim(40,70)
    ax.set_xticklabels(lns2, rotation=45, fontsize=8)

    fig.savefig("newThroughput.png", format="png", bbox_inches="tight")

def custom_sort(item):
    parts = re.findall(r'(\d+)([A-Za-z]+)', item)
    numeric_part = int(parts[0][0])
    string_part = parts[0][1]
    return (numeric_part, string_part)

def main():
    tput_files = glob.glob('*.ttput')
    print(tput_files)
    parse_throughput_file(tput_files)

if __name__ == "__main__":
    main()
