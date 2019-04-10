(
b = NetAddr.new("127.0.0.1", 12345);
b.sendMsg(\sc,0,1,2,3)
);
)

(
SynthDef(\sendOsc,{
	arg port=12345,msg=0;
	var osc;
	osc = NetAddr.new("127.0.0.1",12345);
	osc.sendMsg(msg);
}).add;
)

(
Pdef(\osc,Pbind(
	\instrument,\sendOsc,
	\dur, Prand([0.25,0.5,1,2],inf),
	\msg, Prand([0,1,2,3],inf),
)).play;
)

b = Synth(\sendOsc,\trig,1);

(
{
	SendReply.kr(Impulse.kr(3),'/amp',[2,3,4,5]);
}.play(s);
)

(
b = NetAddr.new("127.0.0.1",12345);
o = OSCFunc({
	arg msg;
	b.sendMsg(\sc,msg[3],msg[4],msg[5],msg[6]);
	msg.postln;
}, '/amp');
)

(
~video = Pbind(
	\instrument, \osc,
	\dur, Prand([1],inf),
	\osc, Pfunc{
		var osc = NetAddr.new("127.0.0.1",12345);
		osc.sendMsg('/sc',0,1,2,3,4);
		// |ev| b.sendMsg(“/left”, ev[\left]);
		// b.sendMsg(“/right”,ev[\right]);
		// b.sendMsg(“/left_post1”,ev[\left_post1]);
		// b.sendMsg(“/left_post2”,ev[\left_post2]);
		// b.sendMsg(“/left_post3”,ev[\left_post3]);
		// b.sendMsg(“/left_post4”,ev[\left_post4]);
		// b.sendMsg(“/right_post1”,ev[\right_post1]);
		// b.sendMsg(“/right_post2”,ev[\right_post2]);
		// b.sendMsg(“/right_post3”,ev[\right_post3]);
		// b.sendMsg(“/right_post4”,ev[\right_post4]);
		// b.sendMsg(“/blend”,ev[\blend]);
});
)