(
SynthDef('bass1', {
	arg freq = 440, atk = 0.005, rel= 0.3, amp = 1, frel = 0.5,ffreq = 1000;
	var sig, env, fenv;
	sig = Saw.ar(freq);
	env = EnvGen.kr(Env.new([0,1,0],[atk,rel],[1,-1]),doneAction:2);
	fenv = EnvGen.kr(Env.new([1,0],[frel]),doneAction:2);
	sig = LPF.ar(sig,fenv*ffreq);
	sig = sig * env * 1;
	Out.ar(0,sig!2);
}).add;
)

(
Pdef('pb1',
	Pbind(
		'instrument', 'bass1',
		'dur', Prand([2],inf),
		'midinote', (Prand([0],inf) + Prand([24],inf)),
		'atk', Prand([0],inf),
		'rel', Prand([1],inf),
		'frel', Prand([1],inf),
		'ffreq', Prand([5000],inf),
		'amp', Prand([0.5],inf),
	)
).stop.quant(4);
)


(
SynthDef('pad1', {
	arg freq = 440, atk = 0.005, rel= 0.3, amp = 1, pan = 0;
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env.new([0,1,0],[atk,rel],[1,-1]),doneAction:2);
	sig = Pan2.ar(sig,pan,amp);
	sig = sig * env * 1;
	Out.ar(0,sig!2);
}).add;
)

(
Pdef('pp1',
	Pbind(
		'instrument', 'pad1',
		'dur', Prand([1/64,1/32,1/16,1/8,1/4,1/2,1,2],inf),
		'midinote', (Prand([0,1,5,7,8],inf) + Prand([12,24,36,48,60,72,84],inf)).trace,
		'atk', Pwhite(1.0,4.0,inf),
		'rel', Pwhite(1.0,4.0,inf),
		'amp', (Pkey('midinote').reciprocal*1).trace,
		'pan', Pwhite(-0.5,0.5,inf),
	)
).play.quant(4);
)
