import os
def parse_register_file(file_path):
    """
    Parse a log file containing cycle-wise register content and return a dictionary.

    Args:
        file_path (str): Path to the log file.

    Returns:
        dict: Dictionary where keys are cycle numbers and values are lists of register values.
    """
    # Dictionary to store the results
    cycle_data = {}

    # Read and process the file
    with open(file_path, 'r') as file:
        lines = file.readlines()

    current_cycle = None
    registers = []

    for line in lines:
        line = line.strip()
        if line.startswith("reg content at cycle:"):
            # Store the previous cycle data if available
            if current_cycle is not None:
                cycle_data[current_cycle] = registers
            # Reset for new cycle
            current_cycle = int(line.split(":")[1].strip())
            registers = []
        elif line:  # If the line is not empty, assume it's a register value
            registers.append(int(line, 2))  # Convert binary to integer

    # Store the last cycle data
    if current_cycle is not None:
        cycle_data[current_cycle] = registers

    return cycle_data

# Example usage
# cycle_data = parse_register_file('/path/to/regfileoutput.log')
# print(cycle_data)


def align_cycle_accurate_data(cycle_accurate_data):
    """
    Shift the cycle-accurate data by one cycle to align it with the hardware data.

    Args:
        cycle_accurate_data (dict): Cycle-accurate data dictionary.

    Returns:
        dict: Shifted cycle-accurate data dictionary.
    """
    aligned_data = {}
    previous_registers = []

    for cycle in sorted(cycle_accurate_data.keys()):
        # Align the current cycle to the next cycle's data
        aligned_data[cycle + 1] = previous_registers
        previous_registers = cycle_accurate_data[cycle]

    # Remove the first "unrealistic" cycle
    if 1 in aligned_data:
        del aligned_data[1]

    return aligned_data

cycle_accurate_reg_data=parse_register_file(os.path.join(os.path.dirname(__file__), 'regfileoutput.log'))

num_of_cycles=len(cycle_accurate_reg_data)


def parse_register_file2(file_path, max_cycles=None):
    """
    Parse a log file containing cycle-wise register content and return a dictionary.

    Args:
        file_path (str): Path to the log file.
        max_cycles (int, optional): Maximum number of cycles to parse. If None, parse all cycles.

    Returns:
        dict: Dictionary where keys are cycle numbers and values are lists of register values.
    """
    # Dictionary to store the results
    cycle_data = {}

    # Read and process the file
    with open(file_path, 'r') as file:
        lines = file.readlines()

    current_cycle = None
    registers = []
    cycle_count = 0

    for line in lines:
        line = line.strip()
        if line.startswith("Register file content at cycle"):
            # Stop parsing if max_cycles is reached
            if max_cycles is not None and cycle_count >= max_cycles:
                break

            # Store the previous cycle data if available
            if current_cycle is not None:
                cycle_data[current_cycle] = registers

            
            current_cycle = int(line.split(":")[-1].strip())
            

            registers = []
            cycle_count += 1
        elif line:  # If the line is not empty, assume it's a register value
            try:
                registers.append(int(line, 2))  # Convert binary to integer
            except ValueError:
                print(f"Warning: Invalid register value in line: '{line}'")

    # Store the last cycle data if within max_cycles
    if current_cycle is not None and (max_cycles is None or cycle_count <= max_cycles):
        cycle_data[current_cycle] = registers

    return cycle_data




hardware_reg = parse_register_file2(os.path.join(os.path.dirname(__file__), "..","simulation","modelsim",'registerfile_output.txt'), max_cycles=num_of_cycles+2)


def are_dicts_equal(dict1, dict2):
    """
    Compares two dictionaries and returns True if they are the same, otherwise False.

    :param dict1: First dictionary to compare.
    :param dict2: Second dictionary to compare.
    :return: True if dictionaries are the same, False otherwise.
    """
    return dict1 == dict2


def normalize_binary_content(file_path):
    with open(file_path, 'r') as f:
        lines = f.readlines()
    # Filter and clean lines to only include binary content
    binary_lines = [line.strip() for line in lines if set(line.strip()).issubset({'0', '1'})]
    return ''.join(binary_lines)  # Combine all binary content into a single string for comparison

cycle_mem=normalize_binary_content(os.path.join(os.path.dirname(__file__),'memout.log'))

harwaremem=normalize_binary_content(os.path.join(os.path.dirname(__file__), "..","simulation","modelsim",'memcontent.mem'))





if (hardware_reg[len(hardware_reg)-1]==cycle_accurate_reg_data[len(cycle_accurate_reg_data)-1]):
    print("passed")

else:
    print("falied")





