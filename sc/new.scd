~kBuf = Buffer.read(s,"d/tnp/drums/k/a1.wav");
// ~sBuf = Buffer.read(s, "d/tnp/drums/s/g1.wav");

{PlayBuf.ar(1,~kBuf.bufnum,1,1,0,0)}.play;

(
SynthDef('drums1', {
	arg amp=1,out,kTrig,sTrig;
	var sig,sound;
	k = PlayBuf.ar(1,~kBuf.bufnum,1,kTrig,0,0);
	s = PlayBuf.ar(1,~sBuf.bufnum,1,sTrig,0,0);
	// sig = Select.ar(sound,[
	// SinOsc.ar(0),
	// k,
	// s,
// ]);
	sig = k + s;
	sig = sig * amp;
	Out.ar(out,sig);
}).add;
)

(
Pdef('pd1',
	Pbind(
		'instrument','drums1',
		'dur', Prand([1/6],inf),
		'kTrig', Prand([0,1],inf),
		'sTrig', Prand([0,1],inf),
		// 'freq',  Pwhite(100,10000),
		// 'index', Pwhite(100,10000),
		// 'modPartial',Pwhite(0,100),
		// 'carPartial',Pwhite(0,10),
/*		'sound', Pseq([
			Prand([1    ]),
			Prand([1,3,3,0]),
			Prand([1,3,3,0]),
			Prand([1,3,3,0]),
			Prand([1,3,3,0]),
			Prand([1,3,3,0]),
			Prand([1,3,3,0]),
			Prand([1,3,3,0]),
			Prand([2  ]),
			Prand([2,3,3,0]),
			Prand([2,3,3,0]),
			Prand([2,3,3,0]),
			Prand([2,3,3,0]),
			Prand([2,3,3,0]),
			Prand([2,3,3,0]),
			Prand([2,3,3,0]),
	    ],inf),*/
		// 'rel', Prand([1/4,1/8,1/16],inf),
		// 'kenv', Prand([1/16],inf),
		// 'kfreq', Prand([240],inf),
		'amp', [0.2],
		\out, 0,
		\osc, Pfunc
	)
).play.quant(4);
)

(
SynthDef('bass1', {arg freq=55,modPartial=1,carPartial=1,index=1,amp=0.5,rel=10,ffreq=2000,fq=0.25;
	var mod,sig,env;
	env = EnvGen.kr(Env([1,0],[rel]),doneAction:2);
	mod = SinOsc.ar(freq*modPartial,1,freq*index.abs);
	sig = Saw.ar((freq*carPartial) + mod);
	sig = RLPF.ar(sig,ffreq,fq);
	sig = sig*amp;
	Out.ar(0,sig!2);
}).add;
)

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
		'amp',Prand([0.5],inf),
		'ffreq',Pwhite(100,10000),
	)
).stop.quant(4);
)

(
SynthDef('pad1', {
	arg out = 0,freq = 440, atk = 0.005, rel= 0.3, amp = 1, pan = 0;
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env.new([0,1,0],[atk,rel],[1,-1]),doneAction:2);
	sig = Pan2.ar(sig,pan,amp);
	sig = sig * env * 1;
	Out.ar(out,sig!2);
}).add;
)

(
Pdef('pp1',
	Pbind(
		'instrument', 'pad1',
		'dur', Prand([1/64,1/32,1/16,1/8,1/4,1/2,1,2],inf),
		'midinote', (Prand([0,1,5,7,8],inf) + Prand([12,24,36,48,60,72,84],inf)),
		'atk', Pwhite(1.0,4.0,inf),
		'rel', Pwhite(1.0,4.0,inf),
		'amp', (Pkey('midinote').reciprocal*1),
		'pan', Pwhite(-0.5,0.5,inf),
		'out', ~scIn,
	)
).play.quant(4);
)