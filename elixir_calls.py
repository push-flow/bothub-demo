from multiprocessing import Process, Queue, Event
from rasabot import RasaBotProcess

def start_bot(bot_id, bot_path):
    print('Creating a new instance...')
    rasa_config = '%s/config-rasa.json' % str(bot_path, "utf_8")
    model_dir = '%s/model' % str(bot_path, "utf_8")
    data_file = '%s/zika_en.json' % str(bot_path, "utf_8")
    bot_id = str(bot_id, "utf_8")
    bot = RasaBotProcess(bot_id, rasa_config, model_dir, data_file)
    bot.daemon = True
    bot.start()
    return bot.pid

def process_message(self, question, bot_id, bot_path):
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