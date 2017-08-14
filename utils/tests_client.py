from socket import *
import json
 
host = 'localhost'
port = 52035
sock = socket()
sock.connect((host, port)) 
k = {'model_path':'/Users/victor/projetos/elixir/phoenix/ralixir/utils/models/model_20170811-174056', 'msg': 'i want food' }
sock.send(json.dumps(k).encode('utf8').strip())