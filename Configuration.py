# Folder path of webhelp file
import os

class Confiurations:
    HELP_FILE_FOLDER_PATH = "C:\\Users\\rjha\\source\\repos\\GitHub\\tsp-toolkit-webhelp\\WebHelpDocs\\Commands_DMM7510\\"

    # model number
    MODEL_NUMBER = "DMM7510"

    # Currently ist only get used for 26xx models
    CHANNELS = ['a']

    # folder path where generated json file will store
    OUTPUT_FOLDER_PATH = os.path.join(os.getcwd(), "data")

    SUPPORTED_MODELS = ["2450",
                        "2460",
                        "2461",
                        "2470",
                        "DMM7510",
                        "26XX",
                        "2651A",
                        "2657A",
                        ]
    
    MODEL_2650A_CHANNELS= {"2651A":["a"], 
                          "2657A":["a"],
    }
    
    MODEL_2600B_CHANNELS= {"2601B":["a"], 
                          "2611B":["a"],
                          "2635B": ["a"],
                          "2604B": ["a", "b"],
                          "2614B": ["a", "b"],
                          "2602B": ["a", "b"],
                          "2612B": ["a", "b"],
                          "2634B": ["a", "b"],
                          "2636B": ["a", "b"]
                          }