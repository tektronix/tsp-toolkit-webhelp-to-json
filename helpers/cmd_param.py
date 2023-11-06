

def getParamTypeDetails(filePath):
    cmd_param_Type = {}

    with open(filePath) as text_file:
        key = ""
        value = []
        for line in text_file.readlines():
            if line == "\n":
                continue
            line = line.replace("\n","").rstrip().lstrip()
            if "()" in line or "." in line or "-" in line:
                cmd_param_Type[key] = ",".join(value)
                key = line
                value = []
            else:
                value.append(line)

        cmd_param_Type[key] = ",".join(value)

    return cmd_param_Type



