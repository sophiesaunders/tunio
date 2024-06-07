//
//  ContentView.swift
//  tunio
//
//  Created by Sophie Saunders on 6/3/24.
//

import AVFoundation // AVAudioSession
import AudioKit
import SoundpipeAudioKit // PitchTap
import AudioKitEX // Fader
import AudioKitUI // NodeRollingView, ...
import SwiftUI

struct ContentView: View {
    // StateObject means that when a value changes within the ViewModel class,
    // we will be notified.
    @StateObject var toneMgr = TunerManager()
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                Spacer()
                
                HStack {
                    Text("Frequency")
                    Text("\(toneMgr.data.pitch, specifier: "%0.1f")")
                }.padding()
                
                Spacer()
                
                HStack {
                    Text("Amplitude")
                    Text("\(toneMgr.data.amplitude, specifier: "%0.1f")")
                }.padding()
                
                Spacer()
                
                HStack {
                    Text("Note")
                    Text(toneMgr.data.note)
                }.padding()
                
                Spacer()
                
                HStack {
                    Text("Octave")
                    Text(String(toneMgr.data.octave))
                }.padding()
                
                InputDevicePicker(device: toneMgr.initialDevice!)

                NodeRollingView(toneMgr.tappableA).clipped()

                NodeOutputView(toneMgr.tappableB).clipped()

                NodeFFTView(toneMgr.tappableC).clipped()
            }
            .navigationTitle("Tunio")
            .padding()
            .onAppear() {
                toneMgr.start()
            }
            .onDisappear() {
                toneMgr.stop()
            }
        }
    }
}

struct InputDevicePicker: View {
    @State var device: Device

    var body: some View {
        Picker("Input: \(device.deviceID)", selection: $device) {
            ForEach(getDevices(), id: \.self) {aDevice in
                Text(String(aDevice.name))
            }
        }
        .pickerStyle(MenuPickerStyle())
        .onChange(of: device, perform: setInputDevice)
    }

    func getDevices() -> [Device] {
        AudioEngine.inputDevices.compactMap { $0 }
    }

    func setInputDevice(to device: Device) {
        let engine = AudioEngine()
        do {
            try engine.setDevice(device)
        } catch let err {
            print(err)
        }
    }
}

//#Preview {
//    ContentView()
//}
