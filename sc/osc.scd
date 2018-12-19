b = NetAddr.new("127.0.0.1", 7400);    // create the NetAddr
b.sendMsg("/hello", "there");    // send the application the message "hello" with the parameter "there"

//RECEIVE OSC ON PORT 57120
NetAddr.localAddr
// create the OSCFunc
o = OSCFunc({ arg msg, time, addr, recvPort; [msg, time, addr, recvPort].postln; }, '/goodbye', n);
o.free;    // remove the OSCFunc when you are done.