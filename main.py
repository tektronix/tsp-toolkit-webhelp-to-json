import os
import json
import shutil
import sys
from Configuration import Confiurations
from ParserGeneric import HelperFunctions
import copy


def parse_web_help_files(webHelpFoldersDir):

    output_folder = "data"
    if os.path.exists(output_folder):
        shutil.rmtree(Confiurations.OUTPUT_FOLDER_PATH)
        os.makedirs(output_folder)
    else:
        os.makedirs(output_folder)
        

    for dir in os.listdir(webHelpFoldersDir):
        try:
            folder = os.path.join(webHelpFoldersDir, dir)
            if os.path.isdir(folder):
                if dir.split("_")[1] in Confiurations.SUPPORTED_MODELS:
                    Confiurations.HELP_FILE_FOLDER_PATH = folder
                    if str(dir).find("Commands_26XX")!= -1:
                        for model in Confiurations.MODEL_2600B_CHANNELS.keys():
                            Confiurations.MODEL_NUMBER = model
                            Confiurations.CHANNELS = Confiurations.MODEL_2600B_CHANNELS.get(model)
                            parse()

                    elif str(dir).find("Commands_2651A")!= -1 or str(dir).find("Commands_2657A")!= -1:
                        Confiurations.CHANNELS = Confiurations.MODEL_2650A_CHANNELS.get(dir.split("_")[1])
                        Confiurations.MODEL_NUMBER = dir.split("_")[1]
                        parse()
                    else:
                        Confiurations.MODEL_NUMBER = dir.split("_")[1]
                        parse()
                else:
                    print(dir.split("_")[1]+ " is not supported")

        except Exception as E:
            print(E)
        

