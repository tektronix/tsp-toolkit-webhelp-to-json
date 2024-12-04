using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

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

        public static string PrintFields(int depth, string file_name, Dictionary<string, Dictionary<string, CommandInfo>>[] instrTable, bool forTspLink)
        {
            var outStr = "";
            if (forTspLink) // for tsplink node string needs to append in tables
            {
                NODE_STR = "node[$node_number$].";
                NODE_ALIAS_STR = "node$node_number$_";
                outStr += "node = {}\nnode[$node_number$] = {}\n";

            }
            else
            {
                NODE_STR = "";
                NODE_ALIAS_STR = "";
            }
                

            string table_name = "";
            string type_name = "";
            string[] arrList = { };
            for (int i = 0; i < depth; i++)
            {
                foreach (var keyValuePair in instrTable[i])
                {
                    string class_data = "";
                    // Handling Arrays in commands
                    string[] arrayMarkers = { "[N]", "[Y]", "[slot]", "[1]", "[X]" };
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
                                class_data += $"---@class {type_name}\n";
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
                        class_data += "---@class " + keyValuePair.Key + "\n";
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

        public static string HelpContent(KeyValuePair<string, CommandInfo> command, string file_name, string table, bool is_dircet_function = false)
        {
            var command_help = "";

            var cmd = command.Value;

            if (is_dircet_function) // direct commands are not available with node
            {
                NODE_STR = "";
                NODE_ALIAS_STR = "";
            }
            if (cmd.command_type == CommandType.Function)
            {
                // implement function here
                foreach (var param in cmd.param_info)
                {
                    if (param.enums.Length>0)
                    {
                        command_help += create_enum_alias_type(param);
                    }
                }

                command_help += get_command_header(cmd, file_name) + "\n";

                List<string> command_returns = cmd.command_return.ToUpper().Split(',')
                                          .Select(st => st.Trim())
                                          .ToList();

                int start = cmd.signature.IndexOf("(") + 1;
                int end = cmd.signature.IndexOf(")", start);
                string[] s;
                try
                {
                    s = cmd.signature.ToUpper().Substring(start, end - start).Replace(" ", "").Split(',');
                }
                catch (System.Exception)
                {
                    s = new string[] { };
                }
                foreach (var param in cmd.param_info)
                {

                    if (s.Contains(param.Name.ToUpper()))
                    {
                        if (param.enums.Length>0)
                            command_help += $"---@param {param.Name} {NODE_ALIAS_STR}{param.Type} {param.Description}\n";
                        else
                            command_help += $"---@param {param.Name} {param.Type} {param.Description}\n";

                    }
                    else if (command_returns.Contains(param.Name.ToUpper()))
                    {
                        if (param.enums.Length>0)
                            command_help += $"---@return {NODE_ALIAS_STR}{param.Type} {param.Name} {param.Description}\n";
                        else
                            command_help += $"---@return {param.Type} {param.Name} {param.Description}\n";

                        //if (param.Name.Contains("fileNumber"))
                        //    command_help += "file_object ";
                        //else if (param.Name.Contains("scriptVar"))
                        //    command_help += "scriptVar ";
                        //else if (param.Name.Contains("bufferName") || param.Name.Contains("bufferVar"))
                        //    command_help += "bufferVar ";
                        //else if (param.Name.Contains("connectionID"))
                        //    command_help += "tspnetConnectionID ";
                        //else
                        //    command_help += param.Type + " ";

                        //command_help += param.Name + " " + param.Description + "\n";
                    }
                }
                cmd.signature = cmd.signature.Replace("\"", "");

                if (cmd.overloads.Length > 0)
                {
                    // System.Console.WriteLine(cmd.signature);
                    foreach (var sig in cmd.overloads)
                    {
                        
                        int startIndex = sig.IndexOf("(") + 1;
                        int endIndex = sig.IndexOf(")", startIndex);
                        var overlad_params = sig.Substring(startIndex, endIndex - startIndex).Split(',').Select(str => str.Trim()).ToList();
                        IList<string> overload_sig_and_type = new List<string>();
                        IList<string> overload_return_type = new List<string>();
                        foreach (var param in cmd.param_info)
                        {
                            if (cmd.command_return.Contains(param.Name))
                                if (param.enums.Length>0)
                                    overload_return_type.Add($"{param.Name}:{NODE_ALIAS_STR}{param.Type}");
                                else
                                    overload_return_type.Add($"{param.Name}:{param.Type}");
                            if (overlad_params.Contains(param.Name))
                            {
                                if (param.enums.Length>0)
                                    overload_sig_and_type.Add($"{param.Name}:{NODE_ALIAS_STR}{param.Type}");
                                else
                                    overload_sig_and_type.Add($"{param.Name}:{param.Type}");
                            }
                        }

                        command_help += getOverloadDoc($"({string.Join(",", overload_sig_and_type)}){(overload_return_type.Count > 0 ? ":" : "")}{string.Join(", ", overload_return_type)}") + "\n";
                    }
                }


                var function_name = command.Key.Replace("(", "").Replace(")", "");
                if (is_dircet_function)
                {
                    command_help += $"function {function_name}({cmd.signature.Substring(start, end - start)}) end\n";
                }
                else
                {
                    command_help += $"local function {function_name}({cmd.signature.Substring(start, end - start)}) end\n";
                    command_help += $"{table}.{function_name} = { function_name}\n";
                }
                
            }

            else // attributes
            {

                var attr = command.Key.Replace("[M]", "").Replace("[N]", ""); //some attributes are having [N] or [M] at the end , which is alredy handled in its type
                var prm = cmd.param_info.Where(param => param.Name.ToUpper() == cmd.command_return.ToUpper()).ToList();
                var lst = get_return_type_and_default_value(cmd);
                if (prm[0].enums.Length>0)
                {
                    command_help += create_enum_alias_type(prm[0]);
                    command_help += get_command_header(cmd, file_name) + "\n";

                    command_help += $"---@type {NODE_ALIAS_STR}{lst[0]}\n";
                    command_help += $"{table}.{attr} = {NODE_STR}{lst[1]}\n";
                }
                else
                {
                    command_help += get_command_header(cmd, file_name) + "\n";

                    command_help += $"---@type {lst[0]}\n";
                    command_help += $"{table}.{attr} = {lst[1]}\n";
                }
            }
            return command_help;
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

    }
}