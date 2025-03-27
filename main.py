import os
import json
import shutil
import sys
from Configuration import Configuration
from helpers import HelperFunctions
import copy
from helpers import cmd_param
import traceback

# Constants for model identifiers
MODEL_2600 = "2600B"
MODEL_MP5103 = "MP5103"
MODEL_MSMU60_2 = "MSMU60-2"

def parse_web_help_files(webHelpFoldersDir):
    output_folder = "data"
    if os.path.exists(output_folder):
        shutil.rmtree(output_folder)
    os.makedirs(output_folder)

    for dir in os.listdir(webHelpFoldersDir):
        try:
            folder = os.path.join(webHelpFoldersDir, dir)
            if os.path.isdir(folder):
                if dir in Configuration.SUPPORTED_MODELS:
                    Configuration.HELP_FILE_FOLDER_PATH = folder
                    if MODEL_2600 in dir:
                        for model in Configuration.MODEL_2600B_MODELS:
                            Configuration.MODEL_NUMBER = model
                            Configuration.CHANNELS = Configuration.MODEL_CHANNELS.get(model)
                            parse()
                    else:
                        Configuration.CHANNELS = Configuration.MODEL_CHANNELS.get(dir)
                        Configuration.MODEL_NUMBER = dir
                        parse()
                else:
                    print(f"{dir} is not supported")
        except Exception as e:
            print(f"An error occurred while processing {dir}: {e}")
            traceback.print_exc()

