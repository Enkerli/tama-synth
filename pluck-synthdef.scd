(
SynthDef(\pluck,
         {|note = 52, amp = 1, out_bus = 0, pan=0.0, gate=1, coef=0.5, vel=1, dur=1 |
		var signal;
		var freq=note.midicps;
		var env = Env([0, 1, 0.5, 1, 0], [0.01, 0.5, 0.02, 0.5]);
		signal = amp*Pluck.ar(WhiteNoise.ar(0.1), Impulse.kr(1), freq.reciprocal, freq.reciprocal, 10, coef);
		signal = signal * EnvGen.ar(Env.perc, gate, vel*0.5, 0, dur, 2);
		signal=Pan2.ar(signal, pan);
        Out.ar(out_bus,signal);
	}
).writeDefFile("/Users/alex/Desktop/sc-synths")
)