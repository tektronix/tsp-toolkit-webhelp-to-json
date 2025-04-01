using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using static jsonToLuaParser.Utility;

namespace jsonToLuaParser
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args.Length < 1)
            {
                Console.WriteLine("Json folder path is not provided, please pass json folder path as argument");
                return;
            }

            const string base_lib_dir = "keithley_instrument_libraries";
            if (Directory.Exists(base_lib_dir))
            {
                Utility.RemoveReadOnlyAttributes(base_lib_dir);
                Directory.Delete(base_lib_dir, recursive: true);
            }

            Directory.CreateDirectory(base_lib_dir);

            foreach (string file in Directory.EnumerateFiles(args[0]))
            {
                ParseCommandsJson(base_lib_dir, file);
            }

            CopyStaticFiles("tsp-lua-5.0", Path.Combine(base_lib_dir, "tsp-lua-5.0"));
        }

        static void ParseCommandsJson(string baseLibDir, string jsonFilePath)
        {
            var str = File.ReadAllText(jsonFilePath);
            var fileName = Path.GetFileNameWithoutExtension(jsonFilePath);
            var model = fileName;

            JObject cmds = JObject.Parse(str);
            IList<CommandInfo> cmdList = PopulateCommands(ref cmds, "commands");

            
            (string outstr , string node_or_slot_out_str) = HandleModelSpecificDefinitions(fileName, cmdList);

            WriteOutputFiles(baseLibDir, model, outstr, node_or_slot_out_str);

        }

        static IList<CommandInfo> FilterCommands(ref IList<CommandInfo> cmdList, Func<CommandInfo, bool> predicate)
        {
            var filteredCommands = cmdList.Where(predicate).ToList();
            cmdList = cmdList.Except(filteredCommands).ToList();
            return filteredCommands;
        }

        static Dictionary<string, Dictionary<string, CommandInfo>>[] InitializeInstructionTable(int maxDepth)
        {
            var instrTable = new Dictionary<string, Dictionary<string, CommandInfo>>[maxDepth];
            for (int i = 0; i < maxDepth; i++)
            {
                instrTable[i] = new Dictionary<string, Dictionary<string, CommandInfo>>();
            }
            return instrTable;
        }

        static void PopulateInstructionTable(IList<CommandInfo> cmdList, Dictionary<string, Dictionary<string, CommandInfo>>[] instrTable)
        {
            foreach (var cmd in cmdList)
            {
                var tSplit = cmd.name.Contains(".") ? cmd.name.Trim().Split('.') : cmd.name.Trim().Split(':');
                for (int i = 0; i < tSplit.Length - 1; i++)
                {
                    string attr = tSplit[tSplit.Length - 1];
                    string tableStr = string.Join(".", tSplit, 0, i + 1);

                    if (!instrTable[i].ContainsKey(tableStr))
                    {
                        instrTable[i][tableStr] = new Dictionary<string, CommandInfo>();
                    }
                    if (i == tSplit.Length - 2)
                    {
                        instrTable[i][tableStr][attr] = cmd;
                    }
                }
            }
        }

        static string GenerateNormalCommandDefinitions(string fileName, Dictionary<string, Dictionary<string, CommandInfo>>[] instrTable, IList<CommandInfo> directFunctionCommands, IList<CommandInfo> triggerModelLoadCommands, IList<CommandInfo> triggerModelSetblockCommands, IList<CommandInfo> commandOnlyForTspLinkNodes)
        {
            var outStr = "---@meta\n\n";
            outStr += "---@class io_object\nlocal io_object={}\n---@class scriptVar\nlocal scriptVar={}\n---@class fileVar\nlocal fileVar={}\n---@class eventID\n\n---@class file_object\nlocal file_object ={}\n\n";
            outStr += "---@class bufferVar\nlocal bufferVar={}\n";
            outStr += "---@class tspnetConnectionID\nlocal tspnetConnectionID = {}\n\n ---@class promptID\nlocal promptID = {}\n\n";

            outStr += Utility.GetStaticLuaTableDefination(DefinitionsType.Normal);

            Utility.SetStaticVariablesString(DefinitionsType.Normal);

            outStr += Utility.PrintFields(10, fileName, instrTable, false);
            

            if (triggerModelLoadCommands.Count > 0)
            {
                outStr += "---This is generic function, This function loads a trigger-model template configuration\n---";
                foreach (var cmd in triggerModelLoadCommands)
                {
                    outStr += Utility.get_command_header(cmd, fileName);
                }
                outStr += "\n" + get_trigger_load_cmd_signature();
            }

            if (triggerModelSetblockCommands.Count > 0)
            {
                outStr += $"{get_BlockType_alias()}---This is generic function to define trigger model setblock.\n---Signature of this function depends on the BlockType.\n---For more details, please keep scrolling to find the required function signature for specific BlockType\n---";
                foreach (var cmd in triggerModelSetblockCommands)
                {
                    outStr += Utility.get_command_header(cmd, fileName);
                }
                outStr += get_trigger_model_setBlock_cmd_signature();
            }

            foreach (var cmd in directFunctionCommands)
            {
                outStr += Utility.HelpContent(new KeyValuePair<string, CommandInfo>(cmd.name, cmd), fileName, "");
            }
            return outStr;
        }

        static string GenerateNodeCommandDefinitions(string fileName, Dictionary<string, Dictionary<string, CommandInfo>>[] instrTable, IList<CommandInfo> directFunctionCommands, IList<CommandInfo> triggerModelLoadCommands, IList<CommandInfo> triggerModelSetblockCommands, IList<CommandInfo> commandOnlyForTspLinkNodes)
        {
            var OutStr = "---@meta\n\n";
            OutStr += "---@class io_object\nlocal io_object={}\n---@class scriptVar\nlocal scriptVar={}\n---@class fileVar\nlocal fileVar={}\n---@class eventID\n\n---@class file_object\nlocal file_object ={}\n\n";
            OutStr += "---@class bufferVar\nlocal bufferVar={}\n";
            OutStr += "---@class tspnetConnectionID\nlocal tspnetConnectionID = {}\n\n ---@class promptID\nlocal promptID = {}\n\n";

            OutStr += Utility.GetStaticLuaTableDefination(DefinitionsType.Node);

            Utility.SetStaticVariablesString(DefinitionsType.Node);

            OutStr += Utility.PrintFields(10, fileName, instrTable, true);
            foreach (var cmd in directFunctionCommands)
            {
                OutStr += Utility.HelpContent(new KeyValuePair<string, CommandInfo>(cmd.name, cmd), fileName, "");
            }

            if (triggerModelLoadCommands.Count > 0)
            {
                OutStr += "---This is generic function, This function loads a trigger-model template configuration\n---";
                foreach (var cmd in triggerModelLoadCommands)
                {
                    OutStr += Utility.get_command_header(cmd, fileName);
                }
                OutStr += "\n" + get_trigger_load_cmd_signature(true);
            }

            if (triggerModelSetblockCommands.Count > 0)
            {
                OutStr += $"{get_BlockType_alias()}---This is generic function to define trigger model setblock.\n---Signature of this function depends on the BlockType.\n---For more details, please keep scrolling to find the required function signature for specific BlockType\n---";
                foreach (var cmd in triggerModelSetblockCommands)
                {
                    OutStr += Utility.get_command_header(cmd, fileName);
                }
                OutStr += get_trigger_model_setBlock_cmd_signature(true);
            }

            foreach (var cmd in commandOnlyForTspLinkNodes)
            {
                OutStr += Utility.HelpContent(new KeyValuePair<string, CommandInfo>(cmd.name.Split('.')[1], cmd), fileName, "");
            }

            return OutStr;
        }

        static string GenerateSlotComamndDefinitions(string fileName, Dictionary<string, Dictionary<string, CommandInfo>>[] instrTable, IList<CommandInfo> directFunctionCommands, IList<CommandInfo> triggerModelLoadCommands, IList<CommandInfo> triggerModelSetblockCommands, IList<CommandInfo> commandOnlyForTspLinkNodes)
        {
            var OutStr = "---@meta\n\n";
            OutStr += "---@class io_object\nlocal io_object={}\n---@class scriptVar\nlocal scriptVar={}\n---@class fileVar\nlocal fileVar={}\n---@class eventID\n\n---@class file_object\nlocal file_object ={}\n\n";
            OutStr += "---@class bufferVar\nlocal bufferVar={}\n";
            OutStr += "---@class tspnetConnectionID\nlocal tspnetConnectionID = {}\n\n ---@class promptID\nlocal promptID = {}\n\n";

            OutStr += Utility.GetStaticLuaTableDefination(DefinitionsType.Slot);

            Utility.SetStaticVariablesString(DefinitionsType.Slot);

            OutStr += Utility.PrintFields(10, fileName, instrTable, false);
            foreach (var cmd in directFunctionCommands)
            {
                OutStr += Utility.HelpContent(new KeyValuePair<string, CommandInfo>(cmd.name, cmd), fileName, Utility.NODE_STR.TrimEnd('.'));
            }

            return OutStr;
        }

        static string GenerateNodeSlotComamndDefinitions(string fileName, Dictionary<string, Dictionary<string, CommandInfo>>[] instrTable, IList<CommandInfo> directFunctionCommands, IList<CommandInfo> triggerModelLoadCommands, IList<CommandInfo> triggerModelSetblockCommands, IList<CommandInfo> commandOnlyForTspLinkNodes)
        {
            var OutStr = "---@meta\n\n";
            OutStr += "---@class io_object\nlocal io_object={}\n---@class scriptVar\nlocal scriptVar={}\n---@class fileVar\nlocal fileVar={}\n---@class eventID\n\n---@class file_object\nlocal file_object ={}\n\n";
            OutStr += "---@class bufferVar\nlocal bufferVar={}\n";
            OutStr += "---@class tspnetConnectionID\nlocal tspnetConnectionID = {}\n\n ---@class promptID\nlocal promptID = {}\n\n";

            OutStr += Utility.GetStaticLuaTableDefination(DefinitionsType.NodeSlot);

            Utility.SetStaticVariablesString(DefinitionsType.NodeSlot);

            OutStr += Utility.PrintFields(10, fileName, instrTable, true);
            foreach (var cmd in directFunctionCommands)
            {
                OutStr += Utility.HelpContent(new KeyValuePair<string, CommandInfo>(cmd.name, cmd), fileName, Utility.NODE_STR.TrimEnd('.'));
            }

            return OutStr;
        }

        static (string out_str, string node_str) HandleModelSpecificDefinitions(string fileName, IList<CommandInfo> cmdList)
        {
            var factoryScriptCommands = FilterCommands(ref cmdList, cmd => cmd.description.Contains("factory script"));
            var directCommands = FilterCommands(ref cmdList, cmd => !cmd.name.Contains('.') && !cmd.name.Contains(':'));
            var triggerModelLoadCommands = FilterCommands(ref cmdList, cmd => cmd.name.Contains("trigger.model.load()"));
            var triggerModelSetblockCommands = FilterCommands(ref cmdList, cmd => cmd.name.Contains("trigger.model.setblock()"));
            var commandOnlyForTspLinkNodes = FilterCommands(ref cmdList, cmd => cmd.name.Contains("node[N]."));

            var instrTable = InitializeInstructionTable(10);
            PopulateInstructionTable(cmdList, instrTable);
            var outStr = "";
            var tsplinkStr = "";
            if (fileName.Contains("26"))
            {
                outStr = GenerateNormalCommandDefinitions(fileName, instrTable, directCommands, triggerModelLoadCommands, triggerModelSetblockCommands, commandOnlyForTspLinkNodes);
                tsplinkStr = GenerateNodeCommandDefinitions(fileName, instrTable, directCommands, triggerModelLoadCommands, triggerModelSetblockCommands, commandOnlyForTspLinkNodes);
                

            }
            else if (fileName.Contains("37"))
            {
                // Add specific handling for 37 models if needed
            }
            else if (fileName.Contains(Utility.MODULE_MP5103))
            {
                // Add specific handling for MP5103 models if needed
                // Add specific handling for 2600 models if needed
                outStr = GenerateNormalCommandDefinitions(fileName, instrTable, directCommands, triggerModelLoadCommands, triggerModelSetblockCommands, commandOnlyForTspLinkNodes);
                tsplinkStr = GenerateNodeCommandDefinitions(fileName, instrTable, directCommands, triggerModelLoadCommands, triggerModelSetblockCommands, commandOnlyForTspLinkNodes);


            }
            else if (fileName.Contains(Utility.MODULE_MSMU60_2))
            {
                // Add specific handling for MSMU60_2 models if needed
                outStr = GenerateSlotComamndDefinitions(fileName, instrTable, directCommands, triggerModelLoadCommands, triggerModelSetblockCommands, commandOnlyForTspLinkNodes);
                tsplinkStr = GenerateNodeSlotComamndDefinitions(fileName, instrTable, directCommands, triggerModelLoadCommands, triggerModelSetblockCommands, commandOnlyForTspLinkNodes);

            }
            else // for tti models
            {
                outStr = GenerateNormalCommandDefinitions(fileName, instrTable, directCommands, triggerModelLoadCommands, triggerModelSetblockCommands, commandOnlyForTspLinkNodes);
                outStr += get_def_buffer_Definitions();
                tsplinkStr = GenerateNodeCommandDefinitions(fileName, instrTable, directCommands, triggerModelLoadCommands, triggerModelSetblockCommands, commandOnlyForTspLinkNodes);
                tsplinkStr += get_def_buffer_Definitions(true);
            }

            return (outStr, tsplinkStr);
        }

        static void WriteOutputFiles(string baseLibDir, string model, string outStr, string tsplinkStr)
        {
            Directory.CreateDirectory(Path.Combine(baseLibDir, model));
            Directory.CreateDirectory(Path.Combine(baseLibDir, model, "tspLinkSupportedCommands"));
            Directory.CreateDirectory(Path.Combine(baseLibDir, model, "AllTspCommands"));
            Directory.CreateDirectory(Path.Combine(baseLibDir, model, "Helper"));

            var allTspCommandsFilePath = $"{baseLibDir}/{model}/AllTspCommands/definitions.lua";
            var tspLinkSupportedCommandsFilePath = $"{baseLibDir}/{model}/tspLinkSupportedCommands/definitions.txt";

            var staticFolderPath = Path.Combine(baseLibDir, model, "Helper");
            Utility.CopyStaticFiles(model, staticFolderPath);

            Utility.write_to_file(allTspCommandsFilePath, outStr);
            Utility.write_to_file(tspLinkSupportedCommandsFilePath, tsplinkStr);

            Utility.SetFileReadOnly(allTspCommandsFilePath);
            Utility.SetFileReadOnly(tspLinkSupportedCommandsFilePath);
        }
    }
}