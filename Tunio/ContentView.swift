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
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
                Spacer()
                
                HStack {
                    Text(td.data.note)
                        .font(.system(size: 40, design: .serif))
                }.padding()
                
                HStack {
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
                
                NoteDistanceConstantMarkers()
                    .overlay(CurrentNoteMarker(distance: td.data.distance))
                
                NodeOutputView(td.tappableB, color: Color("DarkerGray"), backgroundColor: Color("LighterPink"))
                    .clipped()
                    .frame(height: 200)
                
            }
        }
        .font(.system(size: 20, design: .serif))
        .background(Color("LighterPink"))
        .task {
            if !td.engine.avEngine.isRunning {
                td.start()
            }
        }
        .task {
            await PermissionsChecker.getMicrophoneAccess()
        }
    }
}
