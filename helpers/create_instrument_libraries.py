import os
import shutil
import json
sourcefolder = r"../data"
files = os.listdir(sourcefolder)

print(files)

lib_path = r"C:\TeaspoonRepo\jsonToLuaParser\keithley_instrument_libraries"
for file in files:
    foldername = file.replace("commands.lua","")
    dest_folder = os.path.join(lib_path, foldername)
    os.makedirs(dest_folder)

    with open("config.json", "r") as f:
        data = json.load(f)

    data["name"] = foldername
    data["words"] = ["---%s" %foldername]
    
    with open(dest_folder + "\\config.json", "w") as f:
        json_obj = json.dumps(data, indent=4)
        f.write(json_obj)
    dest_folder = os.path.join(lib_path, foldername,"library")
    os.makedirs(dest_folder)
    file_path = os.path.join(sourcefolder, file)
    shutil.move(file_path, dest_folder)
    
