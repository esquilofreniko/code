
(
Server.default = Server.local;

~m = MonoM.new("/monome", 0);

s.waitForBoot({

~step = Array.fill(128, {0});

~m.useDevice(0);

OSCFunc.newMatching(
		{ arg message, time, addr, recvPort;
		var pos = message[1] + (message[2] * 16);
		~step[pos] = message[3];
		d.value;
		message.postln;
		}, "/monome/grid/key");


d = {
		for(0,7, {arg y;
			for(0,15, {arg x;
				~m.levset(x,y,~step[y*16+x] * 15);
			})
		})
	};

});

)