def parse():
    description_list = []

    def load_configuration_files(model_number):
        if MODEL_2600 in model_number:
            base_path = os.path.join("resources", "2600")
        elif MODEL_MP5103 in model_number:
            base_path = os.path.join("resources", "trebuchet")
        elif MODEL_MSMU60_2 in model_number:
            base_path = os.path.join("resources", "trebuchet", MODEL_MSMU60_2)
        else:
            base_path = os.path.join("resources", "tti")

        Configuration.PARAMS_TYPES_DETAILS = cmd_param.getParamTypeDetails(os.path.join(base_path, "command_param_data_type.txt"))
        Configuration.MANUALLY_EXTRACTED_COMMANDS = HelperFunctions.parse_manual_json(os.path.join(base_path, "manually_extracted_cmd_and_enums.json"))

    load_configuration_files(Configuration.MODEL_NUMBER)

    for filename in os.listdir(Configuration.HELP_FILE_FOLDER_PATH):
        if filename.endswith(('.htm', '.html')):
            fname = os.path.join(Configuration.HELP_FILE_FOLDER_PATH, filename)
            soup = HelperFunctions.Parser(fname)
            try:
                command = soup.find_all("h2", "heading2-icl").pop(0).get_text().strip()
            except:
                command = ""

            if MODEL_MSMU60_2 in  Configuration.MODEL_NUMBER and "slot[Z]" in command:
                command = command.replace("slot[Z].", "")
            try:
                if Configuration.MODEL_NUMBER == "2601B-PULSE" and 'smua.' in command:
                    command = command.replace("smua", "smuX")

                if command in ["*CLS", "*ESR?", "*OPC", "*OPC?", "*ESE", "*ESE?", "*IDN?", "*LANG?", "*LANG", "*RST", "*SRE?", "*SRE", "*STB?", "*TRG", "*TST?", "*WAI"]:
                    continue

                def process_command(command, filename, description_list):
                    explanation, usage, details, examples, related_commands, param_info, command_type, default_value, tsp_link = HelperFunctions.fetch_details(command, soup)
                    record = HelperFunctions.get_record(command, filename, command_type, default_value, explanation, details, param_info, usage, examples, related_commands, tsp_link)
                    description_list.append(record)

                if "*" in command:
                    if "slot" in command:
                        star_command = ["amps", "analogoutput", "digitalio", "isolated", "totalizer", "voltage"]
                        star_desc = [
                            "Channel supports amperage measurements",
                            "Channel supports a digital analog output (DAC)",
                            "Channel supports digital inputs and outputs",
                            "Channel supports isolated channels",
                            "Channel supports totalizer channels",
                            "Channel supports voltage or two-wire measurements"
                        ]
                        for x in range(6):
                            explanation, usage, details, examples, related_commands, param_info, command_type, default_value, tsp_link = HelperFunctions.fetch_details(command, soup)
                            explanation += star_desc[x]
                            name = command.replace("*", star_command[x])
                            record = HelperFunctions.get_record(name, filename, command_type, default_value, explanation, details, param_info, usage, examples, related_commands, tsp_link)
                            description_list.append(record)
                    elif "localnode" in command:
                        localnode_star_command = ["MAX_TIMERS", "MAX_DIO_LINES", "MAX_TSPLINK_TRIGS", "MAX_BLENDERS", "MAX_BLENDER_INPUTS", "MAX_LAN_TRIGS", "MAX_CHANNEL_TRIGS"]
                        for x in range(7):
                            explanation, usage, details, examples, related_commands, param_info, command_type, default_value, tsp_link = HelperFunctions.fetch_details(command, soup)
                            name = command.replace("*", localnode_star_command[x])
                            record = HelperFunctions.get_record(name, filename, command_type, default_value, explanation, details, param_info, usage, examples, related_commands, tsp_link)
                            description_list.append(record)
                    elif "status" in command:
                        status_star_command = ["condition", "enable", "event", "ntr", "ptr"]
                        status_star_command_type = ["Attribute (R)", "Attribute (RW)", "Attribute (R)", "Attribute (RW)", "Attribute (RW)"]
                        channel = [""] if "smuX" not in command else Configuration.CHANNELS
                        for ch in channel:
                            for x in range(5):
                                explanation, usage, details, examples, related_commands, param_info, command_type, default_value, tsp_link = HelperFunctions.fetch_details(command, soup)
                                command_type = status_star_command_type[x]
                                name = command.replace("*", status_star_command[x]).replace("X", ch)
                                record = HelperFunctions.get_record(name, filename, command_type, default_value, explanation, details, param_info, usage, examples, related_commands, "Yes")
                                description_list.append(record)
                elif "smuX" in command or "smu[X]" in command:
                    if "Y" not in command:
                        explanation, usage, details, examples, related_commands, param_info, command_type, default_value, tsp_link = HelperFunctions.fetch_details(command, soup)
                        for x in Configuration.CHANNELS:
                            name = command.replace("X", x)
                            usage1 = [sig.replace("X", x) for sig in usage]
                            parameter = copy.deepcopy(param_info)
                            for parm in parameter:
                                for key in parm:
                                    if parm[key] not in ['X', 'Y']:
                                        if isinstance(parm[key], str):
                                            parm[key] = parm[key].replace("X", x)
                                        elif isinstance(parm[key], list):
                                            parm[key] = [{**i, "name": i["name"].replace("X", x)} for i in parm[key]]
                            record = HelperFunctions.get_record(name, filename, command_type, default_value, explanation, details, parameter, usage1, examples, related_commands, tsp_link)
                            description_list.append(record)
                    else:
                        explanation, usage, details, examples, related_commands, param_info, command_type, default_value, tsp_link = HelperFunctions.fetch_details(command, soup)
                        y_param_details = HelperFunctions.get_Y_param_options(command, param_info, command_type, usage)
                        usage_orignal = copy.deepcopy(usage)
                        for x in Configuration.CHANNELS:
                            for y in y_param_details:
                                usage = [sig for sig in usage_orignal if "iv" in sig] if "iv" in y else [sig for sig in usage_orignal if "Y" in sig]
                                name = command.replace("Y", y).replace("X", x)
                                usage1 = [sig.replace("Y", y).replace("X", x) for sig in usage]
                                parameter = copy.deepcopy(param_info)
                                for parm in parameter:
                                    for key in parm:
                                        if parm[key] not in ['X', 'Y']:
                                            if isinstance(parm[key], str):
                                                parm[key] = parm[key].replace("X", x).replace("Y", y)
                                            elif isinstance(parm[key], list):
                                                parm[key] = [{**i, "name": i["name"].replace("X", x).replace("Y", y)} for i in parm[key]]
                                record = HelperFunctions.get_record(name, filename, command_type, default_value, explanation, details, parameter, usage1, examples, related_commands, tsp_link)
                                description_list.append(record)
                elif "smu.source.xlimit" in command:
                    explanation, usage, details, examples, related_commands, param_info, command_type, default_value, tsp_link = HelperFunctions.fetch_details(command, soup)
                    for x in ["i", "v"]:
                        name = command.replace("x", x)
                        usage1 = [sig.replace("x", x) for sig in usage]
                        record = HelperFunctions.get_record(name, filename, command_type, default_value, explanation, details, param_info, usage1, examples, related_commands, tsp_link)
                        description_list.append(record)
                elif "bufferVar.fillmode" in command and MODEL_2600 in Configuration.MODEL_NUMBER:
                    explanation, usage, details, examples, related_commands, param_info, command_type, default_value, tsp_link = HelperFunctions.fetch_details(command, soup)
                    param_info[0]["enum"] = [{"name": i.replace("X", ch), "description": "", "value": ""} for ch in Configuration.CHANNELS for i in ["smuX.FILL_ONCE", "smuX.FILL_WINDOW"]]
                    record = HelperFunctions.get_record(command, filename, command_type, default_value, explanation, details, param_info, usage, examples, related_commands, tsp_link)
                    description_list.append(record)
                elif "buffer.math()" in command:
                    explanation, usage, details, examples, related_commands, param_info, command_type, default_value, tsp_link = HelperFunctions.fetch_details(command, soup)
                    math_exp_param = {
                        "name": "mathExpression",
                        "description": "math expression parameter",
                        "type": "mathExpression",
                        "range": "",
                        "enum": [{"name": enum['name'], "value": enum['value'], "description": enum['description']} for enum in Configuration.MANUALLY_EXTRACTED_COMMANDS[command]["param_info"]["mathExpression"]["enum"]]
                    }
                    param_info.append(math_exp_param)
                    record = HelperFunctions.get_record(command, filename, command_type, default_value, explanation, details, param_info, usage, examples, related_commands, tsp_link)
                    record["signature"] = "buffer.math(readingBuffer, unit, mathExpression, ...)"
                    record["overloads"] = []
                    description_list.append(record)
                else:
                    process_command(command, filename, description_list)
            
            except Exception as e:
                print("\n***exception start")
                print(e)
                print(f"{command} not added to commands list\n File name: {filename}")
                print("***exception end\n")

                        
    description_list = {"commands": description_list}
    json_obj = json.dumps(description_list, indent=4)
    with open(os.path.join(Configuration.OUTPUT_FOLDER_PATH, f"{Configuration.MODEL_NUMBER}.json"), 'w', newline='') as file:
        file.write(json_obj)
    print(f"{os.path.join(Configuration.OUTPUT_FOLDER_PATH, Configuration.MODEL_NUMBER)}.json is successfully created")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python main.py <webHelpFolders>")
        sys.exit(1)

    webHelpFoldersDir = sys.argv[1]
    if not os.path.isdir(webHelpFoldersDir):
        print(f"Error: {webHelpFoldersDir} is not a valid directory")
        sys.exit(1)

    parse_web_help_files(webHelpFoldersDir)