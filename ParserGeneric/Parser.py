import os
import json
from bs4 import BeautifulSoup
from ParserGeneric import HelperFunctions
import copy

#directory ="C:\\Users\\PRIV\\Documents\\TTI Help Doc\\Commands_DAQ6510"
directory ="C:\\TeaspoonRepo\\web-help-documents\\WebHelpDocs\\Commands_2470"
""" text_file = open("C:\TeaspoonRepo\web-help-document-to-json\Model_3XXX\sample.txt", "a")
star_text_file = open("C:\TeaspoonRepo\web-help-document-to-json\Model_3XXX\star_commands.txt", "a") """
description_list = []
setblock_list =[]
#json_file_name = "Commands_26XX.json"
json_file_name = directory.split("\\")[4] + ".json"
model = 2470

for filename in os.listdir(directory):
    if filename.endswith('.htm'):
    #if filename.endswith('.html'):                   # 70xB
        fname = os.path.join(directory,filename)
        soup = HelperFunctions.Parser(fname)                    
        try:
            #command= soup.find_all("h2").pop(0).get_text()
            command= soup.find_all("h2","heading2-icl").pop(0).get_text()
        except:
            command= ""

        if command == "*CLS" or command == "*ESR?" or command == "*OPC" or command == "*OPC?" or command == "*ESE" or  command == "*ESE?" or command == "*IDN?" or command == "*LANG?" or command == "*LANG" or command == "*RST" or  command == "*SRE?" or  command == "*SRE" or  command == "*STB?" or  command == "*TRG" or  command == "*TST?" or  command == "*WAI":
            continue

        """ txt = filename+ " -> " + x + "\n"    
        n = text_file.write(txt) """

        """ if "*" in command:
            txt = filename + " -> " + command + "\n"
            n = star_text_file.write(txt) """
        
        if "*" in command and "slot" in command:
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
                name, filename, command_type, default_value, explanation, details, param_info, usage, examples, related_commands, tsp_link, model)

                description_list.append(record)
        elif "*" in command and "localnode" in command:        
            localnode_star_command = ["MAX_TIMERS","MAX_DIO_LINES","MAX_TSPLINK_TRIGS","MAX_BLENDERS","MAX_BLENDER_INPUTS","MAX_LAN_TRIGS","MAX_CHANNEL_TRIGS"]     
            for x in range(0, 7):
                explanation, usage, details, examples, related_commands, param_info, command_type, default_value, tsp_link = HelperFunctions.fetch_details(
                command, soup)
                
                name = command.replace("*",localnode_star_command[x])

                record = HelperFunctions.get_record(
                name, filename, command_type, default_value, explanation, details, param_info, usage, examples, related_commands, tsp_link, model)

                description_list.append(record)
        elif "*" in command and "status" in command:    
            status_star_command = ["condition","enable","event","ntr","ptr"]        
            status_star_command_type = ["Attribute (R)", "Attribute (Rw)", "Attribute (R)", "Attribute (RW)", "Attribute (RW)"]        
            for x in range(0, 5):                
                explanation, usage, details, examples, related_commands, param_info, command_type, default_value, tsp_link = HelperFunctions.fetch_details(
                command, soup)

                command_type = status_star_command_type[x]                                             
                name = command.replace("*",status_star_command[x])

                record = HelperFunctions.get_record(
                        name,filename, command_type, default_value, explanation, details, param_info, usage, examples, related_commands, tsp_link,model)
                
                description_list.append(record)

        elif "smuX" in command and "Y" not in command:
            explanation, usage, details, examples, related_commands, param_info, command_type, default_value, tsp_link = HelperFunctions.fetch_details(
                command,soup)
            for x in ["a", "b"]:
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
                    name,filename, command_type, default_value, explanation, details, parameter, usage1, examples, related_commands,tsp_link,model)

                description_list.append(record)
        
        elif "smuX" in command and "Y" in command: 
            #if "smuX.measure.rel.enableY"  in command:           
            explanation, usage, details, examples, related_commands, param_info, command_type, default_value, tsp_link = HelperFunctions.fetch_details(
                command,soup)
            y_param_details = HelperFunctions.get_Y_param_options(
                command, param_info, command_type, usage)

            for x in ["a", "b"]:
                for y in y_param_details:
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
                        name, filename, command_type, default_value, explanation, details, parameter, usage1, examples, related_commands,tsp_link,model)
                    # replace 'Y' with i,v,p,r in signature and uses and overloads and append recoed
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
                                    for x in ["a", "b"]:
                                        parm[key] = parm[key].replace("X",x)

                    record = HelperFunctions.get_record(
                        command, filename, command_type, default_value, explanation, details, parameter, usage, examples, related_commands,tsp_link, model)
                    #if "setblock()" not in command:
                    description_list.append(record)
                    #else:
                    #    setblock_list.append(record)
                except Exception as e:
                    print(e)
                    print(command, "Not added to commands list\n File name: ", filename)

#text_file.close()
#star_text_file.close()
supportedInstrumentsList = {
            "2601",
            "2602",
            "2611",
            "2612",
            "2635",
            "2636",
            "2601A",
            "2602A",
            "2611A",
            "2612A",
            "2635A",
            "2636A",
            "2651A",
            "2657A",
            "2601B",
            "2601B-PULSE",
            "2602B",
            "2606B",
            "2611B",
            "2612B",
            "2635B",
            "2636B",
            "2604B",
            "2614B",
            "2634B",
            "2601B-L",
            "2602B-L",
            "2611B-L",
            "2612B-L",
            "2635B-L",
            "2636B-L",
            "2604B-L",
            "2614B-L",
            "2634B-L"
        }

output_json_file_path = os.getcwd()
#description_list = {"commands": description_list, "setblock_commands":setblock_list}
description_list = {"commands": description_list}
json_obj = json.dumps(description_list, indent=4)
output_json_file_path =  output_json_file_path+'/data/'+ json_file_name
with open(output_json_file_path, 'w', newline='') as file:
    file.write(json_obj)
""" if "2600" in directory:
    for item in supportedInstrumentsList:
        path = output_json_file_path + '/data/'+ item + "commands.json"
        #output_json_file_path =  output_json_file_path +
        with open(path, 'w', newline='') as file:
            file.write(json_obj)
        print("json file",item, "commands successfully created")
else:
    output_json_file_path =  output_json_file_path+'/data/'+ json_file_name
    with open(output_json_file_path, 'w', newline='') as file:
        file.write(json_obj) """
print("json file",json_file_name, "successfully created")
