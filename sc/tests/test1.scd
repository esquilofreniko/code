
(
SynthDef("fm1", {
	arg bus = 0, freq = 440, atk = 1, rel = 2, carPartial = 1, modPartial = 1, index = 3, amp = 0.05;
	var mod,car,sig,env;
	env = EnvGen.kr(Env([0,1,0],[atk,rel]),doneAction:2);
	mod = SinOsc.ar(freq * modPartial, 0, freq * index * LFNoise1.kr(5.reciprocal).abs);
	car = Saw.ar((freq * carPartial) + mod,0);
	sig = car * env * amp;
	Out.ar(0,sig!2);
}).add;
)

(
Pdef('pfm1',
	Pbind(
		'instrument', 'fm1',
		'dur', Prand([4],inf),
		'midinote', Prand([12],inf),
		'atk', Pwhite(0.1,4.0,inf),
		'rel', Pwhite(0.1,4.0,inf),
		'carPartial', Prand([1],inf),
		'modPartial', Prand([1],inf),
		'index', Pwhite(1,inf),
		'amp', Prand([0.02],inf),
	)
).play.quant(1);
)