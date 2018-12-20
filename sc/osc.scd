

(
b = NetAddr.new("127.0.0.1", 4000);
b.sendMsg("/keras1in",rand(100)/100,rand(100)/100,rand(100)/100);
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