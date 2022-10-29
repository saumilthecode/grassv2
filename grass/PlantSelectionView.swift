//
//  PlantSelectionView.swift
//  grass
//
//  Created by James Kuang on 28/10/22.
//

import SwiftUI

struct PlantSelectionView: View {
    var body: some View {
        NavigationView{
            VStack{
                Text("What do you want to grow?")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                
                NavigationLink(destination: PlantSelectionView()) {
                    Text("My plant isn't here!")
                }
                
                .padding(.vertical, 20)
                .padding(.horizontal, 87.75)
                .foregroundColor(.white)
                .background(Color(red: -0.123, green: 0.285, blue: 0.225))
                .cornerRadius(22.0)
            }
        }
    }
}

struct PlantSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        PlantSelectionView()
    }
}
