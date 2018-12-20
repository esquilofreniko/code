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

class OscClient:
    def __init__(self,ip,port):
        parser = argparse.ArgumentParser()
        parser.add_argument("--ip", default=ip)
        parser.add_argument("--port", type=int, default=port)
        args = parser.parse_args()
        self.client = udp_client.SimpleUDPClient(args.ip, args.port)

    def build_osc_message(self,positioning_values):
        builder = OscMessageBuilder(address='/wek/inputs')
        for v in positioning_values:
            builder.add_arg(v)
        return builder.build()

    def sendMsg(self,msg):
        out = self.build_osc_message(msg)
        self.client.send(out)


class OscServer:
    def print_msg(self,unused_addr, *args):
        self.msg = args
        print(self.msg)
        
    def __init__(self,ip,port,handler):
        self.dispatcher = dispatcher.Dispatcher()
        self.dispatcher.map(handler, self.print_msg)
        self.server = osc_server.ThreadingOSCUDPServer((ip, port), self.dispatcher)
        print("OSC server listening on {}".format(self.server.server_address),"handler:",handler)
        server_thread = threading.Thread(target=self.server.serve_forever)
        server_thread.start()

# Main Loop
oscserver = OscServer("127.0.0.1",4000,"/test")
oscclient = OscClient("127.0.0.1",57120)
print("press q to quit...")
while True:
    oscclient.sendMsg(np.random.rand(15))
    time.sleep(0.05)
    try: 
        if keyboard.is_pressed('q'): 
            oscserver.server.shutdown()
            quit()
            break 
        else:
            pass
    except:
        oscserver.server.shutdown()
        quit()
        break 