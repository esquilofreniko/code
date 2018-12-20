(
b = NetAddr.new("127.0.0.1", 4000);
b.sendMsg("/filter",4.0,5,6,7,7,6,5,4,3,4,4,124,41,241);
)
b.free;

(
thisProcess.removeOSCRecvFunc(f);
f = { |msg, time, addr|
    if(msg[0] != '/status.reply') {
		"time: % sender: %\nmessage: %\n".postf(time, addr, msg);
    }
};
thisProcess.addOSCRecvFunc(f);
);
thisProcess.removeOSCRecvFunc(f);

( //Receive on LocalPort (57120)
n = NetAddr.localAddr;
OSCFunc.trace(true);
o = OSCFunc({ arg msg, time, addr, recvPort; [msg, time, addr, recvPort].postln; }, '/test', n);
)
o.free;