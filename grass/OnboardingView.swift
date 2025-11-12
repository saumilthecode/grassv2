//
//  ContentView.swift
//  grass
//
//  Created by saumil on 22/10/22.
//
//
//we were forced to write this code
//
//pls no copy
//
//made by tu madere

import SwiftUI

struct OnboardingView: View {
    @Environment(\.horizontalSizeClass) private var hSizeClass
    @ObservedObject var plantManager: PlantManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        TabView {
            Group {
                if hSizeClass == .regular {
                    LaunchView()
                        .frame(maxWidth: 700, maxHeight: .infinity)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    LaunchView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(12)
                }
            }

            AddCustomPlantView(plants: $plantManager.plants, isOnboarding: true, onPlantAdded: {
                // Dismiss onboarding when first plant is added
                if !plantManager.plants.isEmpty {
                    dismiss()
                }
            })
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .onChange(of: plantManager.plants) { newValue in
            // Auto-dismiss when plant is added during onboarding
            if !newValue.isEmpty {
                dismiss()
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(plantManager: PlantManager())
    }
}


