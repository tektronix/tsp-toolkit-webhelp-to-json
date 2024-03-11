

def getParamTypeDetails(filePath):
    cmd_param_Type = {}

    with open(filePath) as text_file:
        key = ""
        value = []
        for line in text_file.readlines():
            if line == "\n":
                continue
            line = line.replace("\n","").rstrip().lstrip()
            if ("()" in line or "." in line or "-" in line) and ("|" not in line) and ("..." not in line):
                cmd_param_Type[key] = ",".join(value)
                key = line
                value = []
            else:
                value.append(line)

        cmd_param_Type[key] = ",".join(value)

    return cmd_param_Type


def setParamtype(cmd, param, type_str):
    file_path = 'ParserGeneric\\tti-command_param_data_type copy.txt'


    # Read the content of the file
    with open(file_path, 'r') as file:
        lines = file.readlines()

    # Find the starting index of the command block
    start_index = -1
    end_index = -1
    for i, line in enumerate(lines):
        if cmd in line:
            start_index = i
            continue
        if (start_index != -1) and ("()" in line or "." in line or "-" in line):
            end_index = i
            break

    if start_index != -1:
        # Check if the parameter already exists for the command
        param_exists = False
        for i in range(start_index + 1, end_index):
            line = lines[i]
            if line.strip().startswith(param + ':'):
                # Update the type for the existing parameter
                lines[i] = f'{param}: {type_str}\n'
                param_exists = True
                break
        
        # If the parameter doesn't exist, add it to the command block
        if not param_exists:
            lines.insert(start_index + 1, f'{param}: {type_str}\n')
    else:
        # If the command is not found, add it along with the parameter and type
        lines.append(f'\n{cmd}\n{param}: {type_str}\n')

    # Write the updated content back to the file
    with open(file_path, 'w') as file:
        file.writelines(lines)
