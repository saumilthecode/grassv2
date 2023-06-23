//
//  ContentView.swift
//  grass
//we were forced to write this code
//
//pls no copy
//
//made by tu madere

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
