//
//  ContentView.swift
//  tunio
//
//  Created by Sophie Saunders on 6/3/24.
//

import AudioKitUI // NodeOutputView
import SwiftUI

struct ContentView: View {
    // StateObject means that when a Published value changes, we will be notified.
    @StateObject var td = ToneDetector()
    
    // Track whether app is active, inactive, or in background
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            HStack {
                Text(td.data.note)
                    .font(.system(size: 40, design: .serif))
            }.padding()
            
            HStack {
                Text("Distance:")
                Text("\(td.data.distance, specifier: "%0.1f") cents")
            }
            
            HStack {
                Text("Frequency:")
                Text("\(td.data.pitch, specifier: "%0.1f") Hz")
            }
            
            HStack {
                Text("Amplitude:")
                Text("\(td.data.amplitude, specifier: "%0.1f")")
            }
                        
            HStack {
                Text("Octave:")
                Text(String(td.data.octave))
            }
            
            Spacer()
            
            NodeOutputView(td.tappableB, color: Color("DarkerGray"), backgroundColor: Color("LighterPink")).clipped()
            
            Spacer()
        }
        .font(.system(size: 20, design: .serif))
        .background(Color("LighterPink"))
        .padding()
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                if !td.engine.avEngine.isRunning {
                    td.start()
                }
            } else if newPhase == .inactive {
                if td.engine.avEngine.isRunning {
                    td.stop()
                }
            } else if newPhase == .background {
                if td.engine.avEngine.isRunning {
                    td.stop()
                }
            }
        }
        .task {
            await td.getMicrophoneAccess()
        }
    }
}
