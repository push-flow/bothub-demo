import io
import os
from future.utils import PY3
import cloudpickle
from rasa_nlu.training_data import Message
import spacy
import dill
import json

def interpreter(lang, message, model_path):
    s = spacy.load(lang)
    classifier_file = model_path + "/intent_classifier.pkl"
    with io.open(classifier_file, 'rb') as f:  # pragma: no test
        if PY3:
            t = cloudpickle.load(f, encoding="latin-1")
        else:
            t = cloudpickle.load(f)

    message = Message(message, {"intent": {"name": "", "confidence": 0.0}, "entities": []}, time=None)
    message.set("spacy_doc", s(message.text))
    message.set("text_features", message.get("spacy_doc").vector)
    t.process(message)
    return message.as_dict()