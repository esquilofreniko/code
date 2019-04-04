(
SynthDef('drums1', {
	arg kfreq=110,amp=1,kenv=1/8,rel=1/8,sound=0,freq=1000,modPartial=1,carPartial=1,index=100,sound2=0;
	var sig, env,henv,hhenv,mod,sig2;
	mod = SinOsc.ar(freq * modPartial,0,freq*index.abs);
	env = EnvGen.kr(Env([1,0],[rel]),doneAction:2);
	henv = EnvGen.kr(Env([1,0],[rel/4]));
	hhenv = EnvGen.kr(Env([1,0],[rel/8]));
	sig = Select.ar(sound,[
		SinOsc.ar(0),
		SinOsc.ar(kfreq*EnvGen.kr(Env([1,0],[kenv]))).tanh*50*env,
		HPF.ar(WhiteNoise.ar,1000).tanh*1*env,
		SinOsc.ar((freq*carPartial)+mod)*0.5*henv,
	]);
	sig2 = Select.ar(sound2,[
		SinOsc.ar(0),
		HPF.ar(WhiteNoise.ar*hhenv,8000)*0.5,
	]);
	sig = (Limiter.ar((sig),16) + sig2) * amp;
	Out.ar(0,sig!2);
}).add;
)

(
Pdef('pd1',
	Pbind(
		'instrument','drums1',
		'dur', Prand([1/6],inf),
		'freq',  Pwhite(100,10000),
		'index', Pwhite(100,10000),
		'modPartial',Pwhite(0,100),
		'carPartial',Pwhite(0,10),
		'sound', Pseq([
Prand([1    ]),
Prand([0,3,1,2,3,0]),
Prand([0,3,1,2,3,0]),
Prand([0,3,1,2,3,0]),
Prand([0,3,1,2,3,0]),
Prand([0,3,1,2,3,0]),
Prand([0,3,1,2,3,0]),
Prand([0,3,1,2,3,0]),
Prand([2  ]),
Prand([0,3,1,2,3,0]),
Prand([0,3,1,2,3,0]),
Prand([0,3,1,2,3,0]),
Prand([0,3,1,2,3,0]),
Prand([0,3,1,2,3,0]),
Prand([0,3,1,2,3,0]),
Prand([0,3,1,2,3,0]),
	    ],inf),
		'sound2',Prand([0,1,0],inf),
		'rel', Prand([1/4,1/8,1/16],inf),
		'kenv', Prand([1/16],inf),
		'kfreq', Prand([110],inf),
		'amp', 0.5,
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
).play.quant(4);
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