from rasa_nlu.model import Metadata, Interpreter
from rasa_nlu.config import RasaNLUConfig

import os
import dill
import pickle

OS_PATH = os.path.dirname(os.path.abspath(__file__))


def start_interpreter(model_path):
    metadata = Metadata.load(model_path)
    interpreter = Interpreter.load(metadata, RasaNLUConfig(OS_PATH+"/config-rasa.json"))
    return pickle.dumps(interpreter)

def interpretator(msg, interpreter):
    return pickle.loads(interpreter.parse(msg))

a = start_interpreter(OS_PATH + "/models/model_20170816-175043")

b = interpretator("i want food", a)

print(b)