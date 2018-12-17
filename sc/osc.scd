o = NetAddr("127.0.0.1", 57110);

o.sendMsg("/test", 1,2,3,4,5);

n = NetAddr.new("127.0.0.1", 56110);    // create the NetAddr
// create the OSCFunc
f = OSCFunc({ arg msg, time, addr, recvPort; [msg, time, addr, recvPort].postln; }, '/goodbye', n);
f.free;    // remove the OSCFunc when you are done.b

f = OSCFunc({ arg msg, time, addr, recvPort; [msg, time, addr, recvPort].postln; }, '/goodbye'); // create the OSCFunc
