//
//  tunioApp.swift
//  tunio
//
//  Created by Sophie Saunders on 6/3/24.
//

import AudioKit
import SoundpipeAudioKit // PitchTap
import AudioKitEX // Fader
import AVFoundation // AVAudioSession
import SwiftUI

@main
struct tunioApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// Basic info for every piece of mic input data we get
struct TunerData {
    var pitch: Float = 0.0
    var amplitude: Float = 0.0
    var octave: Int = 0
    var note = "-"
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
        guard amp > 0.1 else { return }
        
        data.pitch = pitch
        data.amplitude = amp
        
        // Get the frequency down or up to the range that we know
        var frequency = pitch
        while frequency > Float(noteFrequencies[noteFrequencies.count - 1]) {
            frequency /= 2.0
        }
        while frequency < Float(noteFrequencies[0]) {
            frequency *= 2.0
        }
        
        // Find the known note frequency we are CLOSEST to
        var minDistance: Float = 10000.0
        var index = 0
        for possibleIndex in 0..<noteFrequencies.count {
            let distance = fabsf(Float(noteFrequencies[possibleIndex]) - frequency)
            if distance < minDistance {
                index = possibleIndex
                minDistance = distance
            }
        }
        data.octave = Int(log2f(pitch / frequency))
        if noteNamesFlats[index] == noteNamesSharps[index] {
            data.note = "\(noteNamesFlats[index])"
        } else {
            data.note = "\(noteNamesFlats[index]) / \(noteNamesSharps[index])"
        }
        
        data.distance = 1200 * log2f(Float(frequency / noteFrequencies[index]))
    }
}
