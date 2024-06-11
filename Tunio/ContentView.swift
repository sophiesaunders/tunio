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
        
        GeometryReader { metrics in
            
            VStack {
                
                Spacer()
                
                HStack {
                    Text(td.data.note)
                        .font(.system(size: 200, design: .serif))
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)
                        .padding()
                }
                .padding()
                .frame(height: metrics.size.height * 0.25)
                
                VStack {
                    Text("\(td.data.pitch, specifier: "%0.1f") Hz")
                        .minimumScaleFactor(0.1)
                        .font(.system(size: 15, design: .serif))
                        .lineLimit(1)
                    Text("Amplitude: \(td.data.amplitude, specifier: "%0.2f")")
                        .minimumScaleFactor(0.1)
                        .font(.system(size: 15, design: .serif))
                        .lineLimit(1)
                    Text("Octave: \(td.data.octave)")
                        .minimumScaleFactor(0.1)
                        .font(.system(size: 15, design: .serif))
                        .lineLimit(1)
                }
                .padding(.bottom)
                .frame(height: metrics.size.height * 0.2)
                
                Spacer()
                
                NoteDistanceConstantMarkers()
                    .overlay(CurrentNoteMarker(distance: td.data.distance))
                    .frame(height: metrics.size.width * 0.25)
                
                NodeOutputView(td.tappableB, color: Color("DarkerGray"), backgroundColor: Color("LighterPink"))
                    .clipped()
                    .frame(height: metrics.size.height * 0.25)
                
            }
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
}
