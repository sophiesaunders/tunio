//
//  TuningLogic.swift
//  Tunio
//
//  Created by Sophie Saunders on 6/11/24.
//

import AudioKit
import SoundpipeAudioKit // PitchTap
import AudioKitEX // Fader
import AVFoundation // AVAudioSession

// Basic info for every piece of mic input data we get
struct TunerData {
    var pitch: Float = 0.0
    var amplitude: Float = 0.0
    var octave: Int = 0
    var noteFlat = "-"
    var noteSharp = "-"
    var distance: Float = 0.0
}

class ToneDetector : ObservableObject, HasAudioEngine {
    @Published var data = TunerData()
    let engine = AudioEngine()

    let mic: AudioEngine.InputNode
    let tappableA: Fader
    let tappableB: Fader
    let silence: Fader
    var tracker: PitchTap!
    
    private var pitchBuffer: [AUValue] = []
    private var octaveBuffer: [Int] = []
    private let maxBufferSize = 4
    
    let noteFrequencies: [Float] = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let noteNamesFlats = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    let noteNamesSharps = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    
    init() {
        guard let inputTmp = engine.input else { fatalError() }
        mic = inputTmp

        tappableA = Fader(mic)
        tappableB = Fader(tappableA)
        silence = Fader(tappableB, gain: 0)
        engine.output = silence
        
        PermissionsChecker.setSessionParameters()
        
        tracker = PitchTap(mic) { pitch, amp in
            DispatchQueue.main.async {
                self.update(pitch[0], amp[0])
            }
        }
        tracker.start()
    }
    
    func update(_ pitch: AUValue, _ amp: AUValue) {
        
        // AMPLITUDE: Eliminate noise
        guard amp > 0.07 else { return }
        data.amplitude = amp

        // PITCH: Maintain an array of most recent pitches
        // We will use the median value to minimize wobble
        pitchBuffer.append(pitch)
        if pitchBuffer.count > maxBufferSize {
            pitchBuffer.removeFirst()
        }
        let sorted = pitchBuffer.sorted()
        let medianPitch = sorted[sorted.count / 2]
        data.pitch = medianPitch
        
        // FREQUENCY: Multiply the pitch to scale it up or down to the freq range we know
        //
        // Important observation: We don't want to jump up an octave just because we're greater
        // than the last freq in the known array, or jump down an octave just because we're
        // less than the first freq in the known array. Then, any flat C would be a B, and any
        // sharp B would be a C. We want to find where we're closer to 2*Cfreq than B, or
        // closer to Bfreq/2 than C.
        var frequency = medianPitch
        let minFreq = noteFrequencies[0]
        let maxFreq = noteFrequencies[noteFrequencies.count - 1]
        while frequency > (((minFreq*2) + maxFreq)/2) {
            frequency /= 2.0
        }
        while frequency < (((maxFreq/2) + minFreq)/2) {
            frequency *= 2.0
        }
        
        // NOTE: Find the known note frequency we are CLOSEST to
        var minDistance: Float = 10000.0
        var index = 0
        for possibleIndex in 0..<noteFrequencies.count {
            let distance = fabsf(Float(noteFrequencies[possibleIndex]) - frequency)
            if distance < minDistance {
                index = possibleIndex
                minDistance = distance
            }
        }
        data.noteFlat = noteNamesFlats[index]
        data.noteSharp = noteNamesSharps[index]
        
        // DISTANCE: This is how far we are from our note.
        // There are 1200 musical "cents" in an octave.
        data.distance = 1200 * log2f(Float(frequency / noteFrequencies[index]))
        
        // OCTAVE: Find the multiplier of the known (octave 0) known range
        // Maintain an array of recent octaves and the 2nd highest to minimize
        // wobble (unless we have < maxBufferSize items).
        let octave = Int(log2f(medianPitch / frequency))
        octaveBuffer.append(octave)
        if octaveBuffer.count > maxBufferSize {
            octaveBuffer.removeFirst()
        }
        let sortedOctave = octaveBuffer.sorted()
        if sortedOctave.count >= maxBufferSize {
            // When we have a full set of data, this helps us ignore
            // subharmonics on stringed instruments, as well as any
            // overtones.
            data.octave = sortedOctave[sortedOctave.count - 2]
        }
        else {
            // This helps us ignore subharmonics especially on string instruments.
            data.octave = sortedOctave.max()!
        }
    }
}
