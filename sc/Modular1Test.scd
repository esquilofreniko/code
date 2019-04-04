s.reboot;

(
~d1 = Buffer.read(s,"d:/music/samples/amen/0.wav");
(
SynthDef("Processing",{
	var in1=0,in2=1,in3=2,in4=3,in5=4,in6=5,in7=6,in8=7,
	clock,reset,out,aux1,aux2;
	in1 = SoundIn.ar(in1,1);
	in2 = SoundIn.ar(in2,1);
	in3 = SoundIn.ar(in3,1);
	in4 = SoundIn.ar(in4,1);
	in5 = SoundIn.ar(in5,1);
	in6 = SoundIn.ar(in6,1);
	in7 = SoundIn.ar(in7,1);
	in8 = SoundIn.ar(in8,1);

	clock = Amplitude.kr(in7,0.01,0.01,1);
	reset = Amplitude.kr(in8,0.01,0.01,1);

	// in1 = PlayBuf.ar(2,~d1.bufnum,0.75,1,0,1)*1;
	in1 = Decimator.ar(in1,44100*0.5,24,1);
	in1 = SwitchDelay.ar(in1,1,1,0.004,0.50,1,1);

	// bass = Decimator.ar(bass,44100,24,1);'
	// bass = DelayC.ar(bass,1,0.001,1,bass);

	out = (in1*0.25)+(in2*0)+(in3*0)+(in4*0)+(in5*0)+(in6*0);
	aux1 = (in1*0.25)+(in2*0)+(in3*0)+(in4*0)+(in5*0)+(in6*0);
	aux2 = (in1*0.25)+(in2*0)+(in3*0)+(in4*0)+(in5*0);
	Out.ar(0,out!2);
	Out.ar(2,aux1!2);
	Out.ar(4,aux2!2);
}).store;
);

(
a.free;
a = Synth(\Processing);
)

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
Pdef('pad1',
	Pbind(
		'instrument', 'pad1',
		'dur', Prand([1/64,1/32,1/16,1/8,1/4,1/2,1,2],inf),
		'midinote', (Prand([0,1,5,7,8],inf) + Prand([12,24,36,48,60,72,84],inf)),
		'atk', Pwhite(1.0,4.0,inf),
		'rel', Pwhite(1.0,4.0,inf),
		'amp', (Pkey('midinote').reciprocal*1),
		'pan', Pwhite(-0.5,0.5,inf),
	)
).play.quant(4);
)