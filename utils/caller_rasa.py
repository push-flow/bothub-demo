from rasa_nlu.training_data import Message
from future.utils import PY3

import sys
import socket, os, io
import hashlib
import json
import spacy
import cloudpickle


OS_PATH = os.path.dirname(os.path.abspath(__file__))

class SpacyServer(object):
    def __init__(self, lang, model_path):
        self.s = spacy.load(lang, parse=False)
        classifier_file = model_path + "/intent_classifier.pkl"
        with io.open(classifier_file, 'rb') as f:  # pragma: no test
            if PY3:
                self.t = cloudpickle.load(f, encoding="latin-1")
            else:
                self.t = cloudpickle.load(f)

            


    def interpretator(self, msg):
        message = Message(str(msg, "utf_8"), {"intent": {"name": "", "confidence": 0.0}, "entities": []}, time=None)
        message.set("spacy_doc", self.s(message.text))
        message.set("text_features", message.get("spacy_doc").vector)
        self.t.process(message)

        return str(message.as_dict(only_output_properties=True))


def start_new_bot(uuid, lang, model_path):

    spacy_server = SpacyServer(lang, model_path) 
    with socket.socket(socket.AF_UNIX) as s:

        try:
            os.remove("/tmp/bothub-%s.sock" % uuid)
        except OSError:
            pass

        s.bind("/tmp/bothub-%s.sock" % uuid)
        s.listen(1)
        while True:
            conn, addr = s.accept()
            data = conn.recv(5000)
            if data:
                conn.send(spacy_server.interpretator(data).encode())
                conn.close()
            else:
                conn.close()
