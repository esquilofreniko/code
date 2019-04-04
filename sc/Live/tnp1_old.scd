(
Server.local.quit;
Server.local.options.device = "Focusrite USB ASIO";
Server.local.options.numOutputBusChannels = 6;
Server.local.options.numInputBusChannels = 8;
Server.local.boot;
)

s.plotTree


(
~g0.free;
~g0 = Group.new(s);
~g1.free;
~g1 = Group.after(~g0);
~ks.free;
~ks = Bus.audio(s);
~drums.free;
~drums = Bus.audio(s);
~bass.free;
~bass = Bus.audio(s);
~ambient.free;
~ambient = Bus.audio(s);
);
)

(
~s1.free;
~s1 = Buffer.read(s,"d:/music/samples/amen/0.wav");
SynthDef(\drums, {
	arg out,sample,rate = 0.75;
	var sig;
	sig = PlayBuf.ar(2,sample,rate,\t_tr.kr(1,0),0,1)*1;
	Out.ar(out,sig);
}).add;
SynthDef(\uDelay,{
	arg in,out,dry=1,wet=1,time=0.001,fb=0.5;
	var sig;
	sig = In.ar(in);
	sig = SwitchDelay.ar(sig,dry,wet,time,fb,10);
	ReplaceOut.ar(out,sig!2);
}).add;
)

(
~in1.free;
~in1 = Synth.new(\drums,[\sample,~s1,\out,0]);
~fx1.free;
~fx1 = Synth.after(~in1,\uDelay,[\in,0,\out,0]);
)

x.set(\rate,0.5,\t_tr,0);

(
// Synth.tail(x, "drums");
// Synth.tail(x, "preDelay");
// Synth.tail(s, "combs");
// Synth.tail(s, "allpass");
// Synth.tail(s, "theMixer");
)

(
s.queryAllNodes;
)


ReplaceOut

















































(
SynthDef(\rout,{
	arg in,out;
	var sig;
	sig = In.ar(in);
	Out.ar(out,sig);
}).add;
);
(
SynthDef(\output,{
	arg in,out,amp=1;
	var sig;
	sig = In.ar(in);
	sig = sig*amp;
	Out.ar(out,sig!2);
}).add;
);
(
SynthDef(\bitCrush,{
	arg in,out,rate=1,bit=24,amp=1;
	var source,sig;
	source = In.ar(in);
	sig = Decimator.ar(source,44100*rate,bit)*amp;
	Out.ar(out,sig!2);
}).add;
);
(
SynthDef(\uDelay,{
	arg in,out,dry=1,wet=1,time=0.001,fb=0.5;
	var source,sig;
	sig = In.ar(in);
	sig = SwitchDelay.ar(sig,dry,wet,time,fb,10);
	Out.ar(out,sig!2);
}).add;
);
(
SynthDef(\play,{
	arg sample,out,rate=1,trig=1;
	var sig;
	sig = PlayBuf.ar(2,sample,rate,trig,0,1)*1;
	Out.ar(out,sig);
}).add;
);
)

(
~s1.free;
~s1 = Buffer.read(s,"d:/music/samples/amen/0.wav");
)


f = {arg one, two;var out; out = one + two; out.postln;};
f(1,2);

(
d.free;
d = Synth.new(\play,[\out,~b0,\sample,~s1]);
x.free;
x = Synth.new(\uDelay,[\in,~b0,\out,0]);
)

d.set(\rate,1,\trig,1);
x.set(\dry,1,\wet,1,\time,0.001,\fb,0.5);

(
// ~freez = Buffer.alloc(s,s.sampleRate * 1,1);
(
x.free;
x = SynthDef(\main,{
	arg amp = 1;
	var in1,in2,in3,in4,in5,in6,in7,in8,freez,
	tempo,clock,reset,ks,hh,drums,out,aux1,aux2;
	in1 = SoundIn.ar(0,1);
	in2 = SoundIn.ar(1,1);
	in3 = SoundIn.ar(2,1);
	in4 = SoundIn.ar(3,1);
	in5 = SoundIn.ar(4,1);
	in6 = SoundIn.ar(5,1);
	in7 = SoundIn.ar(6,1);
	in8 = SoundIn.ar(7,1);

	// in6 = Impulse.kr(4,0.5);
	// in7 = Impulse.kr(4);
	// in8 = Impulse.kr(4/32);

	clock = Amplitude.kr(in7)-0.1;
	reset = Amplitude.kr(in8)-0.1;
	tempo = Timer.kr(clock);

	ks = in1*1;
	// ks = Decimator.ar(ks,44100*1,24,1);
	// ks = SwitchDelay.ar(ks,1,0,0.001,0.5,20,1);

	hh = WhiteNoise.ar(EnvGen.kr(Env.perc(0,tempo/32),Amplitude.kr(in6)-0.1));
	// hh = Decimator.ar(hh,44100*0.25,24,1);
	// hh = SwitchDelay.ar(hh,1,1,0.012,0.5,1,1);

	drums = (ks*0.5)+(hh*0.35);
	// drums = Decimator.ar(drums,44100*1,24,1);
	// drums = SwitchDelay.ar(drums,1,1,0.001,0.5,20,1);

/*	// Select.ar(
	freez = RecordBuf.ar(drums,~freez.bufnum,0,1,0,1,1,clock);*/

	// bass = in2*0.0;
	// in2 = Decimator.ar(in2,44100*1,24,1);
	// in2 = SwitchDelay.ar(in2,1,1,0.75,0.25,20,1);

	// in3 = Decimator.ar(in3,44100*1,24,1);
	// in3 = SwitchDelay.ar(in3,1,1,clock,0.25,20,1);

	out = (drums*1)+(in2*0.0)+(in3*0.5)+(in4*0.5);
	out = out * amp;
	aux1 = out;
	aux2 = (drums*0.25)+(in2*0.0)+(in3*0.5);
	Out.ar(0,out);
	Out.ar(2,aux1);
	Out.ar(4,aux2);
}).play;
);
)

(x.set(
	\amp,1,
);
)

(
Pdef(\seq,
	Pbind(
	\instrument,\main,
	\dur,[1],
	\amp,[1],
	)
).play;
)