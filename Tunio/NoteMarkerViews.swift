//
//  NoteMarkerViews.swift
//  tunio
//
//  Created by Sophie Saunders on 6/10/24.
//

import SwiftUI

struct NoteDistanceConstantMarkers: View {
    var body: some View {

        // All the horizontal tick marks
        HStack {
            Spacer()
            ForEach(0..<25) { index in
                Rectangle()
                    .frame(width: 1, height: tickSize(forIndex: index))
                    .cornerRadius(1)
                    .foregroundColor(Color("DarkerGray"))
                    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                
                Spacer()
            }
        }
    }
    private func tickSize(forIndex index: Int) -> CGFloat {
        switch index {
        case 12: 160 // Middle tick is the tallest
        case 7, 2, 17, 22: 95
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
            .frame(width: geometry.size.width * 0.9)
            .offset(x: (geometry.size.width / 2) * CGFloat(distance / 50))
            .animation(.easeInOut, value: distance)
            .fixedSize()
        }
    }
}
