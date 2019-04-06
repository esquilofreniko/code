(
s.freeAll;
s.quit;
s.options.device = "Focusrite USB ASIO";
s.options.numOutputBusChannels = 6;
s.options.numInputBusChannels = 8;
s.boot;
s.plotTree;
~drumsBus.free;
~drumsBus= Bus.audio(s,2);
~bassBus.free;
~bassBus = Bus.audio(s,2);
~ambientBus.free;
~ambientBus = Bus.audio(s,2);
~voxBus.free;
~voxBus = Bus.audio(s,2);
~reverbBus.free;
~reverbBus = Bus.audio(s,2);
~clockBus.free;
~clockBus = Bus.control(s,1);
~resetBus.free;
~resetBus = Bus.control(s,1);
~trigBus.free;
~trigBus = Bus.control(s,1);
)

(
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
SynthDef(\mix5,{
	arg out,in1,in2,in3,in4,in5,amp1=0.5,amp2=0.5,amp3=0.5,amp4=0.5,amp5=0.5;
	var sig;
	in1 = In.ar(in1,2)*amp1;
	in2 = In.ar(in2,2)*amp2;
	in3 = In.ar(in3,2)*amp3;
	in4 = In.ar(in4,2)*amp4;
	in5 = In.ar(in5,2)*amp4;
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
	var amp,sig,buffer,sigFreez,trig,rand,freez,time=1,delay;
	buffer = Buffer.alloc(s,s.sampleRate*4,2);
	sig = In.ar(in,2);
	sig = Select.ar(on,[
		sig;,
		{
			trig = In.kr(clock);
			time = Timer.kr(trig);
			rand = Latch.kr((WhiteNoise.kr(1)),trig);
			freez = Amplitude.kr(rand) < chance;
			RecordBuf.ar(sig,buffer,0,1,0,1-freez,1,trig);
			sig = Select.ar(freez,[sig,LoopBuf.ar(2,buffer.bufnum,speed,1,0,0,time*s.sampleRate)*0.5]);
			delay = SwitchDelay.ar(sig*freez,0,1,time*division,fb,1);
			sig = sig + delay;
	}]);
	ReplaceOut.ar(out,sig);
}).add;
)

(
~g0.free;~g0=Group.new(s,\addToHead);
~clock = Synth.tail(~g0,\controlInput,[\in,7,\out,~clockBus]);
~reset = Synth.tail(~g0,\controlInput,[\in,6,\out,~resetBus]);
~trig = Synth.tail(~g0,\controlInput,[\in,5,\out,~trigBus]);

~g1.free;~g1 = Group.after(~g0);
~drums = Synth.tail(~g1,\input,[\in,0,\out,~drumsBus]);
~hihat = Synth.tail(~g1,\fmhat,[\hhctrl,~trigBus,\out,~drumsBus,\dc,0.01,\amp,0.25]);
~bitCrush = Synth.tail(~g1,\bitCrush,[\in,~drumsBus,\out,~drumsBus,\rate,1,\bit,24,\amp,1]);
~uDelay = Synth.tail(~g1,\uDelay,[\in,~drumsBus,\out,~drumsBus,\dry,1.0,\wet,1.0,\delay,0.016,\fb,0.5]);
~freez = Synth.tail(~g1,\freez,[\in,~drumsBus,\out,~drumsBus,\clock,~clockBus,\speed,4,\division,3,\fb,0.5,\chance,0.05]);

~g2.free;~g2 = Group.after(~g1);
~bass = Synth.tail(~g2,\input,[\in,1,\out,~bassBus]);

~g3.free;~g3 = Group.after(~g2);
~ambient = Synth.tail(~g3,\input,[\in,2,\out,~ambientBus]);

~g4.free;~g4 = Group.after(~g3);
~vox = Synth.tail(~g4,\input,[\in,3,\out,~voxBus]);

~g5.free;~g5 = Group.after(~g4);
~reverbIn = Synth.tail(~g5,\input,[\in,4,\out,~reverbBus]);

~g6.free;~g6 = Group.after(~g5);
~aux1 = Synth.tail(~g6,\mix5,[\out,2,\in1,~drumsBus,\in2,~bassBus,\in3,~ambientBus,\in4,~voxBus,\in5,~reverbBus,\amp1,0.5,\amp2,0.5,\amp3,0.5,\amp4,0.5,\amp5,0.5]);
~aux2 = Synth.tail(~g6,\mix5,[\out,4,\in1,~drumsBus,\in2,~bassBus,\in3,~ambientBus,\in4,~voxBus,\in5,~reverbBus,\amp1,0.5,\amp2,0.5,\amp3,0.5,\amp4,0.5,\amp5,0.0]);
~out1 = Synth.tail(~g6,\mix5,[\out,0,\in1,~drumsBus,\in2,~bassBus,\in3,~ambientBus,\in4,~voxBus,\in5,~reverbBus,\amp1,0.5,\amp2,0.5,\amp3,0.5,\amp4,0.5,\amp5,0.5]);
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