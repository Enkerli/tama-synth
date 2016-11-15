live_loop :bd do
  synth "tama", note: 15, tension: 0.05, loss: 0.99999, dur: 1.5
  sleep 2
end

live_loop :tm do
  synth "tama", note: 50, tension: 0.04, loss: 0.9999, dur: 0.2
  sleep 0.2
  synth "tama", note: 50, tension: 0.05, loss: 0.999, dur: 0.1
  sleep 0.2
  synth "tama", note: 50, tension: 0.06, loss: 0.99999, dur: 0.4
  sleep 0.4
  synth "tama", note: 50, tension: 0.07, loss: 0.99999, dur: 0.6
  sleep 0.6
  synth "tama", note: 50, tension: 0.08, loss: 0.99999, dur: 0.6
  sleep 0.6
end

live_loop :ld do
  sleep 1.2
  synth "tama", note: 64, tension: 0.04, loss: 0.99999, dur: 0.6
  sleep 0.6
end


