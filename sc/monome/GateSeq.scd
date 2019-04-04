(
Server.default = Server.local;
~m.free;
~m = MonoM.new("/monome", 0);

// s.waitForBoot({
MIDIClient.init;
MIDIIn.connectAll;
~midiout = MIDIOut.new(0);
~midiout.connect(1);
~step = Array.fill(64, {1});
~patt = Array.fill(64,{0});
~trig = Array.fill(4,{0});
~play_position = 15;
~next_position = 0;
~cutting = 0;
~keys_held = 0;
~key_last = 0;
~loop_start = 0;
~loop_end = 15;
~pattmode = 1;
~morphchance = 0;
~probvalue = 1;
~rec = 0;
~solokey = 0;
~solomode = [1,1,1,1];
~solopatt = [];
~soloin = 0;
~m.useDevice(0);

OSCFunc.newMatching(
		{ arg message, time, addr, recvPort;
			~x = message[1];
			~y = message[2];
			~z = message[3];
			// toggles
			if((~z == 1) && (~y < 4), {
				var pos = ~x + (~y * 16);
				if(~pattmode==1,
					{if(~patt[pos]==1,
						{~patt[pos]=0},
						{~patt[pos]=1})},
					{if(~patt[pos]==1,
						{~patt[pos]=0},
						{
							if(~step[pos]==~probvalue,
								{~step[pos] = 0;},
								{~step[pos] = ~probvalue;});
					});
				});
			});
			//set morphchance/probvalue
			if((~z==1)&&(~y==5),
				{
				if(~pattmode==1,
					{~morphchance = ~x},
						{if(~x<=10,{
							~probvalue = ~x;
					});
				});
			});
			//control row
			if((~z==1)&&(~x==0)&&(~y==6),
				{~pattmode =  (~pattmode+1)%2});
			if((~z==1)&&(~x==1)&&(~y==6),
				{~m.levset(1,6,15);
				for(0,15,{arg i;
					~morph.value(i);
				});
			});
			if((~z==1)&&(~x==10)&&(~y==6),
				{~rec = (~rec+1)%2});
			if((~x==11)&&(~y==6)&&(~z==1),
				{~solokey = (~solokey+1)%2});
			if((~y==6)&&(~z==1)&&(~x>11)&&(~solokey == 1),
				{~solomode[~x-12] = (~solomode[~x-12]+1)%2});
			if((~y==6)&&(~z==1)&&(~x>11)&&(~solokey == 0),
				{
				~midiout.noteOn(1,~x-12,120);
				~midiout.noteOff(1,~x-12,120);
				~m.levset(~x,~y,15);
				if(~rec==1,
					{~patt[((~x-12)*16)+~play_position] = 1}
				);});
			// count bottom row keys
			if(~y == 7,
				if(~z == 1,
					{~keys_held = ~keys_held + 1;},
					{~keys_held = ~keys_held - 1;});
			);
			// loop and cut
			if((~z == 1) && (~y == 7), {
				if(~keys_held == 1,
				{
					~play_position = ~x-1;
					if(~play_position > ~loop_end,
						{~play_position = ~loop_end-1});
					if(~play_position < ~loop_start,
						{~play_position = ~loop_end});
					~cutting = 1;
					~key_last = ~x;
				},
				{
					~loop_start = ~key_last;
					~loop_end = ~x;
				});
			});
			if(~z == 1,
				{d.value;});
		}, "/monome/grid/key");

d = {
		for(0,15, {arg x;
			for(0,3, {arg y;
				if((~patt[x+(y*16)] == 0),
					{
						if(~step[x+(y*16)] == 0,
							{~m.levset(x,y,0);},
							{~m.levset(x,y,~step[x+(y*16)]+1);});

					},
							{~m.levset(x,y,15);});
			});
			// display morphchance/probvalue
			if(~pattmode==1,
				{if((x<=~morphchance),
					{~m.levset(x,5,x);},
					{~m.levset(x,5,0);});
				},
				{if((x<=10),
					{
						~m.levset(x,5,x+1);
						~m.levset(~probvalue,5,15);
					},
					{~m.levset(x,5,0);}
				);
			});
			//Highlight Loop Length
			if((~loop_end<~loop_start),
		    {var temp;temp=~loop_start;~loop_start = ~loop_end;~loop_end=temp});
			if((x>=~loop_start)&&(x<=~loop_end),
			{~m.levset(x,7,4)},
			{~m.levset(x,7,0)});
		});
		//display control row indications
		~m.levset(0,6,(4+(~pattmode*11)));
		~m.levset(1,6,4);
		~m.levset(10,6,4+(~rec*11));
		~m.levset(11,6,4+(~solokey*11));
		~m.levset(12,6,2+(~solomode[0]*4));
		~m.levset(13,6,2+(~solomode[1]*4));
		~m.levset(14,6,2+(~solomode[2]*4));
		~m.levset(15,6,2+(~solomode[3]*4));
		// play  position
		~m.levset(~play_position,7,15);
	};

~morph =
	{
		arg i;
		for(0,3, {arg t;var prob;
			prob = rand(10);
			if(((~step[(t*16)+i]) > prob),
				{if(~solomode[t]==0,
					{~patt[(t*16)+i] = 1;},
					{~solopatt = ~solopatt.add(t);~soloin = 1})},
				{~patt[(t*16)+i] = 0;});
		    });
		if(~soloin == 1,{
			~solopatt.scramble;
			~patt[(~solopatt[0]*16)+i] = 1;
		});
		~soloin = 0;
		~solopatt = [];
	};

r = {
	~m.levset(~play_position,7,4);
	~play_position = (~play_position + 1)%(~loop_end+1);
	if(~play_position == 0,
		{~play_position = ~loop_start;});
		// play  position
		~m.levset(~play_position,7,15);

		//Pattern
		~morphrng = rand(15);
		if((~morphrng < ~morphchance),
		{
		~morph.value(~play_position);
		for(0,15, {arg x;
			for(0,3, {arg y;
				if((~patt[x+(y*16)] == 0),
					{
					if(~step[x+(y*16)] == 0,
						{~m.levset(x,y,0);},
						{~m.levset(x,y,~step[x+(y*16)]+1);});

					},
					{~m.levset(x,y,15);
				    });
			    });
		    });
	    });
		//Triggers
		for(0,3, {arg t;
				if(((~patt[(t*16)+~play_position]) == 1),
			{
				~trig[t] = 1;
				~midiout.noteOn(t,60,120);
				~midiout.noteOff(t,60,120);
				~m.levset(12+t,6,15);
				{~m.levset(12+t,6,2+(~solomode[t]*4))}.defer(0.05);
			},{
				~trig[t] = 0;
			});
		});
	if(~play_position == ~loop_start,
		{d.value});
	};
d.value;
~midi1 = MIDIFunc.noteOn({r.value;},chan:4); // clock
~midi2 = MIDIFunc.noteOn({~play_position = ~loop_end},chan:5); //reset
)

~midiout = MIDIOut.new(0);
~midiout.connect(1);
~midiout.noteOn(1,60,120);