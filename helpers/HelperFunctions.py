from logging import exception
import os
import re
from bs4 import BeautifulSoup
from ordered_set import OrderedSet
from Configuration import Configuration
from helpers import cmd_param
import json

supportedInstruments = "2601, 2602, 2611, 2612, 2635, 2636, 2601A, 2602A, 2611A, 2612A, 2635A, 2636A,2651A, 2657A, 2601B, 2601B-PULSE, 2602B, 2606B, 2611B, 2612B, 2635B, 2636B, 2604B, 2614B, 2634B,2601B-L, 2602B-L, 2611B-L, 2612B-L, 2635B-L, 2636B-L, 2604B-L, 2614B-L, 2634B-L"


def Parser(path):
    file_obj = open(path, "r", encoding="utf-8", errors="ignore")
    read_obj = file_obj.read()
    soup_obj = BeautifulSoup(read_obj, 'html.parser')

    return soup_obj


def fetch_details(command_name,soup):
    try:
        description = soup.find_all("p", "bodyzero").pop(0).get_text()
    except:
        return    
    details = get_details(soup)
    usage = usage_func(soup, command_name)
    param_info = get_parameter_details(soup, command_name)
    examples = get_examples(soup)
    related_commands = get_related_commands(soup)
    command_type, default_value, tsp_link = get_signature_details(
        soup, command_name)
    return description, usage, details, examples, related_commands, param_info, command_type, default_value, tsp_link

def get_record(name, webhelpfile, cmd_type, default_value, descr, details, param_info: list, usage, example, related_commands, tsp_link):
    record = {}
    overloads = list(get_overloads(usage, name, cmd_type))
    return_str = ""
    signature = ""

    if "localnode.settime()" in name:
        signature = "localnode.settime(year, month, day, hour, minute, second)"
    elif overloads:
        return_populated = False
        signature = overloads[-1]
        if "=" in overloads[-1]:
            temp = overloads[-1].split("=")
            for x in temp:
                if ("(" in x and "Function" in cmd_type):
                    signature = x.strip()
                elif ("(" not in x and return_populated == False and x.strip() != name):
                    return_str = x.strip()
                    return_populated = True
            """ signature = overloads[-1].split("=")[1]
            return_str = overloads[-1].split("=")[0] """

        # removing signature from this so that it will not repeat in overloads
        overloads.remove(overloads[-1])
    else:
        return_populated = False        
        if len(usage) != 0:
            # signature = usage[0]
            if "=" in usage[0]:
                temp = usage[0].split("=")
                for x in temp:
                    if ("(" in x and "Function" in cmd_type):
                        signature = x.strip()
                        
                    if ("bufferVar." in x):
                        signature = x.strip()

                    elif ("(" not in x and return_populated == False and x.strip() != name):
                        return_str = x.strip()
                        return_populated = True
                """ signature = usage[0].split("=")[1].replace(" ", "")
                return_str = usage[0].split("=")[0].replace(" ", "") """
            else:
                signature = usage[0]
    
    #Only 2600
    temp_c = ""
    flag = 0
    if "This command is not available on the 2604B, 2614B, or 2634B." in descr:
        flag = 1
        temp_a = supportedInstruments.replace(" 2604B,", "")
        temp_b = temp_a.replace(" 2614B,", "")
        temp_c = temp_b.replace(" 2634B,", "")
        """ supportedInstrumentsList.remove('2604B')
        supportedInstrumentsList.remove('2614B')
        supportedInstrumentsList.remove('2634B') """


    record["name"] = name
    record["webhelpfile"] = webhelpfile
    record["signature"] = signature
    record["command_return"] = return_str
    record["type"] = cmd_type
    record["default_value"] = default_value
    record["tsp_link"] = tsp_link
    record["description"] = descr
    record["details"] = details
    record["param_info"] = param_info
    record["usage"] = usage
    record["overloads"] = list(overloads)
    record["examples"] = example
    if(str(Configuration.MODEL_NUMBER).find("26")!= -1):
        if flag == 1:
            record["supported_models"] = temp_c
        else:
            record["supported_models"] = supportedInstruments
    record["related_commands"] = related_commands

    return record


