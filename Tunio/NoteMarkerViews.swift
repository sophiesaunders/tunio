//
//  NoteMarkerViews.swift
//  Tunio
//
//  Created by Sophie Saunders on 6/10/24.
//

import SwiftUI

struct NoteDistanceConstantMarkers: View {
    let totalHeight: CGFloat
    
    var body: some View {

        // All the horizontal tick marks
        HStack {
            Spacer()
            ForEach(0..<25) { index in
                Rectangle()
                    .frame(width: 1, height: tickSize(forIndex: index))
                    .cornerRadius(1)
                    .foregroundColor(Color("DarkerGray"))
                
                Spacer()
            }
        }
    }
    private func tickSize(forIndex index: Int) -> CGFloat {
        switch index {
        case 12: totalHeight * 0.25 // Middle tick is the tallest
        case 7, 2, 17, 22: totalHeight * 0.16
        default: totalHeight * 0.09
        }
    }
}

struct CurrentNoteMarker : View {
    let distance: Float
    let totalHeight: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Rectangle()
                    .frame(width: 8, height: totalHeight * 0.25)
                    .cornerRadius(4)
                    .foregroundColor(-10 < distance && distance < 10 ? 
                                      Color(red: 0.435, green: 0.8, blue: 0.361) : .red)
            }
            .frame(width: geometry.size.width)
            .offset(x: getOffset(width: geometry.size.width, distance: distance))
            .animation(.easeInOut, value: distance)
            .fixedSize()
        }
    }
    private func getOffset(width: Double, distance: Float) -> CGFloat {
        var offset = (width / 2) * CGFloat(distance / 50)
        if offset < (-width / 2) {
            offset = -width / 2
        }
        if offset > (width / 2) {
            offset = width / 2
        }
        return offset
    }
}
