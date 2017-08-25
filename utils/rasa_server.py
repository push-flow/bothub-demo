from socket import *
from rasabot import RasaBot
from rasabot import RasaBotProcess
from multiprocessing import Queue
from multiprocessing import Event

import time
import json


class BotManager():
    '''
    javascript client:
    var ws = new WebSocket('ws://localhost:8888/ws');
    ws.onmessage = (evt) => {
        console.log(JSON.parse(evt.data));
    }
    var bot_message = {
        question: 'Whos there?',
        botId: '123456'
    }
    ws.send(JSON.stringify(bot_message))
    '''
    _pool = {}

    def _get_bot_data(self, bot_id, bot_path):
        bot_data = {}
        if bot_id in self._pool:
            print('Reusing an instance...')
            bot_data = self._pool[bot_id]
        else:
            print('Creating a new instance...')
            ####################### V1
            # bot = RasaBot('../etc/spacy/config.json')
            # bot.trainning('../etc/spacy/data/demo-rasa.json', '../etc/spacy/models/')
            ####################### V2
            rasa_config = '%s/config-rasa.json' % bot_path
            model_dir = '%s/model' % bot_path
            data_file = '%s/zika_en.json' % bot_path
            answers_queue = Queue()
            questions_queue = Queue()
            new_question_event = Event()
            new_answer_event = Event()
            bot = RasaBotProcess(questions_queue, answers_queue, new_question_event, new_answer_event, rasa_config, model_dir, data_file)
            bot.daemon = True
            bot.start()
            bot_data['bot_instance'] = bot
            bot_data['answers_queue'] = answers_queue
            bot_data['questions_queue'] = questions_queue
            bot_data['new_question_event'] = new_question_event
            bot_data['new_answer_event'] = new_answer_event
            self._pool[bot_id] = bot_data
        return bot_data

    def _get_new_answer_event(self, bot_id, bot_path):
        return self._get_bot_data(bot_id, bot_path)['new_answer_event']

    def _get_new_question_event(self, bot_id, bot_path):
        return self._get_bot_data(bot_id, bot_path)['new_question_event']

    def _get_questions_queue(self, bot_id, bot_path):
        return self._get_bot_data(bot_id, bot_path)['questions_queue']

    def _get_answers_queue(self, bot_id, bot_path):
        return self._get_bot_data(bot_id, bot_path)['answers_queue']

    def ask(self, question, bot_id, bot_path):
        questions_queue = self._get_questions_queue(bot_id, bot_path)
        answers_queue = self._get_answers_queue(bot_id, bot_path)
        questions_queue.put(question)
        new_question_event = self._get_new_question_event(bot_id, bot_path)
        new_question_event.set()
        # Wait for answer...
        # This is not the best aproach! But works for now. ;)
        # while answers_queue.empty():
        #     time.sleep(0.001)
        new_answer_event = self._get_new_answer_event(bot_id, bot_path)
        new_answer_event.wait()
        new_answer_event.clear()
        return answers_queue.get()

    def start_bot_process(self, bot_id, bot_path):
        self._get_questions_queue(bot_id, bot_path)


host = 'localhost'
port = 52020
address = host, port

with socket() as sock:
    bm = BotManager()
    sock.bind(address)
    sock.listen()

    while True:
        conn, _ = sock.accept()
        print(1)
        data = conn.recv(1024)
        data = json.loads(data.decode('utf_8'))

        uuid = data.get("uuid", None)
        bot_path = data.get("bot_path", None)
        bm.start_bot_process(uuid, bot_path)

        msg = data.get("msg", None)

        if bot_path and msg:
            print(2)
            answer = bm.ask(msg, uuid, bot_path)
            answer_data = {
                'botId': uuid,
                'answer': answer
            }
            conn.send(json.dumps(answer_data).encode())
            conn.close()
        else:
            print(3)
            conn.close()
