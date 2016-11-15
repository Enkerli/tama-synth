# Tama Synth Project
Trying to build a tama-style “talking drum” synth for Sonic Pi.

# Background
The name “tama” is used for some hourglass-shaped drums in West Africa. Strings hold the skin on those drums and can increase the tension, thereby changing the pitch of the drum sounds. Because many languages spoken in the region are use tones to distinguish words, these drums codify spoken language by reproducing tone patterns for different words, which is the basic way “talking drums” work.

This synth is based on the [“MembraneCircle”](http://doc.sccode.org/Classes/MembraneCircle.html) UGen (“Unit Generator”) for SuperCollider created by [Alex McLean](http://yaxu.org/) in 2008. McLean’s [MembraneUGens](https://github.com/supercollider/sc3-plugins/tree/master/source/MembraneUGens) plugin is part of [sc3-plugins](https://github.com/supercollider/sc3-plugins). The way this plugin works is by creating a physical model of a membrane (like a drum’s skin) using the wavetable synthesis technique. The `tension:` and `loss:` arguments refer to physical characteristics of those membranes. Increasing tension on a skin not only increases the pitch but changes the overall sound. “Loss” has more to do with resonance though low values may affect the perception of pitch.

# Usage
To use the “tama” synth in Sonic Pi, you can either download the compiled Synthesis Definition file `tama.scsyndef` to your local machine or execute the following code in SuperCollider (after changing the path).
```
(
SynthDef(\tama,
         {|note = 52, amp = 1, out_bus = 0, pan=0.0, gate=1, tension=0.05, loss=0.9, vel=1, dur=1 |
		var signal, freq;
		var lossexp=LinLin.ar(loss,0.0,1.0,0.9,1.0);
		var env = Env([0, 1, 0.5, 1, 0], [0.01, 0.5, 0.02, 0.5]);
		var excitation = EnvGen.kr(Env.perc, gate, timeScale: 1, doneAction: 0) * PinkNoise.ar(0.4);
		freq=note.midicps;
		signal = amp*MembraneCircle.ar(excitation, tension*(freq/60.midicps), lossexp);
		DetectSilence.ar(signal,doneAction:2);
		signal = signal * EnvGen.ar(Env.perc, gate, vel*0.5, 0, dur, 2);
		signal=Pan2.ar(signal, pan);
        Out.ar(out_bus,signal);
	}
).writeDefFile("/Users/alex/Desktop/sc-synths")
)
```

Either way, you end up with a file called `tama.scsyndef` on your machine.

You need to let Sonic Pi know where to find your synths, so you load them doing the following in Sonic Pi (after changing the path):
`load_synthdefs "/Users/alex/Desktop/sc-synths"`

Then, you can use the new synth in Sonic Pi by doing the following:
`synth "tama"`

# Playing with the Synth’s Core Parameters: `loss:`, `tension:`, `note:`, and `dur:`
You can change the sound quite radically by tweaking some arguments. For instance:
`synth "tama", note: 15, tension: 0.05, loss: 0.99999, dur: 1.5`
or
`synth "tama", note: 50, tension: 0.05, loss: 0.9, dur: 0.1`

The Sonic Pi file `tama.rb` contains three liveloops playing with some of those values. The `spi-tama-synth.wav` file is an example run from those loops, changing one of them as a kind of “solo”.

There’s an intricate relationship between the three key parameters (`loss:`, `tension:`, and `note:`). The `loss:` argument might be the most unusual one. Anything below `0.9` sounds really hollow. It becomes increasingly resonant by adding “extra nines” all the way to “five nines” (so: `0.9`, `0.99`, `0.999`, `0.9999`, and `0.99999`). Haven’t noticed any difference between `0.99999` (“five nines”) and `0.999999` (six nines). Or, indeed, with a value `1.0`.

As can be seen in the SuperCollider `SynthDef` code, there’s a link between `note:` and `tension:`. But `tension:` also has an effect on resonance, like `loss:`. A very low value for `loss:` (say, below `0.02`) makes the sound very hollow, especially with a low note. With a high note (say, `85`), a very low `tension:` makes the synth sound very close to a bell. Neat effect, if you ask me.

While `note:` is setting the drum’s base frequency, the actual tone you hear is modified by `tension:`. So, a lower `note:` can produce a higher pitch than a higher `note:` if `tension:` is higher. In some ways, it’s almost as though each `note:` produced a different instrument.

The `dur:` parameter controls the duration of the sound. Because resonance is controlled by the other arguments, the sound may become at least perceptually shorter with less resonance. As with other synths, longer durations also means that the synth layers sound upon sound, using processing power a while longer. If the sound extends over the `sleep` in a Sonic Pi loop (in other words, if the sound is layered upon itself several times over, in rapid succession), it may cause problems with the SuperCollider server behind Sonic Pi.
