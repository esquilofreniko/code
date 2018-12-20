import argparse
import math
import threading
import random
import time
import keyboard
import numpy as np
from pythonosc import dispatcher
from pythonosc import udp_client
from pythonosc import osc_server
from pythonosc import osc_message_builder
from pythonosc.osc_message_builder import OscMessageBuilder

def oscInit(port):
    parser = argparse.ArgumentParser()
    parser.add_argument("--ip", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=port)
    args = parser.parse_args()
    client = udp_client.SimpleUDPClient(args.ip, args.port)
    return client

def build_osc_message(positioning_values):
    builder = OscMessageBuilder(address='/wek/inputs')
    for v in positioning_values:
        builder.add_arg(v)
    return builder.build()

def print_filter_handler(unused_addr, *args):
    x = args
    print(x)

dispatcher = dispatcher.Dispatcher()
dispatcher.map("/filter", print_filter_handler)
server = osc_server.ThreadingOSCUDPServer(("127.0.0.1", 4000), dispatcher)
print("Serving on {}".format(server.server_address))
server_thread = threading.Thread(target=server.serve_forever)
server_thread.start()
client = oscInit(57120)

# Main Loop
print("press q to quit...")
while True:
    msg = build_osc_message(np.random.rand(15))
    client.send(msg)
    time.sleep(0.05)
    try: 
        if keyboard.is_pressed('q'): 
            server.shutdown()
            quit()
            break 
        else:
            pass
    except:
        server.shutdown()
        quit()
        break 