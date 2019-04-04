(
s.freeAll;
s.quit;
s.options.device = "Focusrite USB ASIO";
s.options.numOutputBusChannels = 6;
s.options.numInputBusChannels = 8;
s.boot;
s.plotTree;
~b1.free;
~b1= Bus.audio(s,2);
~b2.free;
~b2 = Bus.audio(s,2);
~b3.free;
~b3 = Bus.audio(s,2);
~b4.free;
~b4 = Bus.audio(s,2);
~b5.free;
~b5 = Bus.audio(s,2);
~c1.free;
~c1 = Bus.control(s,1);
~c2.free;
~c2 = Bus.control(s,1);
~c3.free;
~c3 = Bus.control(s,1);
~c4.free;
~c4 = Bus.control(s,1);
)

(
~tempo = 1;
~samp1.free;
~samp1 = Buffer.read(s,"d:/music/samples/amen/0.wav");
~freezbuf1 = Buffer.alloc(s,s.sampleRate*4,2);

SynthDef(\clock,{
	arg out,freq=1;
	var sig;
	sig = Impulse.kr(freq);
	Out.kr(out,sig);
}).add;

SynthDef(\controlInput,{
	arg in, out;
	var sig;
	sig = Amplitude.kr(SoundIn.ar(in))-0.1;
	Out.kr(out,sig);
}).add;

SynthDef(\input,{
	arg in, out, amp=1;
	var sig;
	sig = SoundIn.ar(in)*amp;
	Out.ar(out,sig!2);
}).add;

SynthDef(\output,{
	arg in,out,amp=1;
	var sig;
	sig = In.ar(in,2);
	sig = sig*amp;
	Out.ar(out,sig);
}).add;

SynthDef(\mix2,{
	arg out,in1,in2,amp1,amp2;
	var sig;
	in1 = In.ar(in1,2)*amp1;
	in2 = In.ar(in2,2)*amp2;
	sig = in1 + in2;
	Out.ar(out,sig);
}).add;

SynthDef(\mix4,{
	arg out,in1,in2,in3,in4,amp1=0.5,amp2=0.5,amp3=0.5,amp4=0.5;
	var sig;
	in1 = In.ar(in1,2)*amp1;
	in2 = In.ar(in2,2)*amp2;
	in3 = In.ar(in3,2)*amp3;
	in4 = In.ar(in4,2)*amp4;
	sig = in1+in2+in3+in4;
	Out.ar(out,sig);
}).add;

SynthDef(\play, {
	arg out,sample,rate = 0.75;
	var sig;
	sig = PlayBuf.ar(2,sample,rate,\t_tr.kr(1,0),0,1)*1;
	Out.ar(out,sig);
}).add;

SynthDef(\fmhat,{
	arg hhctrl,out,dc=0.01,amp=0.25;
	var sig,env,trig;
	trig = In.kr(hhctrl);
	env = EnvGen.kr(Env.perc(0,dc),trig);
	sig = WhiteNoise.ar(env)*amp;
	Out.ar(out,sig!2);
}).add;

SynthDef(\bitCrush,{
	arg in,out,rate=1,bit=24,amp=1,on=1;
	var sig;
	sig = In.ar(in,2);
	sig = Select.ar(on,[
		sig;,
		sig = Decimator.ar(sig,44100*rate,bit)*amp;
	]);
	ReplaceOut.ar(out,sig);
}).add;

SynthDef(\uDelay,{
	arg in,out,dry=1,wet=1,delay=0.001,fb=0.5,on=1;
	var sig;
	sig = In.ar(in,2);
	sig = Select.ar(on,[
		sig;,
		sig = SwitchDelay.ar(sig,dry,wet,delay,fb,10);
	]);
	ReplaceOut.ar(out,sig);
}).add;

SynthDef(\freez,{
	arg in,out,clock,speed=4,division=3,fb=0.5,chance=0,on=1;
	var amp,sig,sigFreez,trig,rand,freez,time=1,delay;
	sig = In.ar(in,2);
	sig = Select.ar(on,[
		sig;,
		{
			trig = In.kr(clock);
			time = Timer.kr(trig);
			rand = Latch.kr((WhiteNoise.kr(1)),trig);
			freez = Amplitude.kr(rand) < chance;
			RecordBuf.ar(sig,~freezbuf1,0,1,0,1-freez,1,trig);
			sig = Select.ar(freez,[sig,LoopBuf.ar(2,~freezbuf1.bufnum,speed,1,0,0,time*s.sampleRate)*0.5]);
			delay = SwitchDelay.ar(sig*freez,0,1,time*division,fb,1);
			sig = sig + delay;
	}]);
	ReplaceOut.ar(out,sig);
}).add;
)

