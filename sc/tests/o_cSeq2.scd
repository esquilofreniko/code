//Connect
(
//In
(
x = 0;
MIDIClient.init;
MIDIIn.connectAll;
MIDIdef.noteOn('noteOnTest', {
	arg vel, note, chan, src;
	[vel, note, chan, src].postln;
	if(chan == 1,{
		p.next(Event.new);
		n.next(Event.new);
		e['chan'].postln;
		m.noteOn(e['chan'],60,100);
		m.noteOff(e['chan'],60);
		m.noteOff(4,x);
		x = (~en['midinote'] + ~en['oct']);
		x.postln;
		m.noteOn(4,x,100);
	});

	if(chan == 2,{
		p.reset;
		n.reset;
	});

	if(chan == 3,{});

	if(chan == 4,{});

});
);
//Out
(
MIDIClient.destinations;
m = MIDIOut.new(0);
m.connect(1);
);
)

// //Test
// (
// m.noteOn(0,60,100);
// m.noteOff(0,60);
// )

//Sequence
(
(
p.free;
p = Pbind(
'type', 'midi',
'midicmd', 'noteOn',
'midiout', m,
'chan', Pseq([
Pwrand([0,1,2,3],[1.0,0.0,0.0,0.0].normalizeSum),//1
Pwrand([0,1,2,3],[0.1,0.1,0.2,1.0].normalizeSum),//2
Pwrand([0,1,2,3],[0.1,0.1,0.2,1.0].normalizeSum),//3
Pwrand([0,1,2,3],[0.1,0.1,0.2,1.0].normalizeSum),//4
Pwrand([0,1,2,3],[0.1,0.1,0.2,1.0].normalizeSum),//5
Pwrand([0,1,2,3],[0.1,0.1,0.2,1.0].normalizeSum),//6
Pwrand([0,1,2,3],[0.1,0.1,0.2,1.0].normalizeSum),//7
Pwrand([0,1,2,3],[0.1,0.1,0.2,1.0].normalizeSum),//8
Pwrand([0,1,2,3],[0.0,1.0,0.0,0.0].normalizeSum),//9
Pwrand([0,1,2,3],[0.1,0.1,0.2,1.0].normalizeSum),//10
Pwrand([0,1,2,3],[0.1,0.1,0.2,1.0].normalizeSum),//11
Pwrand([0,1,2,3],[0.1,0.1,0.2,1.0].normalizeSum),//12
Pwrand([0,1,2,3],[0.1,0.1,0.2,1.0].normalizeSum),//13
Pwrand([0,1,2,3],[0.1,0.1,0.2,1.0].normalizeSum),//14
Pwrand([0,1,2,3],[0.1,0.1,0.2,1.0].normalizeSum),//15
Pwrand([0,1,2,3],[0.1,0.1,0.2,1.0].normalizeSum),//16
	    ],inf),
'midinote', 60,
'amp', 1,
'sustain', 0.01,
).asStream.collect({ arg event;
		e = event;
	});
);
)
