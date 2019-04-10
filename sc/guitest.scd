s.reboot;

(
w.close;
w = Window("w1",Rect(
	0,
	0,
	Window.screenBounds.width/8,
	Window.screenBounds.height-25
)).front.alwaysOnTop_(true);
w.background_(Color(0,0,0,1));
~s1 = Slider(w,Rect(20,20,150,30));
~s1.background_(Color(0,0,0,0));
~s1.thumbSize_(20);
~s1.action_({
	arg obj;
	var cf;
	cf = obj.value.linexp(0,1,100,4000).postln;
	x.set(\freq,cf);
});
)

(
x.free;
x = Synth.new(\simplebpf,[\freq,~s1.value.linexp(0,1,100,4000)]);
)

(
SynthDef.new(\simplebpf,{
	arg freq=440;
	var sig;
	sig = PinkNoise.ar(1!2);
	sig = BPF.ar(sig,freq.lag(0.5),0.2);
	Out.ar(0,sig);
}).add;
)

LevelIndicator

Stethoscope

a.value = 0.5;
a.warning = 0.6; a.critical = 0.9;
a.value = 0.7;
a.value = 0.9;

s.boot
{[SinOsc.ar.scope,WhiteNoise.ar(0.5).scope]*0.1}.scope(2);
Stethoscope.ugenScopes; // returns the ugen scopes

