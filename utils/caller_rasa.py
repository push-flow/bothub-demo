from rasa_nlu.model import Metadata, Interpreter
from rasa_nlu.config import RasaNLUConfig

import json
import os
import pickle
import dill

OS_PATH = os.path.dirname(os.path.abspath(__file__))
MODEL_PATH = os.path.dirname(os.path.abspath(__file__)) + "/models/model_20170811-174056"

def start_interpreter(path):
    metadata = Metadata.load(MODEL_PATH)
    interpreter = Interpreter.load(metadata, RasaNLUConfig(OS_PATH+"/config-rasa.json"))
    return pickle.dumps(interpreter)

def interpretator(msg, interpreter):
    return pickle.loads(interpreter).parse(unicode(msg))

