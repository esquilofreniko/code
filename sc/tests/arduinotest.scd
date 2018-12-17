p = ArduinoSMS("/dev/ttyACM0", 115200);

p.close;

(
p.action = {
	arg ... msg;
	if(msg[1] > 0,{
		~ino = msg;
		msg.postln
	}, {
		~ino[0] = msg[0];
	});
};
)

~ino;
