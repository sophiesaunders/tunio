//
//  ToggleSwitch.swift
//  Tunio
//
//  Created by Sophie Saunders on 6/12/24.
//

import SwiftUI

struct ToggleSwitch: View {
    @Binding var toggleOn: Bool
    
    var body: some View {
        VStack () {
            ZStack {
                Capsule()
                    .frame(width:40,height:22)
                    .foregroundColor(Color("DarkerGray"))
                ZStack{
                    Circle()
                        .frame(width:20, height:20)
                        .foregroundColor(.white)
                    Text(toggleOn ? "#" : "♭")
                        .font(Font.custom("GentiumPlus", size:15))
                }
                .shadow(color: .black.opacity(0.14), radius: 4, x: 0, y: 2)
                .offset(x: toggleOn ? 8 : -8)
                .padding(24)
                .animation(Animation.spring, value: toggleOn)
            }
            .onTapGesture {
                self.toggleOn.toggle()
            }
        }
        .padding(.top)
        .frame(height: 30)
    }
}
