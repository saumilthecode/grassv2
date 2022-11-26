//
//  ContentView.swift
//  grass
//
//  Created by saumil on 22/10/22.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var plantManager = PlantManager()
    var body: some View {
        TabView{
            LaunchView()
            AddCustomPlantView(plants: $plantManager.plants)
        }.tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