def parse():
    description_list = []

    for filename in os.listdir(Confiurations.HELP_FILE_FOLDER_PATH):
        if filename.endswith('.htm') or filename.endswith('.html'):
        #if filename.endswith('.html'):                   # 70xB
            fname = os.path.join(Confiurations.HELP_FILE_FOLDER_PATH,filename)
            soup = HelperFunctions.Parser(fname)                    
            try:
                #command= soup.find_all("h2").pop(0).get_text()
                command= soup.find_all("h2","heading2-icl").pop(0).get_text().strip()
            except:
                command= ""

            if command == "*CLS" or command == "*ESR?" or command == "*OPC" or command == "*OPC?" or command == "*ESE" or  command == "*ESE?" or command == "*IDN?" or command == "*LANG?" or command == "*LANG" or command == "*RST" or  command == "*SRE?" or  command == "*SRE" or  command == "*STB?" or  command == "*TRG" or  command == "*TST?" or  command == "*WAI":
                continue

            """ txt = filename+ " -> " + x + "\n"    
            n = text_file.write(txt) """

            """ if "*" in command:
                txt = filename + " -> " + command + "\n"
                n = star_text_file.write(txt) """
            
            if "*" in command and "slot" in command:#available in 37xx model eg. slot[slot].endchannel.*
                star_command = ["amps","analogoutput","digitalio","isolated","totalizer","voltage"]                    
                star_desc = [
                    "Channel supports amperage measurements",
                    "Channel supports a digital analog output (DAC)",
                    "Channel supports digital inputs and outputs",
                    "Channel supports isolated channels",            
                    "Channel supports totalizer channels",
                    "Channel supports voltage or two-wire measurements"
                ]
                for x in range(0, 6):
                    explanation, usage, details, examples, related_commands, param_info, command_type, default_value, tsp_link = HelperFunctions.fetch_details(
                    command,soup)

                    explanation += star_desc[x] 
                    name = command.replace("*",star_command[x])

                    record = HelperFunctions.get_record(
                    name, filename, command_type, default_value, explanation, details, param_info, usage, examples, related_commands, tsp_link)

                    description_list.append(record)
            elif "*" in command and "localnode" in command:#available in 70xb model eg. localnode.define.*  
                localnode_star_command = ["MAX_TIMERS","MAX_DIO_LINES","MAX_TSPLINK_TRIGS","MAX_BLENDERS","MAX_BLENDER_INPUTS","MAX_LAN_TRIGS","MAX_CHANNEL_TRIGS"]     
                for x in range(0, 7):
                    explanation, usage, details, examples, related_commands, param_info, command_type, default_value, tsp_link = HelperFunctions.fetch_details(
                    command, soup)
                    
                    name = command.replace("*",localnode_star_command[x])

                    record = HelperFunctions.get_record(
                    name, filename, command_type, default_value, explanation, details, param_info, usage, examples, related_commands, tsp_link)

                    description_list.append(record)
            elif "*" in command and "status" in command:#available in 26xx model eg. status.operation.*
                status_star_command = ["condition","enable","event","ntr","ptr"]        
                status_star_command_type = ["Attribute (R)", "Attribute (RW)", "Attribute (R)", "Attribute (RW)", "Attribute (RW)"]
                
                channel = [""]

                if "smuX" in command:
                    channel = Confiurations.CHANNELS

                for ch in channel:
                    for x in range(0, 5):                
                        explanation, usage, details, examples, related_commands, param_info, command_type, default_value, tsp_link = HelperFunctions.fetch_details(
                        command, soup)

                        command_type = status_star_command_type[x]                                             
                        name = command.replace("*",status_star_command[x]).replace("X", ch)

                        record = HelperFunctions.get_record(
                                name,filename, command_type, default_value, explanation, details, param_info, usage, examples, related_commands, "Yes") # make tsplink as yes for all status* command since its getting wrong value in parsing
                        
                        description_list.append(record)

            elif "smuX" in command and "Y" not in command:
                explanation, usage, details, examples, related_commands, param_info, command_type, default_value, tsp_link = HelperFunctions.fetch_details(
                    command,soup)
                for x in Confiurations.CHANNELS:
                    name = command.replace("X", x)
                    usage1 = [sig.replace("X", x) for sig in usage]
                    parameter = copy.deepcopy(param_info)
                    for parm in parameter:
                                for key in parm:
                                    if parm[key] == 'X' or parm[key] =='Y':
                                        continue
                                    else:
                                        parm[key] = parm[key].replace("X",x)
                    """ temp_enum_datas = deepcopy(enum_datas)
                    for enum_data in temp_enum_datas:
                            new_enum = enum_data.get('enum').replace("X",x)
                            enum_data['enum'] = new_enum """                             
                    record = HelperFunctions.get_record(
                        name,filename, command_type, default_value, explanation, details, parameter, usage1, examples, related_commands,tsp_link)

                    description_list.append(record)
            
            elif "smuX" in command and "Y" in command: 
                #if "smuX.measure.rel.enableY"  in command:           
                explanation, usage, details, examples, related_commands, param_info, command_type, default_value, tsp_link = HelperFunctions.fetch_details(
                    command,soup)
                y_param_details = HelperFunctions.get_Y_param_options(
                    command, param_info, command_type, usage)

                usage_orignal = copy.deepcopy(usage)

                for x in Confiurations.CHANNELS:
                    for y in y_param_details:
                        if "iv" in y:
                            usage = [sig for sig in usage_orignal if "iv" in sig]
                        else:
                            usage = [sig for sig in usage_orignal if "Y" in sig]

                        name = command.replace("Y", y).replace("X", x)
                        usage1 = [sig.replace("Y", y).replace("X", x)
                                for sig in usage] 
                        parameter = copy.deepcopy(param_info)
                        for parm in parameter:
                            for key in parm:
                                if parm[key] == 'X' or parm[key] =='Y':
                                    continue
                                else:
                                    parm[key] = parm[key].replace("X",x).replace("Y",y)
                        """ temp_enum_datas = deepcopy(enum_datas)
                        for enum_data in temp_enum_datas:
                            new_enum = enum_data.get('enum').replace("X",x)
                            enum_data['enum'] = new_enum """                  
                        record = HelperFunctions.get_record(
                            name, filename, command_type, default_value, explanation, details, parameter, usage1, examples, related_commands,tsp_link)
                        # replace 'Y' with i,v,p,r in signature and uses and overloads and append recoed
                        description_list.append(record)
            elif "smu.source.xlimit" in command: # this command is having i,v as parameter that needs to handle sperately
                explanation, usage, details, examples, related_commands, param_info, command_type, default_value, tsp_link = HelperFunctions.fetch_details(
                    command,soup)
                for x in ["i", "v"]:
                    name = command.replace("x", x)
                    usage1 = [sig.replace("x", x) for sig in usage]
                    parameter = copy.deepcopy(param_info)                        
                    record = HelperFunctions.get_record(
                        name,filename, command_type, default_value, explanation, details, parameter, usage1, examples, related_commands,tsp_link)

                    description_list.append(record)
            else:
                if command != " " and command != '' """ and filename =="31093.htm" """:            
                    try:       
                        explanation, usage, details, examples, related_commands, param_info, command_type, default_value, tsp_link = HelperFunctions.fetch_details(
                            command, soup)
                        parameter = copy.deepcopy(param_info)
                        for parm in parameter:
                                for key in parm:                                
                                    if "smuX" in parm[key]:
                                        for x in Confiurations.CHANNELS:
                                            parm[key] = parm[key].replace("X",x)

                        record = HelperFunctions.get_record(
                            command, filename, command_type, default_value, explanation, details, parameter, usage, examples, related_commands,tsp_link)
                        #if "setblock()" not in command:
                        description_list.append(record)
                        #else:
                        #    setblock_list.append(record)
                    except Exception as e:
                        print(e)
                        print(command, "Not added to commands list\n File name: ", filename)

    description_list = {"commands": description_list}
    json_obj = json.dumps(description_list, indent=4)
    
    with open(os.path.join(Confiurations.OUTPUT_FOLDER_PATH, Confiurations.MODEL_NUMBER+".json"), 'w', newline='') as file:
        file.write(json_obj)
    print(os.path.join(Confiurations.OUTPUT_FOLDER_PATH, Confiurations.MODEL_NUMBER+".json"), "is successfully created")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python mian.py <webHelpFolders>")
        sys.exit(1)

    webHelpFoldersDir = sys.argv[1]
    parse_web_help_files(webHelpFoldersDir)