//
//  ContentView.swift
//  tunio
//
//  Created by Sophie Saunders on 6/3/24.
//

import AudioKit
import SoundpipeAudioKit // PitchTap
import AudioKitEX // Fader
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

#Preview {
    ContentView()
}
