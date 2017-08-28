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
