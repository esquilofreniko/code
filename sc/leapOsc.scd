( //Receive on LocalPort (57120)
n = NetAddr.localAddr;
OSCFunc.trace(true);
o = OSCFunc({ arg msg, time, addr, recvPort; [msg, time, addr, recvPort].postln; }, '/fingertips', n);
)
o.free;

//fingertips 0 = Thumb (go from there)

//grabstrength 0 = grab ; 1 = pinch
