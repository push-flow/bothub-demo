from rasa_nlu.model import Metadata, Interpreter
from rasa_nlu.config import RasaNLUConfig

import json


def get_rasa_response(path, text):
    metadata = Metadata.load(path)   # where model_directory points to the folder the model is persisted in
    interpreter = Interpreter.load(metadata, RasaNLUConfig("/home/victor/projetos/elixir/phoenix/ralixir/utils/config-rasa.json"))
    return json.dumps(interpreter.parse(unicode(text)))
