//
//  ContentView.swift
//  Tunio
//
//  Created by Sophie Saunders on 6/3/24.
//

import AudioKitUI // NodeOutputView
import SwiftUI

struct ContentView: View {
    
    // StateObject means that when a Published value changes, we will be notified.
    @StateObject var td = ToneDetector()
    @State var displaySharp = false
    
    var body: some View {
        
        GeometryReader { metrics in
            
            VStack {
                
                HStack {
                    ToggleSwitch(toggleOn: $displaySharp)
                    Spacer()
                }
                
                Spacer()
                                
                VStack {
                    HStack {
                        Text(displaySharp ? td.data.noteFlat : td.data.noteSharp)
                            .font(.system(size: 200, design: .serif))
                            .minimumScaleFactor(0.1)
                            .lineLimit(1)
                        if td.data.noteFlat != "-" {
                            Text(String(td.data.octave))
                                .font(.system(size: 25, design: .serif))
                                .minimumScaleFactor(0.1)
                                .baselineOffset(-metrics.size.height * 0.3 * 0.5)
                        }
                    }
                    Text("\(td.data.pitch, specifier: "%0.1f") Hz")
                        .minimumScaleFactor(0.1)
                        .font(.system(size: 15, design: .serif))
                        .lineLimit(1)
                }
                .frame(height: metrics.size.height * 0.3)
                
                Spacer()
                
                NoteDistanceConstantMarkers(totalHeight: metrics.size.height)
                    .overlay(CurrentNoteMarker(distance: td.data.distance, totalHeight: metrics.size.height))
                    .frame(height: metrics.size.width * 0.25)
                
                NodeOutputView(td.tappableB, color: Color("DarkerGray"), backgroundColor: Color("LighterBlue"))
                    .clipped()
                    .frame(height: metrics.size.height * 0.25)
                
            }
            .background(Color("LighterBlue"))
            .task {
                await PermissionsChecker.getMicrophoneAccess()
            }
            .task {
                if !td.engine.avEngine.isRunning {
                    td.start()
                }
            }
        }
    }
}
