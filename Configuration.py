# Folder path of webhelp file
import os

class Confiurations:
    HELP_FILE_FOLDER_PATH = ""

    # model number
    MODEL_NUMBER = ""

    # Currently ist only get used for 26xx models
    CHANNELS = []

    # folder path where generated json file will store
    OUTPUT_FOLDER_PATH = os.path.join(os.getcwd(), "data")

    SUPPORTED_MODELS = ["2450",
                        "2460",
                        "2461",
                        "2470",
                        "DMM7510",
                        "2600B",
                        "2651A",
                        "2657A",
                        "2601B-PULSE"
                        ]
    
    MODEL_2600B_MODELS = [
        "2601B", 
        "2611B",
        "2635B",
        "2604B",
        "2614B",
        "2602B",
        "2612B",
        "2634B",
        "2636B"
    ]
    
    MODEL_CHANNELS= {"2601B":["a"], 
                          "2611B":["a"],
                          "2635B": ["a"],
                          "2604B": ["a", "b"],
                          "2614B": ["a", "b"],
                          "2602B": ["a", "b"],
                          "2612B": ["a", "b"],
                          "2634B": ["a", "b"],
                          "2636B": ["a", "b"],

                          "2651A":["a"], 
                          "2657A":["a"],
                          "2601B-PULSE": ["a"]
                          }