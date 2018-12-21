import argparse
import math
import threading
import numpy as np
from pythonosc import dispatcher
from pythonosc import udp_client
from pythonosc import osc_server
from pythonosc import osc_message_builder
from pythonosc.osc_message_builder import OscMessageBuilder

class OscClient:
    def __init__(self,ip,port,address):
        self.ip = ip
        self.port = port
        self.address = address
        parser = argparse.ArgumentParser()
        parser.add_argument("--ip", default=ip)
        parser.add_argument("--port", type=int, default=port)
        args = parser.parse_args()
        self.client = udp_client.SimpleUDPClient(args.ip, args.port)

    def sendMsg(self,msg):
        builder = OscMessageBuilder(address=self.address)
        for v in msg[0]:
            builder.add_arg(v)
        out = builder.build()
        print("sent predictions to",self.ip,"on port",self.port,"with address",self.address)
        self.client.send(out)

class OscServer:
    def getX(self,unused_addr, *args):
        self.xin = args
        print(self.xhandler,"received with size:",np.array(self.xin).size)

    def getY(self,unused_addr, *args):
        self.yin = args
        print(self.yhandler,"received with size:",np.array(self.yin).size)
        
    def __init__(self,ip,port,xhandler,yhandler):
        self.xin = np.array([0])
        self.yin = np.array([0])
        self.xhandler = xhandler
        self.yhandler = yhandler
        self.dispatcher = dispatcher.Dispatcher()
        self.dispatcher.map(xhandler, self.getX)
        self.dispatcher.map(yhandler,self.getY)
        self.server = osc_server.ThreadingOSCUDPServer((ip, port), self.dispatcher)
        print("OSC server listening on {}".format(self.server.server_address),"with handlers:",self.xhandler,self.yhandler)
        server_thread = threading.Thread(target=self.server.serve_forever)
        server_thread.start()