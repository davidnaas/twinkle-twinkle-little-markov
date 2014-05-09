1::second => dur T;
T - (now % T) => now;

MidiIn min;
MidiMsg msg;
Rhodey s => JCRev r => dac;
0.2 => s.gain;

// open midi receiver, exit on fail
if ( !min.open(0) ) me.exit(); 

while( true ){
    // wait on midi event
    min => now;

    // receive midimsg(s)
    while( min.recv( msg ) ){
    	if (msg.data1 != 144)
    		continue;
        // print content
    	<<< msg.data1, msg.data2, msg.data3 >>>;
    	
    	
    	Std.mtof(msg.data2) => s.freq;
    	1 => s.noteOn;
    	1::samp => now;
    	
    }
}


