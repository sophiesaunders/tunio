//
//  ContentView.swift
//  tunio
//
//  Created by Sophie Saunders on 6/3/24.
//

import AVFoundation // AVAudioApplication
import AudioKitUI // NodeOutputView
import SwiftUI

struct NoteDistanceConstantMarkers: View {
    var body: some View {

        // All the horizontal tick marks
        HStack {
            ForEach(0..<25) { index in
                Rectangle()
                    .frame(width: 1, height: tickSize(forIndex: index))
                    .cornerRadius(1)
                    .foregroundColor(Color("DarkerGray"))
                    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                
                if index < 24 {
                    Spacer()
                }
            }
        }
    }
    private func tickSize(forIndex index: Int) -> CGFloat {
        switch index {
        case 12: 160 // Middle tick is the tallest
        case 0, 4, 8, 16, 20, 24: 95
        default: 50
        }
    }
}

struct CurrentNoteMarker : View {
    let distance: Float
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Rectangle()
                    .frame(width: 4, height: 160)
                    .cornerRadius(4)
                    .foregroundColor(-5 < distance && distance < 5 ? .green : .red)
            }
            .frame(width: geometry.size.width)
            .offset(x: (geometry.size.width / 2) * CGFloat(distance / 50))
            .animation(.easeInOut, value: distance)
        }
    }
}

func getMicrophoneAccess() async {
    if #available(iOS 17.0, *) {
        let permission = AVAudioApplication.shared.recordPermission
        switch permission {
            case .granted: return
            case .denied: fatalError()
            case .undetermined: break
            default: break
        }
        
        await AVAudioApplication.requestRecordPermission()
    }
}

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
            await getMicrophoneAccess()
        }
    }
}
