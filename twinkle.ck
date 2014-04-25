//durations and stuff
2::second => dur T;
T - (now % T) => now;
0::T => dur barSum;


//radnomize starting note
Std.rand2(0,5) => int currentNoteNode;
/*Std.rand2(0,3)*/ 1 => int currentRythmNode;

//patch
JCRev r;
Modulate m;	
Rhodey s => r => dac;

//initialize sound patch
.07 => s.gain;
0.6 => r.mix;




//scale to choose from
[0, 2, 4, 5, 7, 9] @=> int scale[];

//the markovchain for twinkle twinkle
 [[.5, .0, .0, .0, .5, .0],
 [.5, 1.0/3.0, .0, .0, 1.0/6.0, .0],
 [.0, .5, .5, .0, .0, .0],
 [.0, .0, .5, .5, .0, .0],
 [.0, .0, .0, .25, .5, .25],
 [.0, .0, .0, .0, .5, .5]
 ] @=> float noteGraph[][];
 
 [[.0, 1.0],
 [1.0/6.0, 5.0/6.0]] @=> float rythmgraph[][];

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
			Std.mtof(48 + scale[i]) => s.freq;
			break;
		}
	}
	
	Std.fabs(Std.randf()) => float rand2;

	0.0 => float probsum2;
	
	for(0 => int i; i< rythmgraph[0].cap(); i++){
		probsum2 + rythmgraph[currentRythmNode][i] => probsum2;
		if(rand2 < probsum2){
			i => currentRythmNode;
			T/((i+1)*2) => dur beat;
			if(barSum % T == 0::T){
				1 => s.noteOn;
				<<< "beat one" >>>;	
			}else{
				Math.random2f( 0.3, 0.4 ) => s.noteOn;
			}
			<<<"advanced with: ", "1/"+((i+1)*2)>>>;
			beat + barSum => barSum; 
			beat => now;
			break;
		}
	}
}








