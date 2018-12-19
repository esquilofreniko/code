( //Send to port 7400
b = NetAddr.new("127.0.0.1", 7400);
b.sendMsg("/hello", 1);
)
b.free;

( //Receive on LocalPort (57120)
n = NetAddr.localAddr;
OSCFunc.trace(true);
o = OSCFunc({ arg msg, time, addr, recvPort; [msg, time, addr, recvPort].postln; }, '/test', n);
)
o.free;