def get_details(S):
    details = ""
    tags = S.find_all("p", "iclbody")
    for tag in tags:
        details = details + tag.get_text()
    return details


def usage_func(S, command_name):
    usage = []
    tags = filter_paragraph(S, command_name)

    for tag in tags:

        sig = tag.get_text().replace("\"", "").replace("/", "")

        if "setup.cards" in command_name:
            sig = sig.replace(".set", "")

        if "smuX.savebuffer()" in command_name:
            sig = sig.replace("smuX.nvbufferY","buffer")

        # modifing sig which have param look like alias name
        # fs.is_file() , fs.is_dir() signature is having problem
        if("setblock()" not in command_name and "fs." not in command_name
           and "measure.Y()" not in command_name):
            aliasParam = re.findall("[a-z]+\.[A-Z_0-9]+", sig)
            for s in aliasParam:
                sig = sig.replace(s, s.split('.')[1])

        # when signature has ...[any_text] indicating many such params
        #if "..." in sig:           
            #sig = re.sub(r",\s*\.\.\.\s*[^=)]+","", sig)


        usage.append(sig)
    return usage


def filter_paragraph(S, command_name):
    # get all the paragraphs between 'usage' and 'details'
    all_paragraphs = []
    
    if "display.settext()" in command_name:
        all_paragraphs.append(get_new_paragraph(
            S, "display.settext(displayArea, text)"))
        return all_paragraphs

    try:
        # find the 'usage' and 'details' tags with the 'iclsubheading' class
        usage_tag = S.find('p', {'class': 'iclsubheading'}, text='Usage')
        details_tag = S.find('p', {'class': 'iclsubheading'}, text='Details')

        # find the data within 'usage' and 'deatails' tag.
        current_tag = usage_tag.find_next_sibling()
        while current_tag != details_tag:
            if "smu.contact.check" in command_name and current_tag.name == 'p' and 'iclbody' in current_tag['class']:
                all_paragraphs.append(current_tag)
            elif current_tag.name == 'p' and 'iclcode' in current_tag['class']:
                all_paragraphs.append(current_tag)
            current_tag = current_tag.find_next_sibling()

    except Exception as E:
        print(E)

    return all_paragraphs


def get_new_paragraph(S, text):
    paragraph = S.new_tag('p')
    paragraph.string = text
    return paragraph


