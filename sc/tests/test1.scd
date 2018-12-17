
(
SynthDef("fm1", {
	arg bus = 0, freq = 440, atk = 1, rel = 2, carPartial = 1, modPartial = 1, index = 3, amp = 0.05;
	var mod,car,sig,env;
	env = EnvGen.kr(Env([0,1,0],[atk,rel]),doneAction:2);
	mod = SinOsc.ar(freq * modPartial, 0, freq * index * LFNoise1.kr(5.reciprocal).abs);
	car = SinOsc.ar((freq * carPartial) + mod,0);
	sig = car * env * amp;
	Out.ar(0,sig!2);
}).add;
)

(
Pdef('pfm1',
	Pbind(
		'instrument', 'fm1',
		'dur', Prand([1/2,1,2],inf),
		'midinote', Prand([24],inf),
		'atk', Pwhite(1.0,4.0,inf),
		'rel', Pwhite(1.0,4.0,inf),
		'carPartial', Prand([1],inf),
		'modPartial', Prand([1,1],inf),
		'index', Pwhite(1,64,inf),
		'amp', Prand([0.02],inf),
	)
).stop.quant(1);
)

(
SynthDef('drums1', {
	arg kfreq = 110, amp = 1, kenv = 1/8, rel=1/8, sound=0;
	var sig, env;
	env = EnvGen.kr(Env([1,0],[rel]),doneAction:2);
	sig = Select.ar(sound,[
		SinOsc.ar(0),
		SinOsc.ar(kfreq*EnvGen.kr(Env([1,0],[kenv]))).tanh*20,
		HPF.ar(WhiteNoise.ar,1000)*0.05.tanh*10,
		SinOsc.ar(96.midicps)*0.025,
	]);
	sig = sig * env;
	sig = sig * amp;
	Out.ar(0,sig!2);
}).add;
)

(
Pdef('pd1',
	Pbind(
		'instrument','drums1',
		'dur', Prand([1/8,1/4,1/2],inf),
		'sound', Prand([0,1,2,0],inf).trace,
		'rel', Prand([1/8,1/7,1/6,1/5,1/4],inf),
		'kfreq', Prand([110],inf),
	    'kenv', Prand([1/8],inf),
		'amp', 0.4,
	)
).play.quant(1);
)

(
SynthDef('pad1', {
	arg freq = 440, atk = 0.005, rel= 0.3, amp = 1, pan = 0;
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env.new([0,1,0],[atk,rel],[1,-1]),doneAction:2);
	sig = Pan2.ar(sig,pan,amp);
	sig = sig * env * 0.5;
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
		'amp', (Pkey('midinote').reciprocal).trace,
		'pan', Pwhite(-0.5,0.5,inf),
	)
).play.quant(1);
)

(
SynthDef('acid1', {
	arg freq = 55, ffreq = 55, res = 0.1, rel = 0.25, amp = 0.01;
	var sig, env;
	env = EnvGen.kr(Env([1,0],[rel]),doneAction:2);
	sig = Saw.ar(freq);
	sig = RLPF.ar(sig, (ffreq*env),res);
	sig = sig * amp * env;
	Out.ar(0,sig!2);
}).add;
)

(
Pdef('pa1',
	Pbind(
		'instrument','acid1',
		'dur', Prand([1/8,1/4,1/2,1],inf),
		'midinote', Prand([0,2,3,5],inf) + Prand([0,12],inf),
		'ffreq', Pexprand(1000,10000,inf),
		'res', Pwhite(0.01,0.1,inf),
		'rel', Pkey('dur')/2,
		'amp', Pseq([0.075],inf),
	)
).stop.quant(1);
)
