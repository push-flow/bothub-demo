from socket import *
from multiprocessing import Process
from caller_rasa import start_new_bot

import time
import hashlib
import json


host = 'localhost'
port = 52035
address = host, port

bots = {}

def send_msg_to_bot(botname, msg):
    import socket
    address = "/tmp/bothub-%s.sock" % botname
    print(address)
    client = socket.socket(socket.AF_UNIX)
    client.connect(address)
    client.send(msg.encode())
    retorno = client.recv(2048)
    client.close()

    return retorno

with socket() as sock:
    sock.bind(address)
    sock.listen()

    while True:
        conn, _ = sock.accept()
        
        data = conn.recv(1024)
        data = json.loads(data)
        model_path = data.get("model_path", None)
        msg = data.get("msg", None)

        if model_path and msg:

            botname_hash = hashlib.sha256(model_path.encode()).hexdigest()
            if bots.get(botname_hash, None):
                print(send_msg_to_bot(botname_hash, msg))
                conn.close()

            else:
                p = Process(target=start_new_bot, args=(model_path, ))
                p.start()
                bots.update({botname_hash: {
                    "model_path": model_path,
                    "pid": p.pid
                }})
                time.sleep(10)
                if bots.get(botname_hash, None):
                     print(send_msg_to_bot(botname_hash, msg))
                     conn.close()
        else:
            pass
