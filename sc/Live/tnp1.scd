( //Boot
s.freeAll;
s.quit;
s.options.device = "Focusrite USB ASIO";
s.options.numOutputBusChannels = 6;
s.options.numInputBusChannels = 8;
s.options.memSize = 65536;
s.boot;
)

( //SynthDefs
SynthDef(\clock,{
	arg out,freq=1;
	var sig;
	sig = Impulse.kr(freq);
	Out.kr(out,sig);
}).store;
SynthDef(\controlInput,{
	arg in, out;
	var sig;
	sig = Amplitude.kr(SoundIn.ar(in))-0.1;
	Out.kr(out,sig);
}).store;
SynthDef(\busInput,{
	arg in, out, amp=1,on=1,level=0.5;
	var sig;
	sig = Select.ar(on,[
		SinOsc.ar(0),
		In.ar(in,1)*amp
	]);
	level = Amplitude.kr(sig);
	Out.ar(out,sig);
}).store;
SynthDef(\readAmp,{
	arg in,out;
	var sig;
	sig = In.ar(in);
	Out.kr(out,Amplitude.kr(sig));
}).store;
SynthDef(\input,{
	arg in, out, amp=1,on=1,level=1;
	var sig;
	sig = Select.ar(on,[
		SinOsc.ar(0),
		SoundIn.ar(in)*amp
	]);
	level = Amplitude.kr(sig);
	Out.ar(out,sig);
}).store;
SynthDef(\output,{
	arg in,out,amp=1;
	var sig;
	sig = In.ar(in,2);
	sig = sig*amp;
	Out.ar(out,sig);
}).store;
SynthDef(\mix2,{
	arg out,in1,in2,amp1,amp2;
	var sig;
	in1 = In.ar(in1,2)*amp1;
	in2 = In.ar(in2,2)*amp2;
	sig = in1 + in2;
	Out.ar(out,sig);
}).store;
SynthDef(\mix4,{
	arg out,in1,in2,in3,in4,amp1=0.5,amp2=0.5,amp3=0.5,amp4=0.5;
	var sig;
	in1 = In.ar(in1,2)*amp1;
	in2 = In.ar(in2,2)*amp2;
	in3 = In.ar(in3,2)*amp3;
	in4 = In.ar(in4,2)*amp4;
	sig = in1+in2+in3+in4;
	Out.ar(out,sig);
}).store;
SynthDef(\mix5,{
	arg out,in1,in2,in3,in4,in5,amp1=0.5,amp2=0.5,amp3=0.5,amp4=0.5,amp5=0.5;
	var sig;
	in1 = In.ar(in1,2)*amp1;
	in2 = In.ar(in2,2)*amp2;
	in3 = In.ar(in3,2)*amp3;
	in4 = In.ar(in4,2)*amp4;
	in5 = In.ar(in5,2)*amp5;
	sig = in1+in2+in3+in4+in5;
	Out.ar(out,sig);
}).store;
SynthDef(\mix6,{
	arg out,in1,in2,in3,in4,in5,in6,amp1=0.5,amp2=0.5,amp3=0.5,amp4=0.5,amp5=0.5,amp6=0.5;
	var sig;
	in1 = In.ar(in1,2)*amp1;
	in2 = In.ar(in2,2)*amp2;
	in3 = In.ar(in3,2)*amp3;
	in4 = In.ar(in4,2)*amp4;
	in5 = In.ar(in5,2)*amp5;
	in6 = In.ar(in6,2)*amp6;
	sig = in1+in2+in3+in4+in5+in6;
	Out.ar(out,sig);
}).store;
SynthDef(\play, {
	arg out,sample,rate = 0.75;
	var sig;
	sig = PlayBuf.ar(2,sample,rate,\t_tr.kr(1,0),0,1)*1;
	Out.ar(out,sig);
}).store;
SynthDef(\fmhat,{
	arg hhctrl,out,decay=0.01,amp=0.25;
	var sig,env,trig;
	trig = In.kr(hhctrl);
	env = EnvGen.kr(Env.perc(0,decay),trig);
	sig = WhiteNoise.ar(env)*amp;
	Out.ar(out,sig!2);
}).store;
SynthDef(\bitCrush,{
	arg in,out,rate=1,bit=24,amp=1,on=1;
	var sig;
	sig = In.ar(in,2);
	sig = Select.ar(on,[
		sig;,
		sig = Decimator.ar(sig,s.sampleRate*rate,bit)*amp;
	]);
	ReplaceOut.ar(out,sig);
}).store;
SynthDef(\uDelay,{
	arg in,out,dry=1,wet=1,delay=0.001,fb=0.5,on=1;
	var sig;
	sig = In.ar(in,2);
	sig = Select.ar(on,[
		sig;,
		sig = SwitchDelay.ar(sig,dry,wet,delay,fb,1);
	]);
	ReplaceOut.ar(out,sig);
}).store;
SynthDef(\clockDelay,{
	arg in,out,clock,dry=1,wet=1,delay=3,fb=0.5,on=1;
	var trig,time,sig;
	sig = In.ar(in,2);
	sig = Select.ar(on,[
		sig,
		{
			trig = In.kr(clock);
			time = Timer.kr(trig);
			sig = SwitchDelay.ar(sig,dry,wet,time*delay,fb,1);
		}
	]);
	ReplaceOut.ar(out,sig);
}).store;
SynthDef(\freez,{
	arg in,out,clock,speed=3,division=3,fb=0.25,chance=0,amp=1,on=1;
	var sig,buffer,env,env2,loop,sigFreez,trig,rand,freez=0,time=1,delay;
	buffer = Buffer.alloc(s,s.sampleRate*4,2);
	sig = In.ar(in,2);
	sig = Select.ar(on,[
		sig;,
		{
			trig = In.kr(clock);
			time = Timer.kr(trig);
			rand = Latch.kr((WhiteNoise.kr(1)),trig);
			freez = Amplitude.kr(rand) < chance;
			Select.ar(freez,[RecordBuf.ar(sig,buffer,0,1,0,1-freez,1,trig);,{
				loop = LoopBuf.ar(2,buffer.bufnum,speed,1,1000,0,time*s.sampleRate,1)*freez;
				delay = SwitchDelay.ar(loop,1,1,time*division,fb,1);
			}]);
			sig = (sig*(1-freez)) + delay;
	}]);
	ReplaceOut.ar(out,sig);
}).store;
)

