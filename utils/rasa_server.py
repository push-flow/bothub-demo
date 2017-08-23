from socket import *
from multiprocessing import Process
from caller_rasa import start_new_bot

import time
import json


host = 'localhost'
port = 52020
address = host, port

bots = {}

def send_msg_to_bot(uuid, msg):
    import socket
    address = "/tmp/bothub-%s.sock" % uuid
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
        print(1)
        data = conn.recv(1024)
        data = json.loads(data.decode('utf_8'))
        model_path = data.get("model_path", None)
        config_path = data.get("config_path", None)
        msg = data.get("msg", None)
        uuid = data.get("uuid", None)

        if model_path and msg:
            print(2)
            if bots.get(uuid, None):
                print(3)
                print(bots.get(uuid, None))
                try:
                    conn.send(send_msg_to_bot(uuid, msg))
                    conn.close()
                except:
                    conn.close()

            else:
                print(4)
                p = Process(target=start_new_bot, args=(uuid, model_path, config_path, ))
                p.start()
                bots.update({uuid: {
                    "model_path": model_path,
                    "config_path": config_path,
                    "pid": p.pid
                }})
                time.sleep(60)
                if bots.get(uuid, None):
                    print(5)
                    try:
                        conn.send(send_msg_to_bot(uuid, msg))
                        conn.close()
                    except:
                        print("except on send post create bot")
                        conn.close()
        else:
            pass
