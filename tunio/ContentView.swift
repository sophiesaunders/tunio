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
        
        NavigationView {
            VStack {
                
                Spacer()
                
                HStack {
                    Text("Frequency")
                    Text("\(td.data.pitch, specifier: "%0.1f")")
                }.padding()
                
                Spacer()
                
                HStack {
                    Text("Amplitude")
                    Text("\(td.data.amplitude, specifier: "%0.1f")")
                }.padding()
                
                Spacer()
                
                HStack {
                    Text("Note")
                    Text(td.data.note)
                }.padding()
                
                Spacer()
                
                HStack {
                    Text("Octave")
                    Text(String(td.data.octave))
                }.padding()
                
                NodeOutputView(td.tappableB).clipped()
            }
            .navigationTitle("Tunio")
            .padding()
            .onAppear() {
                td.start()
            }
            .onDisappear() {
                td.stop()
            }
        }
    }
}
