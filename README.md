# Tama Synth Project
An attempt at building new synths for [Sonic Pi](http://sonic-pi.net), primarily using Physical Modelling. 

# Background
This project is meant to be a collection of synths which can work within Sam Aaron’s [Sonic Pi](http://sonic-pi.net) music coding software. In the background, Sonic Pi uses a local [SuperCollider](https://supercollider.github.io) server to produce its “bleeps and boops”. Sonic Pi already has a fairly extensive collection of synths, but it’s fun to explore new options. More specifically, SuperCollider supports Physical Modelling techniques which make for rich sounds based on the acoustic properties of real instruments. The results can sound quite strange, especially at the limits of their range, just like an acoustic instrument can produce unusual sounds. Under proper conditions, however, Physical Modelling does a pretty good job of emulating instrumental sounds.

 The first synth in this batch is a tama-style “[talking drum](https://en.wikipedia.org/wiki/Talking_drum)” synth, which gave the project its name. The name “[tama](https://en.wikipedia.org/wiki/Talking_drum#Names_in_West_Africa)” is used for some hourglass-shaped drums in West Africa. Strings hold the skin on those drums and can increase the tension, thereby changing the pitch of the drum sounds. Because many languages spoken in the region are use tones to distinguish words, these drums codify spoken language by reproducing tone patterns for different words, which is the basic way “talking drums” work. (In my experience as an ethnomusicologist, “talking drums” tend to generate quite a bit of interest from people who are otherwise unaware of the range of musical diversity across the World.)

# Usage
To use these synths in Sonic Pi, you can download the compiled Synthesis Definition files (with the `.scsyndef` extension) to a dedicated folder on your local machine.

In Sonic Pi, you then need to ensure that “Enable external synths and FX” is checked in the “Audio” preferences. In a buffer, type `load_synthdefs` (it does autocomplete, so you can type `load` and choose the right option). You then drag the folder containing the `.scsyndef` files into that same buffer. 

On macOS or Linux, the result should look something like this:

```
load_synthdefs "/Users/<user>/synths"
```

On Raspbian, you may end up with:

```
load_synthdefs "/home/pi/synths"
```

On Windows, it might look like this:

```
load_synthdefs "/C:/Users/<user>/synths"
```

In which case the first slash should be deleted and you should have something like:

```
load_synthdefs "C:/Users/<user>/synths"
```

On any of these systems, it’s possible that dragging the folder itself may not work. In this case, you may drop a file from that folder and delete the full filename from the line.

When you run that buffer, Sonic Pi will load the synth definition files and make those synths available. You can then use them as you would the other synths by doing:

`use_synth: :<synth_name>`

For instance:

`use_synth: :tama`

And then use `play` the way you normally would.

Please note, however, that these synths only support some of the basic options: 

* `note:` (the number right after `play`, for instance `play 52`)
* `amp:` (the amplitude, from 0 to 1)
* `vel:` (the velocity of the note, correlated to volume)
* `pan:` (panning from -1 at the far left to 1 at the far right)
* `dur:` (the duration of the note, as a very simple envelope) 

Other options, like `_slide:` and other parts of the envelope aren’t currently supported.

## Compiling the Synths in SuperCollider
For those who know SuperCollider, the code needed to compile those synths is also provided (in `.scd` files). Feel free to modify the synths to your liking. Any improvement would be greatly appreciated. My coding skills are pretty minimal overall and SuperCollider is still quite a mystery to me. The synths themselves sound pretty good to me but several features could be added to them to make them more useful.

To build those synths, you should modify the path associated with `.writeDefFile`, select the whole code and execute it. You will then have your own copy of the `.scsyndef` file, for use in Sonic Pi. To simply play with the synth within SuperCollider, you need to change `SynthDef` to `SynthDef.new` and `.writeDefFile("/Users/alex/Desktop/sc-synths")` to `.play` or `.add`. (But you probably know this if you’ve already used SuperCollider.)

Please note that some of these synths may require the [sc3-plugins](https://github.com/supercollider/sc3-plugins). (But, again, you probably realise this if you know SuperCollider.)

# The Synths
At this point, two synths are available. A “talking drum” (Tama) and a “guitar” (Pluck).

## The “Tama” Synth
This “Tama” synth is based on the [“MembraneCircle”](http://doc.sccode.org/Classes/MembraneCircle.html) UGen (“Unit Generator”) for SuperCollider created by [Alex McLean](http://yaxu.org/) in 2008. McLean’s [MembraneUGens](https://github.com/supercollider/sc3-plugins/tree/master/source/MembraneUGens) plugin is part of [sc3-plugins](https://github.com/supercollider/sc3-plugins). The way this plugin works is by creating a physical model of a membrane (like a drum’s skin) using the wavetable synthesis technique. The `tension:` and `loss:` arguments refer to physical characteristics of those membranes. Increasing tension on a skin not only increases the pitch but changes the overall sound. “Loss” has more to do with resonance though low values may affect the perception of pitch.

### Playing with Tama’s Core Parameters: `loss:`, `tension:`, `note:`, and `dur:`
You can change the sound quite radically by tweaking some arguments. For instance:
`synth "tama", note: 15, tension: 0.05, loss: 0.99999, dur: 1.5`
or
`synth "tama", note: 50, tension: 0.05, loss: 0.9, dur: 0.1`

The Sonic Pi file `tama.rb` contains three liveloops playing with some of those values. The `spi-tama-synth.wav` file is an example run from those loops, changing one of them as a kind of “solo”.

There’s an intricate relationship between the three key parameters (`loss:`, `tension:`, and `note:`). The `loss:` argument might be the most unusual one. Anything below `0.9` sounds really hollow. It becomes increasingly resonant by adding “extra nines” all the way to “five nines” (so: `0.9`, `0.99`, `0.999`, `0.9999`, and `0.99999`). Haven’t noticed any difference between `0.99999` (“five nines”) and `0.999999` (six nines). Or, indeed, with a value `1.0`.

As can be seen in the SuperCollider `SynthDef` code, there’s a link between `note:` and `tension:`. But `tension:` also has an effect on resonance, like `loss:`. A very low value for `loss:` (say, below `0.02`) makes the sound very hollow, especially with a low note. With a high note (say, `85`), a very low `tension:` makes the synth sound very close to a bell. Neat effect, if you ask me.

While `note:` is setting the drum’s base frequency, the actual tone you hear is modified by `tension:`. So, a lower `note:` can produce a higher pitch than a higher `note:` if `tension:` is higher. In some ways, it’s almost as though each `note:` produced a different instrument.

The `dur:` parameter controls the duration of the sound. Because resonance is controlled by the other arguments, the sound may become at least perceptually shorter with less resonance. As with other synths, longer durations also means that the synth layers sound upon sound, using processing power a while longer. If the sound extends over the `sleep` in a Sonic Pi loop (in other words, if the sound is layered upon itself several times over, in rapid succession), it may cause problems with the SuperCollider server behind Sonic Pi.

## The “Pluck” Synth
On the [sonic-pi Google Group](https://groups.google.com/d/msg/sonic-pi/yuE92JC4viA/K42TwnDACQAJ), user Eli asked about “easy, convincing guitar sounds”. As Richard Dobson then explained, the Karplus-Strong model is the classic way to emulate plucked-string sounds. As Xavier Riley further explained, SuperCollider comes with the [Pluck](http://doc.sccode.org/Classes/Pluck.html) UGen, an implementation of that very same Karplus-Strong model. Basically, a noise is sent as an “excitation” of a string model which then resonates with decreasing amplitude.

This “pluck” synth is a quick and easy implementation of that Pluck UGen. Apart from some of the most basic arguments (`note:`, `amp:`, `pan:`, and `dur:`), this synth accepts `coef`, a coefficient which makes the string sound more or less muted. The usable range for this parameter is from -0.9 to about 0.9 or so.