(//Routing
~drumsBus.free;~drumsBus= Bus.audio(s,2);
~bassBus.free;~bassBus = Bus.audio(s,2);
~ambientBus.free;~ambientBus = Bus.audio(s,2);
~voxBus.free;~voxBus = Bus.audio(s,2);
~reverbBus.free;~reverbBus = Bus.audio(s,2);
~scIn.free;~scIn = Bus.audio(s,2);
~scBus.free;~scBus = Bus.audio(s,2);
~clockBus.free;~clockBus = Bus.control(s,1);
~resetBus.free;~resetBus = Bus.control(s,1);
~trigBus.free;~trigBus = Bus.control(s,1);
~drumsAmp.free;~drumsAmp= Bus.control(s,1);
~bassAmp.free;~bassAmp= Bus.control(s,1);
~ambientAmp.free;~ambientAmp= Bus.control(s,1);
~voxAmp.free;~voxAmp= Bus.control(s,1);
~reverbAmp.free;~reverbAmp = Bus.control(s,1);
~scAmp.free;~scAmp= Bus.control(s,1);
//Control
~g0.free;~g0=Group.new(s,\addToHead);
~reset = Synth.tail(~g0,\controlInput,[\in,6,\out,~resetBus]);
~clock = Synth.tail(~g0,\controlInput,[\in,7,\out,~clockBus]);
~trig = Synth.tail(~g0,\controlInput,[\in,5,\out,~trigBus]);
//Drums
~g1.free;~g1 = Group.after(~g0);
~drums = Synth.tail(~g1,\input,[\in,0,\out,~drumsBus]);
Synth.tail(~g1,\readAmp,[\in,~drumsBus,\out,~drumsAmp]);
// ~drumsBitCrush = Synth.tail(~g1,\bitCrush,[\in,~drumsBus,\out,~drumsBus]);
// ~drumsBitCrush.set(\rate,1,\bit,24,\amp,1,\on,1);
~uDelay = Synth.tail(~g1,\uDelay,[\in,~drumsBus,\out,~drumsBus]);
~uDelay.set(\dry,1.0,\wet,1.0,\delay,0.024,\fb,0.5,\on,1);
~freez = Synth.tail(~g1,\freez,[\in,~drumsBus,\out,~drumsBus,\clock,~clockBus]);
~freez.set(\speed,4,\division,3,\fb,0.25,\amp,1,\chance,0.1,\on,1);
//Bass
~g2.free;~g2 = Group.after(~g1);
~bass = Synth.tail(~g2,\input,[\in,1,\out,~bassBus]);
Synth.tail(~g2,\readAmp,[\in,~bassBus,\out,~bassAmp]);
// ~bassBitCrush = Synth.tail(~g2,\bitCrush,[\in,~bassBus,\out,~bassBus]);
// ~bassBitCrush.set(\rate,0.1,\bit,24,\amp,1,\on,1);
// ~bassDelay = Synth.tail(~g2,\clockDelay,[\in,~bassBus,\out,~bassBus,\trig,~clockBus]);
// ~bassDelay.set(\dry,1.0,\wet,1.0,\delay,0.001,\fb,0.5,\on,1);
//Ambient
~g3.free;~g3 = Group.after(~g2);
~ambient = Synth.tail(~g3,\input,[\in,2,\out,~ambientBus]);
Synth.tail(~g3,\readAmp,[\in,~ambientBus,\out,~ambientAmp]);
// ~ambientDelay = Synth.tail(~g3,\clockDelay,[\in,~ambientBus,\out,~ambientBus,\trig,~clockBus]);
// ~ambientDelay.set(\dry,1.0,\wet,1.0,\delay,0.1,\fb,0.5,\on,0);
//Vox
~g4.free;~g4 = Group.after(~g3);
~vox = Synth.tail(~g4,\input,[\in,3,\out,~voxBus]);
Synth.tail(~g4,\readAmp,[\in,~voxBus,\out,~voxAmp]);
// ~uDelay = Synth.tail(~g4,\uDelay,[\in,~voxBus,\out,~voxBus]);
// ~uDelay.set(\dry,1.0,\wet,1.0,\delay,0.024,\fb,0.5,\on,0);
//Reverb
~g5.free;~g5 = Group.after(~g4);
~reverb = Synth.tail(~g5,\input,[\in,4,\out,~reverbBus]);
Synth.tail(~g5,\readAmp,[\in,~reverbBus,\out,~reverbAmp]);
//Supercollider
~g6.free;~g6 = Group.after(~g5);
~sc = Synth.tail(~g6,\busInput,[\in,~scIn,\out,~scBus]);
Synth.tail(~g6,\readAmp,[\in,~scBus,\out,~scAmp]);
// Outputs
~g7.free;~g7 = Group.after(~g6);
~aux1 = Synth.tail(~g7,\mix6,[\out,2,\in1,~drumsBus,\in2,~bassBus,\in3,~ambientBus,\in4,~voxBus,\in5,~reverbBus,\in6,~scBus]);
~aux1.set(\amp1,0.0,\amp2,0.0,\amp3,0.5,\amp4,0.5,\amp5,0.0,\amp6,0.00);
~aux2 = Synth.tail(~g7,\mix6,[\out,4,\in1,~drumsBus,\in2,~bassBus,\in3,~ambientBus,\in4,~voxBus,\in5,~reverbBus,\in6,~scBus]);
~aux2.set(\amp1,0.5,\amp2,0.25,\amp3,0.5,\amp4,0.0,\amp5,0.0,\amp6,0.00);
~out1 = Synth.tail(~g7,\mix6,[\out,0,\in1,~drumsBus,\in2,~bassBus,\in3,~ambientBus,\in4,~voxBus,\in5,~reverbBus,\in6,~scBus]);
~out1.set(\amp1,0.75,\amp2,1,\amp3,1,\amp4,1,\amp5,1,\amp6,1);
)

