//
//  ContentView.swift
//  tunio
//
//  Created by Sophie Saunders on 6/3/24.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var image: Image? // starts off nil
    
    func getNewImage() {
        guard let url = URL(string: "https://random.imagecdn.app/500/500") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {
            data, _, _ in guard let data = data else { return }
            
            DispatchQueue.main.async {
                guard let uiImage = UIImage(data: data) else { return }
                self.image = Image(uiImage: uiImage)
            }
        }
        task.resume()
    }
}

struct ContentView: View {
    // StateObject means that when a value changes within the ViewModel class,
    // we will be notified.
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                Spacer()
                
                if let image = viewModel.image {
                    ZStack {
                        image
                            .resizable()
                            .foregroundColor(Color.pink)
                            .frame(width: 300, height:300)
                            .padding()
                    }
                    .frame(width: UIScreen.main.bounds.width / 1.2,
                           height: UIScreen.main.bounds.width / 1.2)
                    .background(Color.pink)
                    .cornerRadius(8)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .foregroundColor(Color.pink)
                        .frame(width: 300, height: 300)
                        .padding()
                }
                
                Text("Cool photo, eh?")
                
                Spacer()
                
                Button(action: {
                    viewModel.getNewImage()
                }, label: {
                    Text("New Image!")
                        .frame(width: 250, height: 40)
                        .bold()
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding()
                })
                
                Spacer()
            }
            .navigationTitle("Tunio")
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
