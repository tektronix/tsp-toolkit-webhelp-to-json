﻿using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
//using static jsonToLuaParser.Utility;
using static jsonToLuaParser.Utility;
namespace jsonToLuaParser
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args.Length < 1)
            {
                Console.WriteLine("Josn folder path is not provided, please pass josn folder path as argumnet");
            }

            const string base_lib_dir = "keithley_instrument_libraries";
            // Check if the directory exists
            if (Directory.Exists(base_lib_dir))
            {
                // Recursively remove read-only attribute from all files in the directory and its subdirectories
                Utility.RemoveReadOnlyAttributes(base_lib_dir);

                // Delete the directory
                Directory.Delete(base_lib_dir, recursive: true);
            }

            Directory.CreateDirectory(base_lib_dir);

            foreach (string file in Directory.EnumerateFiles(args[0]))
            {
                parse_commands_josn(base_lib_dir, file);
            }

            // Copy tsp-lua-5.0 definations
            Directory.CreateDirectory(Path.Combine(base_lib_dir, "tsp-lua-5.0"));
            var lua_definations_file_path = Path.Combine(base_lib_dir, "tsp-lua-5.0");
            CopyStaticFiles("tsp-lua-5.0", lua_definations_file_path);
        }

       static void parse_commands_josn(string base_lib_dir, string json_file_path)
        {
            Dictionary<string, string> arrayfound = new Dictionary<string, string>();
            var str = File.ReadAllText(json_file_path);

            var file_name = Path.GetFileNameWithoutExtension(json_file_path);

            var model = Path.GetFileNameWithoutExtension(json_file_path);
            //var file_name = "NewDMM7510commands";
            JObject cmds = JObject.Parse(str);

            IList<CommandInfo> cmdList = PopulateCommands(ref cmds, "commands");
            Console.WriteLine(cmdList.First());
            var outStr = "---@meta\n\n";
            int MAX_DEPT = 10;
            Dictionary<string, Dictionary<string, CommandInfo>>[] instrTable = new Dictionary<string, Dictionary<string, CommandInfo>>[MAX_DEPT];
            for (int i = 0; i < MAX_DEPT; i++)
            {
                instrTable[i] = new Dictionary<string, Dictionary<string, CommandInfo>>();
            }

            var factoryScriptCommands = cmdList.Where(cmd => cmd.description.Contains("factory script")).ToList(); // get factoryScriptCommands and remove it, its there for 26xx models

            cmdList = cmdList.Except(factoryScriptCommands).ToList(); // remove all factoryScriptCommands commands

            var directFunctioncommands = cmdList.Where(cmd => !cmd.name.Contains('.')).ToList();

            var triggerModelLoadCommands = cmdList.Where(cmd => cmd.name.Contains("trigger.model.load()")).ToList(); // get trigger.model.load() commands

            var triggerBlockConstants = cmdList.Where(cmd => cmd.name.Contains("trigger.BLOCK_")).ToList();
            cmdList = cmdList.Except(triggerBlockConstants).ToList();


            cmdList = cmdList.Except(directFunctioncommands).ToList(); // remove all directFunctioncommands commands and handle it speratley

            cmdList = cmdList.Except(triggerModelLoadCommands).ToList(); // remove all trigger.model.load() commands and handle it speratley

           
            foreach (var cmd in cmdList)
            {
                string s = cmd.name;
                var tSplit = s.Contains(".") ? s.Trim().Split('.') : s.Trim().Split(':');
               
                for (int i = 0; i < tSplit.Length - 1; i++)
                {//ignore functions
                    string attr = null;
                    //if (cmd.command_type != CommandType.Function)
                    //{//attributes
                    //TODO get attribute type and/or defaults
                    attr = tSplit[tSplit.Length - 1];
                    //}
                    string tableStr = string.Join(".", tSplit, 0, i + 1);

                    if (!instrTable[i].ContainsKey(tableStr))
                    {
                        instrTable[i][tableStr] = new Dictionary<string, CommandInfo>();
                    }
                    if (attr != null && i == tSplit.Length - 2)
                        instrTable[i][tableStr][attr] = cmd;
                }
            }

            outStr += "---@class io_object\nlocal io_object={}\n---@class scriptVar\nlocal scriptVar={}\n---@class eventID\n\n---@class file_object\nlocal file_object ={}\n\n"; //PRIV
            outStr += "---@class bufferVar\nlocal bufferVar={}\n";
            outStr += "---@class digio\n local digio = {}\n\n---@class tsplink\n local tsplink = {}\n\n---@class lan\n  local lan = {}\n\n---@class tspnetConnectionID\nlocal tspnetConnectionID = {}\n\n ---@class promptID\nlocal promptID = {}\n\n";

            var tsplinkStr = "";
            tsplinkStr = outStr;
            tsplinkStr += Utility.PrintFields(MAX_DEPT, file_name, instrTable, true);
            outStr += Utility.PrintFields(MAX_DEPT, file_name, instrTable, false);
            foreach (var cmd in directFunctioncommands)
            {
                var cmd_info = new KeyValuePair<string, CommandInfo>(cmd.name, cmd);
                outStr += Utility.HelpContent(cmd_info, file_name, "", true);
            }

            if (triggerModelLoadCommands.Count > 0)
            {
                var defStr = "---This is generic function, This function loads a trigger-model template configuration\n---";
                outStr += defStr;
                tsplinkStr += defStr;

                foreach (var cmd in triggerModelLoadCommands)
                {
                    var header = Utility.get_command_header(cmd, file_name);
                    outStr += header;
                    tsplinkStr += header;
                }

                var sig = "\n" + @"---@param loadFunConst loadFunConstParam
function trigger.model.load(loadFunConst,...) end";
                outStr += sig;
                tsplinkStr += sig;


            }

          
            if (file_name.Contains("26"))
            {

            }

            else if (file_name.Contains("37"))
            {
            }
            else // for tti models
            {


            }

            Directory.CreateDirectory(Path.Combine(base_lib_dir, model));
            Directory.CreateDirectory(Path.Combine(base_lib_dir, model, "tspLinkSupportedCommands"));
            Directory.CreateDirectory(Path.Combine(base_lib_dir, model, "AllTspCommands"));
            Directory.CreateDirectory(Path.Combine(base_lib_dir, model, "Helper"));


            var AllTspCommandsFilePath = $"{base_lib_dir}/{model}/AllTspCommands/definitions.lua";
            var tspLinkSupportedCommandsFilePath = $"{base_lib_dir}/{model}/tspLinkSupportedCommands/definitions.txt";

            var static_folder_Path = Path.Combine(base_lib_dir, model, "Helper");

            Utility.CopyStaticFiles(model, static_folder_Path);

            Utility.write_to_file(AllTspCommandsFilePath, outStr);
            Utility.write_to_file(tspLinkSupportedCommandsFilePath, tsplinkStr);

            Utility.SetFileReadOnly(AllTspCommandsFilePath);
            Utility.SetFileReadOnly(tspLinkSupportedCommandsFilePath);
            
        }
    }
}
