import json


def getParamTypeDetails(filePath) -> dict[str, dict[str, str]]:
    with open(filePath, encoding="utf-8") as file:
        try:
            data = json.load(file)
        except ValueError as error:
            raise ValueError(f"{filePath}: {error}") from error
    return data
