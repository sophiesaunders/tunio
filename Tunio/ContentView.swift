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
    
    #if os(iOS)
    let background = Color("MediumBlue")
    #else
    let background = Color("LighterBlue")
    #endif
    
    var body: some View {
        
        GeometryReader { metrics in
            
            VStack {
                
                HStack {
                    ToggleSwitch(toggleOn: $displaySharp)
                    Spacer()
                    Image(.iconOnlyTransparentNoBuffer)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 45)
                        .padding()
                }
                                                
                VStack {
                    HStack {
                        Text(displaySharp ? td.data.noteFlat : td.data.noteSharp)
                            .minimumScaleFactor(0.1)
                            .font(Font.custom("GentiumPlus", size: 200))
                            .lineLimit(1)
                        if td.data.noteFlat != "-" {
                            Text(String(td.data.octave))
                                .minimumScaleFactor(0.1)
                                .font(Font.custom("GentiumPlus", size: 25))
                                .baselineOffset(-metrics.size.height * 0.3 * 0.5)
                        }
                    }
                    Text("\(td.data.pitch, specifier: "%0.1f") Hz")
                        .minimumScaleFactor(0.1)
                        .font(Font.custom("GentiumPlus", size: 15))
                        .lineLimit(1)
                }
                .frame(height: metrics.size.height * 0.3)
                
                Spacer()
                
                NoteDistanceConstantMarkers(totalHeight: metrics.size.height)
                    .overlay(CurrentNoteMarker(distance: td.data.distance, totalHeight: metrics.size.height))
                    .frame(height: metrics.size.width * 0.25)
                
                NodeOutputView(td.tappableB, color: Color("DarkerGray"), backgroundColor: background)
                    .clipped()
                    .frame(height: metrics.size.height * 0.25)
                
            }
            .background(background)
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