def get_parameter_details(S, command_name):
    param_info = []

    if "lan.restoredefaults()" in command_name:
        return param_info
    
    # if "bufferVar" in command_name:
    #     return param_info
    
    try:
        tables = S.find_all("table")
        #param_table = tables[2]
        rows = tables[2].find_all("tr")

        if "trigger.model.load()" in command_name:  # trigger.model.load() - DurationLoop
            new_row = get_new_row(S, command_name.split('-')[1].rstrip().lstrip(), "load function constant param")
            #param_table.insert(0, new_row)
            rows.insert(0, new_row)
        
        elif "buffer.unit()" in command_name:
            new_row = get_new_row(S, "UNIT_CUSTOMN", "Custom unit user can create, The number of the custom unit, 1, 2, or 3")
            rows.insert(0, new_row)
            #param_table.insert(0, new_row)

        elif "display.settext()" in command_name:
            rows.pop(1)
            rows.pop(0)
            #param_table.extract()
            new_row = get_new_row(S, "displayArea", "display.TEXT1 display.TEXT2")
            rows.insert(0, new_row)
            #param_table.insert(0, new_row)
            new_row = get_new_row(S, "text", "String that contains the message for the top line of the USER swipe screen (up to 20 characters)")
            #param_table.insert(1, new_row)
            rows.insert(1, new_row)
        elif "smuX.savebuffer()" in command_name:            
            new_row = get_new_row(S, "buffer", "Buffer variable")
            rows.insert(0, new_row)

        """ elif "trigger.model.setblock()" in command_name:  # trigger.model.setblock() - trigger.BLOCK_BRANCH_ALWAYS
            new_row = get_new_row(S, command_name.split('-')[1].split('.')[1], command_name.split('-')[1])
            #param_table.insert(0, new_row)
            rows.insert(0, new_row)

            if "trigger.model.setblock() - trigger.BLOCK_DELAY_DYNAMIC" in command_name:
                new_row = get_new_row(S, "USER_DELAY_Mn","trigger.USER_DELAY_Mn")
                rows.insert(0, new_row)
                #param_table.insert(0, new_row)

            elif "trigger.model.setblock() - trigger.BLOCK_NOTIFY" in command_name:
                new_row = get_new_row(S, "EVENT_NOTIFYN","trigger.EVENT_NOTIFYN")
                rows.insert(0, new_row)
                #param_table.insert(0, new_row) """

        # this commnd is having three table data for table row "units", combining two <td> text to one
        """ elif "buffer.write.format()" in command_name:
            # Find the first <td> tag
            first_td = param_table.find_all("tr")[1].find_all("td")[1]
            # Find the second <td> tag
            second_td = param_table.find_all("tr")[1].find_all(
                "td")[2]  # assuming it's the second <td> in the table

            # Move the contents of the second <td> tag to the first <td> tag
            for child in second_td.children:
                first_td.append(child.extract())

            # Remove the second <td> tag from the HTML table
            second_td.extract() """

        for row in rows:
            mini_dict = {}

            data = row.find_all("td")
            param = data[0].get_text().replace("\n", "").strip() # name of the parameter
            
            param_desc = "\n".join([item.get_text(separator='\n') for item in data[1:]]) #24xx, dmm, daq
            
            if(str(Configuration.MODEL_NUMBER).find("26")!= -1):
                param_desc = "\n".join([item.get_text().replace("\n", "") for item in data[1:]])


            if param == '':
                continue
            
            mini_dict["name"] = param                        

            x = list(OrderedSet(re.findall("[a-z]+[X]?\.[A-Z_0-9]+", param_desc)))
            y = re.findall("or\\s(\\d)", param_desc)
            param_desc = param_desc = "\n".join([item.get_text().replace("\n", "") for item in data[1:]])

            #if "buffer.write.format()" in command_name:
            if ":" in param_desc:
                param_desc = param_desc.split(":")[0]
            mini_dict["description"] = param_desc

            enum_data = []
            
            if len(x) != 0:
                for index in range(len(x)):
                    data = {}
                    data["name"] = remove_array_string_form_enum(x[index])
                    data["value"] = ""
                    data["description"] = ""
                    enum_data.append(data)


            elif command_name in Configuration.MANUALLY_EXTRACTED_COMMANDS:
                if param in Configuration.MANUALLY_EXTRACTED_COMMANDS[command_name]["param_info"]:
                    for enum in Configuration.MANUALLY_EXTRACTED_COMMANDS[command_name]["param_info"][param]["enum"]:
                        data = {}
                        data["name"] = enum['name']
                        data["value"] = enum['value']
                        data["description"] = enum['description']
                        enum_data.append(data)


            mini_dict["enum"] = enum_data
            mini_dict["type"] = get_param_type(
                command_name, param)
             
            mini_dict["range"] = get_range(
                command_name, param_desc)
            param_info.append(mini_dict)
            

    except Exception as e:
        print(command_name, e)
    return param_info


def remove_array_string_form_enum(enum_data):
    enum_data = re.sub("[\w]+smuX","smuX",enum_data)
    enum_data = re.sub("[\w]+smu","smu",enum_data)
    enum_data = re.sub("[\w]+lan","lan",enum_data)
    enum_data = re.sub("[\w]+trigger","trigger",enum_data)
    enum_data = re.sub("[\w]+scan","scan",enum_data)
    enum_data = re.sub("[\w]+channel","channel",enum_data)
    enum_data = re.sub("[\w]+dmm","dmm",enum_data)
    return enum_data


def get_new_row(S, param, disc):
    new_row = S.new_tag('tr')
    td1 = S.new_tag("td")
    td1.string = param
    td2 = S.new_tag("td")
    td2.string = disc
    new_row.insert(0, td1)
    new_row.insert(1, td2)

    return new_row


