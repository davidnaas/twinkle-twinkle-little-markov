//durations and stuff
2::second => dur T;
T - (now % T) => now;
0::T => dur barSum;


//radnomize starting note
Std.rand2(0,4) => int currentNoteNode;
/*Std.rand2(0,3)*/ 3 => int currentRythmNode;

//patch
JCRev r;
Echo e;	
SinOsc s => r => e => dac;

//initialize sound patch
.05 => s.gain;
//4 => s.vibratoFreq;
//0.002 => s.vibratoGain;

0.0 => r.mix;

0.0 => e.mix;
3::second => e.max;
0.5::T => e.delay;

//scale to choose from
[0, 2, 4, 5, 7, 9, 11] @=> int scale[];

//the markovchain itself
 [[.15, .2, .2, .15, .15, .0, .0],
 [.05,.15, .2, .2, .15, .0, .0],
 [.1, .05,.15, .2, .2, .0, .0],
 [.15, .1, .05,.15, .2, .0, .0],
 [.15, .15, .1, .05,.15, .0, .0],
 [.0, .0, .0, .0, .0, .0,.0],
 [.0, .0, .0, .0, .0, .0,.0]] @=> float noteGraph[][];
 
 [[.0, .0, .0, .0],
 [.0, .0, .0, .0],
 [.0, .0, .0, .0],
 [.0, .0, .0, 1]] @=> float rythmgraph[][];

//compute markov steps and advance time
while(true){
	
	Std.fabs(Std.randf()) => float rand1;

	0.0 => float probsum1;
	//markov note
	for(0 => int i; i<noteGraph[0].cap(); i++){
		probsum1 + noteGraph[currentNoteNode][i] => probsum1;
		if(rand1 < probsum1 ){
			<<<currentNoteNode, i>>>;
			i => currentNoteNode;
			Std.mtof(69 + scale[i]) => s.freq;
			break;
		}
	}
	
	Std.fabs(Std.randf()) => float rand2;

	0.0 => float probsum2;
	
	for(0 => int i; i< rythmgraph[0].cap(); i++){
		probsum2 + rythmgraph[currentRythmNode][i] => probsum2;
		if(rand2 < probsum2){
			i => currentRythmNode;
			T/(i+1) => dur beat;
			if(barSum % T == 0::T){
				//1 => s.noteOn;
				<<< "beat one" >>>;	
			}else{
				//Math.random2f( 0.4, 0.6 ) => s.noteOn;
			}
			beat + barSum => barSum; 
			beat => now;
			break;
		}
	}
}








