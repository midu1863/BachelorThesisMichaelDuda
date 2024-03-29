import re
import glob
import matplotlib.pyplot as plt


def plot():
    file_list = glob.glob('*.queue')

    for i, file_path in enumerate(file_list):
        print(file_path)
        unique_numbers = []
        max_values_list = []
        fig, axes = plt.subplots()
        with open(file_path, 'r') as file:
            skip_first_line = True  # Flag to skip the first line
            list1 = []
            list2 = []
            # Iterate over the lines
            for line in file:
                # Skip the first line
                if skip_first_line:
                    skip_first_line = False
                    continue

                # Assuming values are separated by a space
                try:
                    value1, value2 = map(int, line.strip().split())
                    list1.append(value1)
                    list2.append(value2)
                except ValueError:
                    print(f"Skipping invalid line: {line}")

            #change epoch time to second
            list1 = [element - list1[0] for element in list1] 
            # filter the time interval from the run
            filtered_list1 = [element for element in list1 if 1<= element <= 65]
            filtered_list2 = [val2 for val1, val2 in zip(list1, list2) if 1 <= val1 <= 65]
            #print(filtered_list2)
            #filter the hight value per second 
            # Iterate over both lists
            max_values = {}
            for num, val in zip(filtered_list1, filtered_list2):
                # Check if the number is in the dictionary and update its value if necessary
                if num not in max_values or val > max_values[num]:
                    max_values[num] = val
            unique_numbers = list(max_values.keys())
            max_values_list = list(max_values.values())

            
        tmp = file_path.split('.')[0].split('-'[0])
        if len(tmp) == 3:
            tmp = str(tmp[0] + " " + tmp[1])
        else:
            tmp = str(tmp[0])

        axes.plot(unique_numbers, max_values_list, marker='o', linestyle='-')
        axes.set_xlabel('Time in second')
        axes.set_ylabel('Queue size')
        axes.set_xlim(0, 61)
        axes.set_ylim(1,3000)
        axes.set_title(f'Queue size over time: {tmp}')
        plt.savefig(str(tmp) +".png", format="png", bbox_inches="tight")
        plt.close()


def custom_sort(item):
    parts = re.findall(r'(\d+)([A-Za-z]+)', item)
    numeric_part = int(parts[0][0])
    string_part = parts[0][1]
    return (numeric_part, string_part)


def main():
    plot()

if __name__ == "__main__":
    main()
