from multiprocessing import Process, Queue, Event
from rasabot import RasaBotProcess

def start_bot(bot_id, bot_path):
    print('Creating a new instance...')
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
    return bot.pid

# def process_message(s):
#     return message
