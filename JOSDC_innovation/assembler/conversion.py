
def decimal_to_32bit_binary(number):
    """
    Convert a 32-bit decimal number to a 32-bit binary representation.
    
    Args:
        number (int): A decimal number (must be in the range of 32-bit integers).
        
    Returns:
        str: A 32-bit binary representation of the number.
    """
    if not -2**31 <= number < 2**31:
        raise ValueError("Number out of range for 32-bit signed integer.")
    
    # Convert the number to a 32-bit binary string
    binary_representation = f"{number & 0xFFFFFFFF:032b}"
    return binary_representation


def hex_to_binary_32bit(hex_number):
    """
    Converts a 32-bit hexadecimal number to its binary representation.
    
    Args:
        hex_number (str): The 32-bit hexadecimal number as a string (e.g., "1A3F").
    
    Returns:
        str: The 32-bit binary representation of the hexadecimal number.
    """
    # Convert hex to int, then to binary, and ensure it is 32 bits with zfill
    binary_representation = bin(int(hex_number, 16))[2:].zfill(32)
    return binary_representation

def write_binary_to_file(binary_list, output_file,j):
    """
    Writes a list of 32-bit binary strings to a file with 64 lines.
    Fills the remaining lines with zeros if the list has fewer than 64 items.

    Args:
        binary_list (list): A list of 32-bit binary strings.
        output_file (str): Path to the output file.
    """
    # Ensure the binary list has 64 lines, filling with zeros if necessary
    while len(binary_list) < 64:
        binary_list.append('00000000000000000000000000000000')
    
    # Truncate the list to exactly 64 entries (in case it's longer)
    binary_list = binary_list[:64]

    # Write the binary strings to the file
    with open(output_file, 'w') as file:
        file.write('\n'.join(binary_list))
        file.write(f"\nnum_of_inst={j}")


def write_binary_to_file2(binary_list, output_file):
    """
    Writes a list of 32-bit binary strings to a file with 64 lines.
    Fills the remaining lines with zeros if the list has fewer than 64 items.

    Args:
        binary_list (list): A list of 32-bit binary strings.
        output_file (str): Path to the output file.
    """
    # Ensure the binary list has 64 lines, filling with zeros if necessary
    while len(binary_list) < 64:
        binary_list.append('00000000000000000000000000000000')
    
    # Truncate the list to exactly 64 entries (in case it's longer)
    binary_list = binary_list[:64]

    # Write the binary strings to the file
    with open(output_file, 'w') as file:
        file.write('\n'.join(binary_list))


def handle_pseudo(instructions):
    replaced_instructions = []
    for instruction in instructions:
        inst = instruction.split(' ', 1)
        if inst[0] == "bgez":
            rs, imm = inst[1].split(',')
            replaced_instructions.append(f"sgt $29,$0,{rs}")
            replaced_instructions.append(f"beq $29,$0,{imm}")
        elif inst[0] == "bltz":
            rs, imm = inst[1].split(',')
            replaced_instructions.append(f"slt $29,{rs},$0")
            replaced_instructions.append(f"bne $29,$0,{imm}")
        else:
            replaced_instructions.append(instruction)
    return replaced_instructions
def convert_to_binary(asm_instruction):
    print(asm_instruction, end=' --> ')
    if asm_instruction.lower().replace(' ', '') == "nop":
        print("00000000", end='\n')
        return "00000000"
    # R-Format Instructions
    R_Format = ["add", "sub", "and", "or", "slt", "nor", "sll", "srl", "jr", "xor", "sgt"]
    # I-Format Instructions
    I_Format = ["addi", "lw", "sw", "beq", "bne", "ori", "xori", "andi", "slti"]
    # J-Format Instructions
    J_Format = ["j", "jal"]

    funct_codes = {
        "add": "100000",
        "sub": "100010",
        "and": "100100",
        "or": "100101",
        "slt": "101010",
        "nor": "100111",
        "sll": "000000",
        "srl": "000010",
        "jr": "001000",
        "xor": "100110",
        "sgt": "101011"  # opcode given randomly because sgt is not included in MIPS green sheet
    }
    I_opcode = {
        "addi": "001000",
        "lw": "100011",
        "sw": "101011",
        "beq": "000100",
        "bne": "000101",
        "ori": "001101",
        "xori": "001110",
        "andi": "001100",
        "slti": "001010"
    }
    J_opcode = {
        "j": "000010",
        "jal": "000011"
    }

    opcode = "000000"
    rs = "00000"
    rt = "00000"
    rd = "00000"
    shamt = "00000"
    funct = ""
    imm = ""
    result = ""
    address = "00000000000000000000000000"
    # seperate the instruction according to the first space only

    inst = asm_instruction.split(' ', 1)
    # print("inst: ", inst)
    regs = inst[1].split(',')
    # if there is whitespace in the instruction, remove it from the list
    regs = [reg.replace(' ', '') for reg in regs]

    # print("regs: ", regs)
    # Pseudo instructions


    # I-Format instructions
    if inst[0] in I_Format:
        opcode = I_opcode[inst[0]]
        if inst[0] == "lw" or inst[0] == "sw":
            rt = format(int(regs[0][1:]), '05b')
            imm = format(int(regs[1].split('(')[0],0), '016b')
            rs = format(int(regs[1].split('(')[1][1:-1],0), '05b')
            result = opcode + rs + rt + imm
            print(format(int(result, 2), '08X'), end='\n')
            return format(int(result, 2), '08X')  # Return hex string without "0x" prefix
        if inst[0] == "beq" or inst[0] == "bne":
            rs = format(int(regs[0][1:]), '05b')
            rt = format(int(regs[1][1:]), '05b')
        else:
            rs = format(int(regs[1][1:]), '05b')
            rt = format(int(regs[0][1:]), '05b')
        imm_value = int(regs[2], 0)
        # to handle negative numbers
        if imm_value < 0:
            imm = format((1 << 16) + imm_value, '016b')
        else:
            imm = format(imm_value, '016b')
        result = opcode + rs + rt + imm
        print(format(int(result, 2), '08X'), end='\n')

        return format(int(result, 2), '08X')  # Return hex string without "0x" prefix

    # J-Format instructions (can handle hex or decimal addresses)
    elif inst[0] in J_Format:
        address = format(int(inst[1], 0), '026b')
        result = J_opcode[inst[0]] + address
        print(format(int(result, 2), '08X'), end='\n')

        return format(int(result, 2), '08X')  # Return hex string without "0x" prefix
    # R-Format instructions
    elif inst[0] in R_Format:
        if inst[0] == "sll" or inst[0] == "srl":
            rd = format(int(regs[0][1:]), '05b')
            rt = format(int(regs[1][1:]), '05b')
            shamt = format(int(regs[2], 0), '05b')
        elif inst[0] == "jr":
            rs = format(int(regs[0][1:]), '05b')
        else:
            rd = format(int(regs[0][1:]), '05b')
            rs = format(int(regs[1][1:]), '05b')
            rt = format(int(regs[2][1:]), '05b')
        funct = funct_codes[inst[0]]
        # print(f'opcode: {opcode}, rs: {rs}, rt: {rt}, rd: {rd}, shamt: {shamt}, funct: {funct}')
        result = opcode + rs + rt + rd + shamt + funct
        print(format(int(result, 2), '08X'), end='\n')
        return format(int(result, 2), '08X')  # Return hex string without "0x" prefix
