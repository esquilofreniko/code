//Connect
(
//In
(
MIDIClient.init;
MIDIIn.connectAll;
MIDIdef.noteOn('noteOnTest', {
	arg vel, note, chan, src;
	[vel, note, chan, src].postln;
});
);
//Out
(
MIDIClient.destinations;
m = MIDIOut.new(0);
c = MIDIOut.new(1);
m.connect(1);
c.connect(1);
);
)

//Test
(
m.noteOn(4,60,100);
m.noteOff(0,60);
)

//Clock and Trig Seq
(
//Clock
(
Pdef('clock1'.stop);
Pdef('clock1',
	Pbind(
'type','midi',
'midicmd','noteOn',
'midiout',c,
'chan',4,
'midinote',60,
'amp',1,
'dur',		Prand([1/4,1/8,1/16],inf),
'sustain',
Pkey('dur',inf)/2,
	).collect({ arg event;
		e = event;
	});
).play.quant(1);
);
//Trig Seq
(
Pdef('mseq1').stop;
Pdef('mseq1',
	Pbind(
'type', 'midi',
'midicmd', 'noteOn',
'midiout', m,
'chan', Pseq([
Prand([1    ]),
Prand([0,3,0]),
Prand([0,3,0]),
Prand([0,3,0]),
Prand([0,3,0]),
Prand([0,3,0]),
Prand([0,3,0]),
Prand([0,3,0]),
Prand([2    ]),
Prand([0,3,0]),
Prand([0,3,0]),
Prand([0,3,0]),
Prand([0,3,0]),
Prand([0,3,0]),
Prand([0,3,0]),
Prand([0,3,0]),
	    ],inf),
'midinote', 60,
'amp', 1,	'dur',Pfunc({e['dur']}),
'sustain', Pkey('dur',inf)/4,
	)
).play.quant(1)
);
)