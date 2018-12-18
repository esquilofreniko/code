// o = NetAddr("127.0.0.1", 57110);

n.sendMsg("/testout", 1,2,3,4,5);

o.free

(
//Listen
// OSCFunc.trace(false);
n = NetAddr.new("127.0.0.1", 7400);
f = OSCFunc({ arg msg, time, addr, recvPort; [msg, time, addr, recvPort].postln;}, \test, n);
)

f.free;

1.postln