def get_param_type(cmd, param_name) -> str:
    data_type = "any"

    if str(cmd).startswith("status.") and "*" in cmd:
        return "number"
    
    
    value = Configuration.PARAMS_TYPES_DETAILS.get(cmd, None)
    if value:
        param_details = {v.split(':')[0]: v.split(
            ':')[1].rstrip().lstrip() for v in value.split(',')}
        data_type = param_details.get(param_name, "any")

    return data_type


def get_range(cmd, description):
    pattern = r'(\(.*?\))'  # pattern to match text including parentheses
    matches = re.findall(pattern, description)
    if matches:
        return matches[0]
    return ""

def get_examples(S):
    example_info = []
    i = 0
    example_count = 0
    try:
        headings = S.find_all("p", "iclsubheading")
        for heading in headings:
            if "Example" in heading.get_text():
                example_count += 1

        tables = S.find_all("table")       
        example_tables = []
        for x in range(len(tables)-example_count,len(tables)):
            example_tables.append(tables[x])   

        for example_table in example_tables:
            mini_dict = {}
            data = example_table.find_all("td")
            param = data[0].get_text().replace("\n",";")
            desc = data[1].get_text().replace("\n","\n--- --")
            desc = desc[:-6]
            mini_dict["example"] = param
            mini_dict["description"] = desc            
            example_info.append(mini_dict)
    except Exception as e:
        print(e)
    return example_info


def get_related_commands(S):
    related_commands = []
    tags = S.find_all("p", "listcommand")
    for tag in tags:
        related_commands.append(tag.get_text())
    return related_commands


def get_signature_details(S, command_name):
    command_type = ""
    default_value = ""
    tsp_link = ""
    try:
        tables = S.find_all("table")
        table = tables[1]             
        command_type = table.find_all("tr")[1].find_all("td")[0].text.replace("\n", "")
        if "ptp.ds.info" in command_name:
            command_type = "Attribute (R)"  
        default_value = table.find_all("tr")[1].find_all("td")[4].text  
        tsp_link = table.find_all("tr")[1].find_all("td")[1].text
    except Exception as e:
        print(e)

    return command_type, default_value, tsp_link


def get_overloads(usage, command_name, command_type):
    oveloads = set()    
    if "Function" in command_type and len(usage) > 1:
        for sig in usage:
            # print(command_name)
            if command_name.split("(")[0]+"(" in sig:
                oveloads.add(sig)
        oveloads = sorted(oveloads, key=len)
    return oveloads

def get_Y_param_options(command,param_details, cmd_type, usage):
    if("smuX.nvbufferY") in command:
        y_options=["1","2"]
        return y_options
    y_options = []
    index = 0
    for i, param in enumerate(param_details):
        if param.get("name") == "Y":
            index = i
            break

    try:
        y_param_details = param_details[index].get("description")

        if y_param_details:
            param_str = y_param_details.split('(')[1].split(')')[0]
            params = [p.strip() for p in param_str.split(',')]
            # create a list of i,v,p,r names
            y_options = [p.split('=')[0].strip() for p in params]
        else:
            print("command without 'Y' parameter ", param_details)

        if "Function" in cmd_type:
            if any("iv" in string for string in usage):
                y_options.append("iv")
    except:
        print("Index out of range")

    return y_options

def parse_manual_json(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        data = json.load(file)
    
    commands = data.get("commands", [])
    parsed_commands = {}

    for command in commands:
        command_name = command.get("name", "")
        param_info = command.get("param_info", [])
        
        parsed_param_info = {}
        for param in param_info:
            param_name = param.get("name", "")
            enums = param.get("enum", [])
            
            parsed_enums = []
            for enum in enums:
                enum_name = enum.get("name", "")
                enum_value = enum.get("value", "")
                enum_description = enum.get("descriptions", "")
                parsed_enums.append({
                    "name": enum_name,
                    "value": enum_value,
                    "description": enum_description
                })
            
            parsed_param_info[param_name] = {
            "name": param_name,
            "enum": parsed_enums
            }
            
        
        parsed_commands[command_name] = {
            "name": command_name,
            "param_info": parsed_param_info
        }
    
    return parsed_commands