(
//Input
~g0.free;~g0=Group.new(s,\addToHead);
~clock = Synth.tail(~g0,\controlInput,[\in,7,\out,~c1]);
~reset = Synth.tail(~g0,\controlInput,[\in,6,\out,~c2]);
~hhctrl = Synth.tail(~g0,\controlInput,[\in,5,\out,~c3]);
//Drums
~g1.free;~g1 = Group.after(~g0);
~ks = Synth.tail(~g1,\input,[\in,0,\out,~b1]);
~hh = Synth.tail(~g1,\fmhat,[\hhctrl,~c3,\out,~b1,\dc,0.01,\amp,0.25]);
~bitCrush = Synth.tail(~g1,\bitCrush,[\in,~b1,\out,~b1,\rate,1,\bit,24,\amp,1]);
~uDelay = Synth.tail(~g1,\uDelay,[\in,~b1,\out,~b1,\dry,1.0,\wet,1.0,\delay,0.016,\fb,0.5]);
~freez = Synth.tail(~g1,\freez,[\in,~b1,\out,~b1,\clock,~c1,\speed,4,\division,3,\fb,0.5,\chance,0.05]);
//Bass
~g2.free;~g2 = Group.after(~g1);
~bass = Synth.tail(~g2,\input,[\in,1,\out,~b2]);
//Ambient
~g3.free;~g3 = Group.after(~g2);
~ambient = Synth.tail(~g3,\input,[\in,2,\out,~b3]);
//Reverb
~g4.free;~g4 = Group.after(~g3);
~reverb = Synth.tail(~g4,\input,[\in,3,\out,~b4]);
//Output
~g5.free;~g5 = Group.after(~g4);
~aux1 = Synth.tail(~g5,\mix4,[\out,2,\in1,~b1,\in2,~b2,\in3,~b3,\in4,~b4,\amp1,0.5,\amp2,0.5,\amp3,0.5,\amp4,0.5]);
~aux2 = Synth.tail(~g5,\mix4,[\out,4,\in1,~b1,\in2,~b2,\in3,~b3,\in4,~b4,\amp1,0.5,\amp2,0.5,\amp3,0.5,\amp4,0.0]);
~out1 = Synth.tail(~g5,\mix4,[\out,0,\in1,~b1,\in2,~b2,\in3,~b3,\in4,~b4,\amp1,0.5,\amp2,0.5,\amp3,0.5,\amp4,0.5]);
)

s.plotTree

// ~hh.set(\dc,0.01,\amp,0.25);
// (
// ~bitCrush.set(\on,0);
// ~bitCrush.set(\on,1,\rate,1,\bit,24,\amp,1);
// ~uDelay.set(\on,0);
// ~uDelay.set(\on,1,\dry,1,\wet,1,\delay,0.001,\fb,0.5);
// ~freez.set(\on,0);
// ~freez.set(\on,1,\speed,4,\division,3,\fb,0.5,\chance,0.05);
// ~aux2.set(\amp1,0.5,\amp2,0.5,\amp3,0.5,\amp4,0);
// ~output.set(\amp1,0.5,\amp2,0.5,\amp3,0.5,\amp4,0.5);
// )