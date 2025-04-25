using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace jsonToLuaParser
{
    class Utility
    {

        private static readonly List<string> MODEL_2600B_MODELS = new List<string>
        {
            "2601B",
            "2611B",
            "2635B",
            "2604B",
            "2614B",
            "2602B",
            "2612B",
            "2634B",
            "2636B"
        };

        public const string MODULE_MSMU60_2 = "MSMU60-2";
        public const string MODULE_MPSU50_2ST = "MPSU50-2ST";
        public const string MODULE_MP5103 = "MP5103";

        public static string NODE_STR = "";
        public static string NODE_ALIAS_STR = "";

        public class Example_Info
        {
            public string example { get; set; }
            public string description { get; set; }
        }
        public class ParamInfo
        {
            public string Name { get; set; }
            public string Description { get; set; }
            public EnumInfo[] enums { get; set; }
            public string Type { get; set; }
        }
        public class EnumInfo
        {
            public string Name { get; set; }
            public string Description { get; set; }
            public string value { get; set; }
        }
        public class CommandEnum
        {
            public string enum_number { get; set; }
            public string enum_member { get; set; }
        }
        public enum CommandType
        {
            Function,
            Attribute_RO,
            Attribute_WO,
            Attribute_RW,
            Constant
        }

        public enum DefinitionsType
        {
            Node,
            Slot,
            NodeSlot,
            Normal
        }

        public class CommandInfo
        {
            public string name { get; set; }
            public string webhelpfile { get; set; }
            public string signature { get; set; }
            public string command_return { get; set; }
            public string description { get; set; }
            public CommandType command_type { get; set; }
            public string[] usage { get; set; }
            public string default_value { get; set; }
            public string details { get; set; }
            public Example_Info[] example_info { get; set; }
            public string related_commands { get; set; }
            public ParamInfo[] param_info { get; set; }
            public string[] overloads { get; set; }
            public string supportedModels { get; set; }
            public string tsplink_supported { get; set; }
        }

        public static IList<string> get_return_type_and_default_value(CommandInfo cmd)
        {
            var lst = new List<string>();

            var prm = cmd.param_info.Where(param => param.Name.ToUpper() == cmd.command_return.ToUpper()).ToList();
            if (prm.Count > 0)
            {
                var type = prm[0].Type;
                lst.Add(type);

                var defaultValue = type.Contains("[]") ? "{}" : type == "table" ? "{}" : type == "string" ? "''" : type == "integer" ? "0" : type == "boolean" ? "true" : type == "number" ? "0" : type.Contains('|') ? type.Split('|')[0].Trim() : "{}";

                if (prm[0].enums.Length>0)
                {
                    defaultValue = prm[0].enums[0].Name;

                }
                lst.Add(defaultValue);
            }
            else
                System.Console.WriteLine(cmd.name);


            return lst;

        }
        public static IList<CommandInfo> PopulateCommands(ref JObject obj, string feild)
        {
            IList<CommandInfo> cmdList = obj[feild].ToArray().Select(p => new CommandInfo
            {
                name = (string)p["name"],
                webhelpfile = (string)p["webhelpfile"],
                signature = (string)p["signature"],
                tsplink_supported = (string)p["tsp_link"],
                description = (string)p["description"],
                command_type = ((string)p["type"] == "Function" ? CommandType.Function : ((string)p["type"] == "Attribute (RW)" ? CommandType.Attribute_RW : ((string)p["type"] == "Attribute (R)") ? CommandType.Attribute_RO : ((string)p["type"] == "Attribute (Ro)") ? CommandType.Attribute_RO : (string)p["type"] == "Constant" ? CommandType.Constant : CommandType.Attribute_WO)),
                default_value = (string)p["default_value"],
                usage = p["usage"].ToObject<string[]>(),
                overloads = p["overloads"].ToObject<string[]>(),
                details = (string)p["details"],
                command_return = (string)p["command_return"],
                example_info = p["examples"].ToArray().Select(pi => new Example_Info
                {
                    example = pi["example"].ToString(),
                    description = pi["description"].ToString(),

                }).ToArray(),
                param_info = p["param_info"].ToArray().Select(pi => new ParamInfo
                {
                    Name = pi["name"].ToString(),
                    Description = pi["description"].ToString(),
                    enums = pi["enum"].ToArray().Select(v => new EnumInfo
                    {
                        Name = v["name"].ToString(),
                        value = v["value"].ToString(),
                        Description = v["description"].ToString(),


                    }).ToArray(),
                    Type = pi["type"].ToString(),
                }).ToArray(),
                related_commands = "TODO",
                supportedModels = (string)p["supported_models"]

            }).ToList();

            return cmdList;
        }

        public static string[] GetValidArrays(string file_name)
        {
            if (file_name.Contains(MODULE_MSMU60_2) || file_name.Contains(MODULE_MPSU50_2ST))
                return new string[] {};
            else
                return new string[] { "[N]", "[Y]", "[slot]", "[1]", "[X]" };
        }

        public static string PrintFields(int depth, string file_name, Dictionary<string, Dictionary<string, CommandInfo>>[] instrTable, bool forTspLink)
        {
            var outStr = "";

            string table_name = "";
            string type_name = "";
            string[] arrList = { };
            for (int i = 0; i < depth; i++)
            {
                foreach (var keyValuePair in instrTable[i])
                {
                    string class_data = "";
                    // Handling Arrays in commands
                    string[] arrayMarkers = GetValidArrays(file_name);
                    var is_array = false;
                    
                    foreach (var marker in arrayMarkers)
                    {
                        if (keyValuePair.Key.Contains(marker))
                        {
                            table_name = keyValuePair.Key.Replace(marker, "");
                            type_name = keyValuePair.Key.Replace(marker, "|").Split('|')[0].Replace(".", "") + "Arr";
                            if (!arrList.Contains(type_name))
                            {
                                arrList = arrList.Append(type_name).ToArray();
                                class_data += $"---@class {type_name.Replace('[', '_').Replace(']', '_')}\n";
                                class_data += $"local {type_name} = {{}}\n\n";
                                class_data += $"---@type {type_name}[]\n";
                                class_data += $"{NODE_STR}{table_name} = {{}}\n";
                                table_name = $"{type_name}";
                            }
                            else
                            {
                                string rem = keyValuePair.Key.Replace(marker, "|").Split('|')[1];
                                class_data += $"{type_name}{rem} = {{}}\n";
                                table_name = $"{type_name}{rem}";
                            }
                            is_array = true;
                            break;
                        }
                    }

                    if (!is_array)
                    {
                        table_name = NODE_STR + keyValuePair.Key;
                        if (keyValuePair.Key.Contains("bufferVar")) // handle bufferVar type
                            table_name = keyValuePair.Key;
                            
                        class_data += "---@class " + keyValuePair.Key.Replace('[','_').Replace(']','_') + "\n";
                        class_data += $"{table_name} = {{}}\n";
                    }

                    

                    outStr += class_data;
                    outStr += "\n\n";
                    foreach (var cmd in keyValuePair.Value)
                    {
                        if (forTspLink)
                        {
                            if (cmd.Value.tsplink_supported.Contains("Yes"))
                            {
                                outStr += HelpContent(cmd, file_name, table_name);
                            }
                                
                        }

                        else
                        {
                            outStr += HelpContent(cmd, file_name, table_name);

                        }
                                
                    }
                }
            }
            return outStr;
        }

        public static string HelpContent(KeyValuePair<string, CommandInfo> command, string file_name, string table)
        {
            var command_help = new StringBuilder();
            var cmd = command.Value;
            try
            {
                if (cmd.command_type == CommandType.Function)
                {
                    ProcessFunctionCommand(command, file_name, table, command_help);
                }
                else // attributes
                {
                    ProcessAttributeCommand(command, file_name, table, command_help);
                }
            }
            catch(Exception ex)
            {
                command_help = new StringBuilder();
                Console.WriteLine($"An error occuerd for {command.Key}");
            }

            

            return command_help.ToString();
        }

        private static void ProcessFunctionCommand(KeyValuePair<string, CommandInfo> command, string file_name, string table, StringBuilder command_help)
        {
            var cmd = command.Value;
            foreach (var param in cmd.param_info)
            {
                if (param.enums.Length > 0)
                {
                    command_help.Append(create_enum_alias_type(param));
                }
            }

            command_help.Append(get_command_header(cmd, file_name)).Append("\n");

            var command_returns = cmd.command_return.ToUpper().Split(',')
                                              .Select(st => st.Trim())
                                              .ToList();

            var parameters = ExtractParametersFromSignature(cmd.signature);
            foreach (var param in cmd.param_info)
            {
                if (parameters.Contains(param.Name.ToUpper()))
                {
                    command_help.Append(FormatParamAnnotation(param));
                }
                else if (command_returns.Contains(param.Name.ToUpper()))
                {
                    command_help.Append(FormatReturnAnnotation(param));
                }
            }

            cmd.signature = cmd.signature.Replace("\"", "");

            if (cmd.overloads.Length > 0)
            {
                foreach (var sig in cmd.overloads)
                {
                    command_help.Append(FormatOverloadDoc(sig, cmd.param_info, cmd.command_return));
                }
            }

            var function_name = command.Key.Replace("(", "").Replace(")", "");
            command_help.Append(FormatFunctionDefinition(function_name, cmd.signature, table));
        }

        private static void ProcessAttributeCommand(KeyValuePair<string, CommandInfo> command, string file_name, string table, StringBuilder command_help)
        {
            var attr = command.Key.Replace("[M]", "").Replace("[N]", "");
            var cmd = command.Value;
            var prm = cmd.param_info.FirstOrDefault(param => param.Name.ToUpper() == cmd.command_return.ToUpper());
            var lst = get_return_type_and_default_value(cmd);

            if (prm?.enums.Length > 0)
            {
                command_help.Append(create_enum_alias_type(prm)).Append(get_command_header(cmd, file_name)).Append("\n")
                        .Append($"---@type {NODE_ALIAS_STR}{lst[0]}\n")
                        .Append($"{table}.{attr} = {NODE_STR}{lst[1]}\n"); ;
            }
            else
            {

                command_help.Append(get_command_header(cmd, file_name)).Append("\n")
                        .Append($"---@type {lst[0]}\n")
                        .Append($"{table}.{attr} = {lst[1]}\n");

            }

            
        }

        private static string[] ExtractParametersFromSignature(string signature)
        {
            int start = signature.IndexOf("(") + 1;
            int end = signature.IndexOf(")", start);
            try
            {
                return signature.ToUpper().Substring(start, end - start).Replace(" ", "").Split(',');
            }
            catch (Exception)
            {
                return new string[] { };
            }
        }

        private static string FormatParamAnnotation(ParamInfo param)
        {
            return param.enums.Length > 0
                ? $"---@param {param.Name} {NODE_ALIAS_STR}{param.Type} {param.Description}\n"
                : $"---@param {param.Name} {param.Type} {param.Description}\n";
        }

        private static string FormatReturnAnnotation(ParamInfo param)
        {
            return param.enums.Length > 0
                ? $"---@return {NODE_ALIAS_STR}{param.Type} {param.Name} {param.Description}\n"
                : $"---@return {param.Type} {param.Name} {param.Description}\n";
        }

        private static string FormatOverloadDoc(string sig, ParamInfo[] param_info, string command_return)
        {
            int startIndex = sig.IndexOf("(") + 1;
            int endIndex = sig.IndexOf(")", startIndex);
            var overload_params = sig.Substring(startIndex, endIndex - startIndex).Split(',').Select(str => str.Trim()).ToList();
            var overload_sig_and_type = new List<string>();
            var overload_return_type = new List<string>();

            foreach (var param in param_info)
            {
                if (command_return.Contains(param.Name))
                {
                    overload_return_type.Add(param.enums.Length > 0
                        ? $"{param.Name}:{NODE_ALIAS_STR}{param.Type}"
                        : $"{param.Name}:{param.Type}");
                }
                if (overload_params.Contains(param.Name))
                {
                    overload_sig_and_type.Add(param.enums.Length > 0
                        ? $"{param.Name}:{NODE_ALIAS_STR}{param.Type}"
                        : $"{param.Name}:{param.Type}");
                }
            }

            return getOverloadDoc($"({string.Join(",", overload_sig_and_type)}){(overload_return_type.Count > 0 ? ":" : "")}{string.Join(", ", overload_return_type)}") + "\n";
        }

        private static string FormatFunctionDefinition(string function_name, string signature, string table)
        {
            int start = signature.IndexOf("(") + 1;
            int end = signature.IndexOf(")", start);
            var parameters = signature.Substring(start, end - start);

            if (table.Length == 0)// function cmd without table
                return $"function {function_name}({parameters}) end\n";
            else
                return $"local function {function_name}({parameters}) end\n{table}.{function_name} = {function_name}\n";

        }

        public static string getOverloadDoc(string signature)
        {
            var outPut = $@"---@overload fun{signature}";
            return outPut;
        }

        public static string get_command_header(CommandInfo cmd, string file_name)
        {
            var command_header = "\n---**" + cmd.name + "**\n"
                + "----";

            var helpFilePath = $@"{(MODEL_2600B_MODELS.Contains(file_name)?"2600B": file_name )}/{cmd.webhelpfile}";
            command_header += "\n--- **" + cmd.description + "**\n---\n"
            + "--- *Type:*  " + cmd.command_type + "\n---\n"
            + "--- *Details:*<br>\n--- " + cmd.details + "\n---\n"
            + "---[command help](command:kic.viewHelpDocument?[\"" + helpFilePath + "\"])" + "\n---\n"
            + "---<br>*Examples:*<br>\n"
            + "--- ```lua\n";

            foreach (var x in cmd.example_info)
            {
                var exmp = x.example.Split(';');
                foreach (var item in exmp)
                {
                    command_header += "--- " + item + "\n";
                }
                //outStr += "--- " + x.example + "\n"
                command_header += "--- --" + x.description;
            }
            command_header += "--- ```";

            return command_header;

        }

        public static string create_enum_alias_type(ParamInfo param)
        {
            var command_help = "";

            var aliasName = param.Type.Contains('|') ? param.Type.Split('|')[0].Trim() : param.Type;

            EnumInfo[] enum_data = param.enums;
            command_help += "\n";
            foreach (var data in enum_data)
            {
                command_help += $"{NODE_STR}{data.Name} = nil\n";
            }
            command_help += $"\n---@alias {NODE_ALIAS_STR}{aliasName}\n";
            foreach (var data in enum_data)
            {
                command_help += $"---|`{NODE_STR}{data.Name}`\n";
            }
            command_help += "\n";

            return command_help;

        }

        public static void write_to_file(string file_path, string content)
        {
            File.WriteAllText(file_path, content);
        }

        public static string get_trigger_load_cmd_signature(bool forTspLink = false)
        {
           
                return $@"---@param loadFunConst loadFunConstParam
local function load(loadFunConst,...) end
{NODE_STR}trigger.model.load = load";
           
          
        }

        public static string get_trigger_model_setBlock_cmd_signature(bool forTspLink = false)
        {
           
                return $@"
---@param blockNumber integer The sequence of the block in the trigger model
---@param blockType {NODE_ALIAS_STR}triggerBlockBranch
function setblock(blockNumber, blockType,...) end;
{NODE_STR}trigger.model.setblock = setblock
";
            
            
        }

        public static string get_BlockType_alias()
        {
            return $@"
{NODE_STR}trigger.BLOCK_BRANCH_ALWAYS= nil
{NODE_STR}trigger.BLOCK_BRANCH_COUNTER= nil
{NODE_STR}trigger.BLOCK_BRANCH_DELTA= nil
{NODE_STR}trigger.BLOCK_BRANCH_LIMIT_CONSTANT= nil
{NODE_STR}trigger.BLOCK_BRANCH_LIMIT_DYNAMIC= nil
{NODE_STR}trigger.BLOCK_BRANCH_ON_EVENT= nil
{NODE_STR}trigger.BLOCK_BRANCH_ONCE= nil
{NODE_STR}trigger.BLOCK_BRANCH_ONCE_EXCLUDED= nil
{NODE_STR}trigger.BLOCK_BUFFER_CLEAR= nil
{NODE_STR}trigger.BLOCK_CONFIG_NEXT= nil
{NODE_STR}trigger.BLOCK_CONFIG_PREV= nil
{NODE_STR}trigger.BLOCK_CONFIG_RECALL= nil
{NODE_STR}trigger.BLOCK_DELAY_CONSTANT= nil
{NODE_STR}trigger.BLOCK_DELAY_DYNAMIC= nil
{NODE_STR}trigger.BLOCK_DIGITAL_IO= nil
{NODE_STR}trigger.BLOCK_LOG_EVENT= nil
{NODE_STR}trigger.BLOCK_MEASURE_DIGITIZE= nil
{NODE_STR}trigger.BLOCK_NOP= nil
{NODE_STR}trigger.BLOCK_NOTIFY= nil
{NODE_STR}trigger.BLOCK_RESET_BRANCH_COUNT= nil
{NODE_STR}trigger.BLOCK_WAIT= nil


---@alias {NODE_ALIAS_STR}triggerBlockBranch
---| `{NODE_STR}trigger.BLOCK_BRANCH_ALWAYS`
---| `{NODE_STR}trigger.BLOCK_BRANCH_COUNTER`
---| `{NODE_STR}trigger.BLOCK_BRANCH_DELTA`
---| `{NODE_STR}trigger.BLOCK_BRANCH_LIMIT_CONSTANT`
---| `{NODE_STR}trigger.BLOCK_BRANCH_LIMIT_DYNAMIC`
---| `{NODE_STR}trigger.BLOCK_BRANCH_ON_EVENT`
---| `{NODE_STR}trigger.BLOCK_BRANCH_ONCE`
---| `{NODE_STR}trigger.BLOCK_BRANCH_ONCE_EXCLUDED`
---| `{NODE_STR}trigger.BLOCK_BUFFER_CLEAR`
---| `{NODE_STR}trigger.BLOCK_CONFIG_NEXT`
---| `{NODE_STR}trigger.BLOCK_CONFIG_PREV`
---| `{NODE_STR}trigger.BLOCK_CONFIG_RECALL`
---| `{NODE_STR}trigger.BLOCK_DELAY_CONSTANT`
---| `{NODE_STR}trigger.BLOCK_DELAY_DYNAMIC`
---| `{NODE_STR}trigger.BLOCK_DIGITAL_IO`
---| `{NODE_STR}trigger.BLOCK_LOG_EVENT`
---| `{NODE_STR}trigger.BLOCK_MEASURE_DIGITIZE`
---| `{NODE_STR}trigger.BLOCK_NOP`
---| `{NODE_STR}trigger.BLOCK_NOTIFY`
---| `{NODE_STR}trigger.BLOCK_RESET_BRANCH_COUNT`
---| `{NODE_STR}trigger.BLOCK_SOURCE_OUTPUT`
---| `{NODE_STR}trigger.BLOCK_WAIT`
";
        }

        public static string get_def_buffer_Definitions(bool for_tspLink = false)
        {
            return $@"
---@type bufferVar
{NODE_STR}defbuffer1 = {{}}

---@type bufferVar
{NODE_STR}defbuffer2 = {{}}"
;
        }
        public static void SetFileReadOnly(string file_path)
        {
            try
            {
                // Set the file as read-only
                File.SetAttributes(file_path, File.GetAttributes(file_path) | FileAttributes.ReadOnly);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"An error occurred while setting the file as read-only: {ex.Message}");
            }
        }

        public static void RemoveReadOnlyAttributes(string path)
        {
            // Remove read-only attribute from all files in the directory
            string[] files = Directory.GetFiles(path);
            foreach (string file in files)
            {
                File.SetAttributes(file, File.GetAttributes(file) & ~FileAttributes.ReadOnly);
            }

            // Recursively remove read-only attribute from all files in subdirectories
            string[] subDirectories = Directory.GetDirectories(path);
            foreach (string subDir in subDirectories)
            {
                RemoveReadOnlyAttributes(subDir);
            }
        }

        public static void CopyStaticFiles(string model, string folder_path)
        {
            // Specify the source folder path
            string sourceFolderPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "StaticLuaDefinations", model);
             

            try
            {
                // Get all files in the source folder
                string[] files = Directory.GetFiles(sourceFolderPath);

                // Copy each file to the destination folder
                foreach (string file in files)
                {
                    string fileName = Path.GetFileName(file);
                    string destinationFilePath = Path.Combine(folder_path, fileName);
                    File.Copy(file, destinationFilePath, overwrite: true);

                    // Set the copied file as read-only
                    File.SetAttributes(destinationFilePath, File.GetAttributes(destinationFilePath) | FileAttributes.ReadOnly);

                    Console.WriteLine($"Copied {fileName} to {folder_path} and set as read-only.");
                }

                Console.WriteLine("All files copied successfully and set as read-only.");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"An error occurred: {ex.Message}");
            }
        }

        public static void SetStaticVariablesString(DefinitionsType type )
        {
            switch (type)
            {
            case DefinitionsType.Node:
                    Utility.NODE_STR = "node[$node_number$].";
                    Utility.NODE_ALIAS_STR = "node$node_number$_";
                    break;
            case DefinitionsType.Slot:
                    Utility.NODE_STR = "slot[$slot_number$].";
                    Utility.NODE_ALIAS_STR = "slot$slot_number$_";
                    break;
            case DefinitionsType.NodeSlot:
                    Utility.NODE_STR = "node[$node_number$].slot[$slot_number$].";
                    Utility.NODE_ALIAS_STR = "node$node_number$_slot$slot_number$_";
                    break;
            case DefinitionsType.Normal:
                    Utility.NODE_STR = "";
                    Utility.NODE_ALIAS_STR = "";
                    break;
            default:
                break;
            }
        }

        public static string GetStaticLuaTableDefination(DefinitionsType type, string psu_or_smu="")
        {
            var builder = new StringBuilder();

            switch (type)
            {
                case DefinitionsType.Node:
                    builder.AppendLine("node = {node[$node_number$]}");
                    builder.AppendLine("node[$node_number$] = {}");
                    break;

                case DefinitionsType.Slot:
                    builder.AppendLine("slot = {slot[$slot_number$]}");
                    builder.AppendLine("slot[$slot_number$] = {}");
                    builder.AppendLine($"slot[$slot_number$].{psu_or_smu} = {{ slot[$slot_number$].{psu_or_smu}[1], slot[$slot_number$].{psu_or_smu}[2] }}");
                    break;

                case DefinitionsType.NodeSlot:
                    builder.AppendLine("node = {node[$node_number$]}");
                    builder.AppendLine("node[$node_number$] = {}");
                    builder.AppendLine("node[$node_number$].slot = {node[$node_number$].slot[$slot_number$]}");
                    builder.AppendLine("node[$node_number$].slot[$slot_number$] = {}");
                    builder.AppendLine($"node[$node_number$].slot[$slot_number$].{psu_or_smu} = {{ node[$node_number$].slot[$slot_number$].{psu_or_smu}[1], node[$node_number$].slot[$slot_number$].{psu_or_smu}[2] }}");
                    break;

                case DefinitionsType.Normal:
                    // No additional definitions needed for Normal type.
                    break;

                default:
                    throw new ArgumentOutOfRangeException(nameof(type), $"Unsupported DefinitionsType: {type}");
            }

            return builder.ToString();
        }
    }

 
}