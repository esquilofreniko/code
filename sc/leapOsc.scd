NetAddr.localAddr
//Osc Listen on Port 57120
(
thisProcess.removeOSCRecvFunc(f);
f = { |msg, time, addr|
    if(msg[0] == '/grabstrengthR') {
		// "time: % sender: %\nmessage: %\n".postf(time, addr, msg);
		Post << "grabR " << msg[1] << " pinchR";
		msg[2].postln;
		a.setn(\ffreq,1-msg[1]*1000+55);
		a.setn(\freq,55);
    }
};
thisProcess.addOSCRecvFunc(f);
);
thisProcess.removeOSCRecvFunc(f);

(
SynthDef('bass1', {
	arg freq=220,ffreq=20000,fq=0.1,amp=0.5;
	var sig;
	sig = Saw.ar(freq);
	sig = RLPF.ar(sig,ffreq,fq);
	sig = sig*amp;
	Out.ar(0,sig!2);
}).add;
)

a = Synth(\bass1)

(
Pdef('pdbass1',
	Pbind(
		'instrument','bass1',
		'dur',Prand([4],inf),
		'rel',Prand([1],inf),
		'freq',Prand([55],inf),
		'carPartial',Prand([2],inf),
		'modPartial',Prand([0.5],inf),
		'index',Prand([5],inf),
		'amp',Prand([0.25],inf),
		'ffreq',Pwhite(100,10000),
	)
).stop.quant(4);
)