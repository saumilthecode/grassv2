//
//  PlantObituaryView.swift
//  grass
//
//  Created for plant obituaries
//

import SwiftUI

struct PlantObituaryView: View {
    @Binding var plant: Plant
    @Environment(\.dismiss) var dismiss
    @State private var obituaryText: String = ""
    @State private var showingObituaryForm = false
    @State private var showingGallery = false
    @State private var selectedPhotoIndex: Int = 0
    
    // Plant puns for obituaries
    private func obituaryPuns(for plantName: String) -> [String] {
        [
            "Rest in peas, dear \(plantName).",
            "You've leaf us too soon, \(plantName).",
            "We're rooting for you in the next life, \(plantName).",
            "You've been a stem-azing companion, \(plantName).",
            "Your memory will always be in bloom, \(plantName).",
            "You've petal-ed away, but never forgotten, \(plantName).",
            "We're so sorry for your loss... of chlorophyll, \(plantName).",
            "You've gone to seed, but your legacy grows on, \(plantName).",
            "We'll always remember how you branched out, \(plantName).",
            "You've been compost-ed, but never forgotten, \(plantName)."
        ]
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                        .opacity(0.6)
                    
                    Text("In Loving Memory")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text(plant.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    if !plant.scientificName.isEmpty {
                        Text(plant.scientificName)
                            .font(.title3)
                            .italic()
                            .foregroundColor(.gray)
                    }
                    
                    if let dateOfDeath = plant.dateOfDeath {
                        Text("Passed away on \(dateOfDeath.formatted(date: .long, time: .omitted))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.top, 4)
                    }
                }
                .padding(.top, 40)
                
                Divider()
                    .padding(.horizontal)
                
                // Obituary content
                VStack(alignment: .leading, spacing: 16) {
                    if let obituary = plant.obituary, !obituary.isEmpty {
                        Text(obituary)
                            .font(.body)
                            .lineSpacing(4)
                    } else {
                        Text(obituaryPuns(for: plant.name).randomElement() ?? "You will be missed, \(plant.name).")
                            .font(.body)
                            .lineSpacing(4)
                            .italic()
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                // Growth journal summary and gallery
                if !plant.growthJournal.entries.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Growth Journey")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Text("\(plant.growthJournal.entries.count) photo\(plant.growthJournal.entries.count == 1 ? "" : "s") captured")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        if let firstEntry = plant.growthJournal.entries.sorted(by: { $0.dayNumber < $1.dayNumber }).first,
                           let lastEntry = plant.growthJournal.entries.sorted(by: { $0.dayNumber < $1.dayNumber }).last,
                           firstEntry.id != lastEntry.id {
                            let daysLived = lastEntry.dayNumber - firstEntry.dayNumber
                            Text("Lived for \(daysLived) day\(daysLived == 1 ? "" : "s")")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                        }
                        
                        // Thumbnail grid
                        let entries = plant.growthJournal.entries.sorted { $0.dayNumber < $1.dayNumber }
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                            ForEach(Array(entries.enumerated()), id: \.element.id) { idx, entry in
                                if let uiImage = UIImage(data: entry.imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 90)
                                        .clipped()
                                        .cornerRadius(10)
                                        .onTapGesture {
                                            selectedPhotoIndex = idx
                                            showingGallery = true
                                        }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top)
                }
                
                // Edit obituary button
                Button(action: {
                    obituaryText = plant.obituary ?? ""
                    showingObituaryForm = true
                }) {
                    Label("Edit Obituary", systemImage: "pencil")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("Swamp Green"))
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                // Restore plant button
                Button(action: {
                    plant.isDead = false
                    plant.dateOfDeath = nil
                    dismiss()
                }) {
                    Label("Mark as Alive", systemImage: "heart.fill")
                        .font(.headline)
                        .foregroundColor(Color("Swamp Green"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("Swamp Green").opacity(0.1))
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 40)
        }
        .navigationTitle("Obituary")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingObituaryForm) {
            NavigationView {
                Form {
                    Section(header: Text("Obituary")) {
                        TextEditor(text: $obituaryText)
                            .frame(minHeight: 200)
                    }
                    
                    Section(footer: Text("Write a heartfelt obituary for your plant. Or leave empty to use a random plant pun.")) {
                        EmptyView()
                    }
                }
                .navigationTitle("Edit Obituary")
                .navigationBarItems(
                    leading: Button("Cancel") {
                        showingObituaryForm = false
                    },
                    trailing: Button("Save") {
                        plant.obituary = obituaryText.isEmpty ? nil : obituaryText
                        showingObituaryForm = false
                    }
                )
            }
        }
        // Full-screen gallery viewer
        .fullScreenCover(isPresented: $showingGallery) {
            GalleryViewer(entries: plant.growthJournal.entries.sorted { $0.dayNumber < $1.dayNumber }, startIndex: selectedPhotoIndex, isPresented: $showingGallery)
        }
    }
}

struct GalleryViewer: View {
    let entries: [GrowthEntry]
    let startIndex: Int
    @Binding var isPresented: Bool
    @State private var currentIndex: Int = 0
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            TabView(selection: $currentIndex) {
                ForEach(Array(entries.enumerated()), id: \.element.id) { idx, entry in
                    if let uiImage = UIImage(data: entry.imageData) {
                        VStack {
                            Spacer()
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .tag(idx)
                                .padding()
                            Text("Day \(entry.dayNumber) • \(entry.date.formatted(date: .abbreviated, time: .shortened))")
                                .foregroundColor(.white.opacity(0.8))
                                .font(.footnote)
                                .padding(.bottom, 20)
                            Spacer()
                        }
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        }
        .onAppear { currentIndex = startIndex }
        .overlay(alignment: .topTrailing) {
            Button(action: { isPresented = false }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white.opacity(0.9))
                    .padding()
            }
        }
    }
}

struct PlantObituaryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PlantObituaryView(plant: .constant(Plant(
                name: "Fernando",
                scientificName: "Fernsicus Maximus",
                wateringFrequency: 3,
                wateringGuide: "Keep moist",
                fertilisationFrequency: 14,
                fertilisationGuide: "Monthly",
                temperatureRangeBegin: 18,
                temperatureRangeEnd: 24,
                isDead: true,
                dateOfDeath: Date()
            )))
        }
    }
}