(//GUI
Window.closeAll;
~width = Window.screenBounds.width;
~height = Window.screenBounds.height;
~update.stop;
~update.free;
	m = ServerMeter(s,8,6).window.bounds_(Rect(0,0,~width/6,~height/5)).alwaysOnTop_(true).background_(Color(0));
s.scope.window.bounds_(Rect(0,((~height/5)*1),(~width/6),(~height/5))).front.alwaysOnTop_(true);
	w = Window("gui",Rect(0,(~height/5)*2-1,~width/6,(~height/5)*3)).front.alwaysOnTop_(true).background_(Color(0));
	//Mute
	~drumsMute.free;
	~drumsMute = Button(w,Rect((w.bounds.width/6)*0,0,w.bounds.width/6,w.bounds.height/12)).states_([
		["drums\n0", Color.white, Color.black],
		["drums\n1", Color.black, Color.white],
	]).action_({arg val;
		~drums.set(\on,val.value);
	});
	~bassMute.free;
	~bassMute = Button(w,Rect((w.bounds.width/6)*1,0,w.bounds.width/6,w.bounds.height/12)).states_([
		["bass\n0", Color.white, Color.black],
		["bass\n1", Color.black, Color.white],
	]).action_({arg val;
		~bass.set(\on,val.value);
	});
	~ambientMute.free;
	~ambientMute = Button(w,Rect((w.bounds.width/6)*2,0,w.bounds.width/6,w.bounds.height/12)).states_([
		["ambient\n0", Color.white, Color.black],
		["ambient\n1", Color.black, Color.white],
	]).action_({arg val;
		~ambient.set(\on,val.value);
	});
	~voxMute.free;
	~voxMute = Button(w,Rect((w.bounds.width/6)*3,0,w.bounds.width/6,w.bounds.height/12)).states_([
		["vox\n0", Color.white, Color.black],
		["vox\n1", Color.black, Color.white],
	]).action_({arg val;
		~vox.set(\on,val.value);
	});
	~reverbMute.free;
	~reverbMute = Button(w,Rect((w.bounds.width/6)*4,0,w.bounds.width/6,w.bounds.height/12)).states_([
		["reverb\n0", Color.white, Color.black],
		["reverb\n1", Color.black, Color.white],
	]).value_(1).action_({arg val;
		~reverb.set(\on,val.value);
	});
	~scMute.free;
	~scMute = Button(w,Rect((w.bounds.width/6)*5,0,w.bounds.width/6,w.bounds.height/12)).states_([
		["\sc\n0", Color.white, Color.black],
		["\sc\n1", Color.black, Color.white],
	]).action_({arg val;
		~sc.set(\on,val.value);
	});
	//Volume
	~drumsDb.free;
	~drumsDb= Slider(w,Rect((w.bounds.width/6)*0.5,(w.bounds.height/12)*1,(w.bounds.width/12),(w.bounds.height/6))).background_(Color.black).action_({
		arg val;
		~drums.set(\amp,val.value);
	});
	~bassDb.free;
	~bassDb= Slider(w,Rect((w.bounds.width/6)*1.5,(w.bounds.height/12)*1,(w.bounds.width/12),(w.bounds.height/6))).background_(Color.black).action_({
		arg val;
		~bass.set(\amp,val.value);
	});
	~ambientDb.free;
	~ambientDb= Slider(w,Rect((w.bounds.width/6)*2.5,(w.bounds.height/12)*1,(w.bounds.width/12),(w.bounds.height/6))).background_(Color.black).action_({
		arg val;
		~ambient.set(\amp,val.value);
	});
	~voxDb.free;
	~voxDb= Slider(w,Rect((w.bounds.width/6)*3.5,(w.bounds.height/12)*1,(w.bounds.width/12),(w.bounds.height/6))).background_(Color.black).action_({
		arg val;
		~vox.set(\amp,val.value);
	});
	~reverbDb.free;
	~reverbDb= Slider(w,Rect((w.bounds.width/6)*4.5,(w.bounds.height/12)*1,(w.bounds.width/12),(w.bounds.height/6))).background_(Color.black).action_({
		arg val;
		~reverb.set(\amp,val.value);
	});
	~scDb.free;
	~scDb= Slider(w,Rect((w.bounds.width/6)*5.5,(w.bounds.height/12)*1,(w.bounds.width/12),(w.bounds.height/6))).background_(Color.black).action_({
		arg val;
		~sc.set(\amp,val.value);
	});
	//Meter
	~drumsMeter.free;
	~drumsMeter= LevelIndicator(w,Rect((w.bounds.width/6)*0,(w.bounds.height/12)*1,(w.bounds.width/12),(w.bounds.height/6))).background_(Color.gray).drawsPeak_(true);
	~bassMeter.free;
	~bassMeter= LevelIndicator(w,Rect((w.bounds.width/6)*1,(w.bounds.height/12)*1,(w.bounds.width/12),(w.bounds.height/6))).background_(Color.gray).drawsPeak_(true);
	~ambientMeter.free;
	~ambientMeter= LevelIndicator(w,Rect((w.bounds.width/6)*2,(w.bounds.height/12)*1,(w.bounds.width/12),(w.bounds.height/6))).background_(Color.gray).drawsPeak_(true);
	~voxMeter.free;
	~voxMeter= LevelIndicator(w,Rect((w.bounds.width/6)*3,(w.bounds.height/12)*1,(w.bounds.width/12),(w.bounds.height/6))).background_(Color.gray).drawsPeak_(true);
	~reverbMeter.free;
	~reverbMeter= LevelIndicator(w,Rect((w.bounds.width/6)*4,(w.bounds.height/12)*1,(w.bounds.width/12),(w.bounds.height/6))).background_(Color.gray).drawsPeak_(true);
	~scMeter.free;
	~scMeter= LevelIndicator(w,Rect((w.bounds.width/6)*5,(w.bounds.height/12)*1,(w.bounds.width/12),(w.bounds.height/6))).background_(Color.gray).drawsPeak_(true);
	//BitCrushMute
	~drumsBitCrushMute.free;
	~drumsBitCrushMute = Button(w,Rect((w.bounds.width/6)*0,(w.bounds.height/12)*3,w.bounds.width/6,w.bounds.height/12)).states_([
		["BitCrush\n0", Color.white, Color.black],
		["BitCrush\n1", Color.black, Color.white],
	]).action_({arg val;
		~drumsBitCrush.set(\on,val.value);
	});
	~bassBitCrushMute.free;
	~bassBitCrushMute = Button(w,Rect((w.bounds.width/6)*1,(w.bounds.height/12)*3,w.bounds.width/6,w.bounds.height/12)).states_([
		["BitCrush\n0", Color.white, Color.black],
		["BitCrush\n1", Color.black, Color.white],
	]).action_({arg val;
		~bassBitCrush.set(\on,val.value);
	});
	~ambientBitCrushMute.free;
	~ambientBitCrushMute = Button(w,Rect((w.bounds.width/6)*2,(w.bounds.height/12)*3,w.bounds.width/6,w.bounds.height/12)).states_([
		["BitCrush\n0", Color.white, Color.black],
		["BitCrush\n1", Color.black, Color.white],
	]).action_({arg val;
		~ambientBitCrush.set(\on,val.value);
	});
	~voxBitCrushMute.free;
	~voxBitCrushMute = Button(w,Rect((w.bounds.width/6)*3,(w.bounds.height/12)*3,w.bounds.width/6,w.bounds.height/12)).states_([
		["BitCrush\n0", Color.white, Color.black],
		["BitCrush\n1", Color.black, Color.white],
	]).action_({arg val;
		~voxBitCrush.set(\on,val.value);
	});
	~reverbBitCrushMute.free;
	~reverbBitCrushMute = Button(w,Rect((w.bounds.width/6)*4,(w.bounds.height/12)*3,w.bounds.width/6,w.bounds.height/12)).states_([
		["BitCrush\n0", Color.white, Color.black],
		["BitCrush\n1", Color.black, Color.white],
	]).action_({arg val;
		~reverbBitCrush.set(\on,val.value);
	});
	~scBitCrushMute.free;
	~scBitCrushMute = Button(w,Rect((w.bounds.width/6)*5,(w.bounds.height/12)*3,w.bounds.width/6,w.bounds.height/12)).states_([
		["BitCrush\n0", Color.white, Color.black],
		["BitCrush\n1", Color.black, Color.white],
	]).action_({arg val;
		~scBitCrush.set(\on,val.value);
	});
	//BitCrushRate

	//Update
	~update = fork{loop{
		//Mute
		~drums.get(\on, { arg value; {~drumsMute.value_(value)}.defer();});
		~bass.get(\on, { arg value; {~bassMute.value_(value)}.defer();});
		~ambient.get(\on, { arg value; {~ambientMute.value_(value)}.defer();});
		~vox.get(\on, { arg value; {~voxMute.value_(value)}.defer();});
		~reverb.get(\on, { arg value; {~reverbMute.value_(value)}.defer();});
		~sc.get(\on, { arg value; {~scMute.value_(value)}.defer();});
		//Volume
		~drums.get(\amp, { arg value; {~drumsDb.value_(value)}.defer();});
		~bass.get(\amp, { arg value; {~bassDb.value_(value)}.defer();});
		~ambient.get(\amp, { arg value; {~ambientDb.value_(value)}.defer();});
		~vox.get(\amp, { arg value; {~voxDb.value_(value)}.defer();});
		~reverb.get(\amp, { arg value; {~reverbDb.value_(value)}.defer();});
		~sc.get(\amp, { arg value; {~scDb.value_(value)}.defer();});
		//Meter
		~drumsAmp.get({arg value;{~drumsMeter.value_(value);~drumsMeter.peakLevel_(value);}.defer();});
		~bassAmp.get({arg value;{~bassMeter.value_(value);~bassMeter.peakLevel_(value);}.defer();});
		~ambientAmp.get({arg value;{~ambientMeter.value_(value);~ambientMeter.peakLevel_(value);}.defer();});
		~voxAmp.get({arg value;{~voxMeter.value_(value);~voxMeter.peakLevel_(value);}.defer();});
		~reverbAmp.get({arg value;{~reverbMeter.value_(value);~reverbMeter.peakLevel_(value);}.defer();});
		~scAmp.get({arg value;{~scMeter.value_(value);~scMeter.peakLevel_(value);}.defer();});
		//BitCrush

		//Wait
		0.05.wait;
	}}.play;
)
