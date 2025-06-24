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
    @Environment(\.scenePhase) var scenePhase
    @State var displaySharp = false
    @State var missingPermissions = false
    
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
                    if missingPermissions {
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .padding(.top, 4)

                            Text("Tunio requires microphone access. Please update your settings.")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .semibold))
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding()
                        .background(Color.red)
                        .cornerRadius(12)
                        .padding([.horizontal, .top])
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.3), value: missingPermissions)
                    }
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
                        .font(Font.custom("GentiumPlus", size: 20))
                        .lineLimit(1)
                }
                .frame(height: metrics.size.height * 0.3)
                
                Spacer()
                
                NoteDistanceConstantMarkers(totalHeight: metrics.size.height)
                    .overlay(CurrentNoteMarker(distance: td.data.distance, totalHeight: metrics.size.height))
                    .frame(height: metrics.size.height * 0.25)
                
                NodeOutputView(td.tappableB, color: Color("DarkerGray"), backgroundColor: background)
                    .clipped()
                    .frame(height: metrics.size.height * 0.25)
                                
            }
            .background(background)
            .task {
                if await !PermissionsChecker.getMicrophoneAccess() {
                    missingPermissions = true
                }
            }
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
        }
    }
}
