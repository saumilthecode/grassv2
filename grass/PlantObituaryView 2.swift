import SwiftUI

struct PlantObituaryView: View {
    @Binding var plant: Plant

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 12) {
                    Image(systemName: "leaf.fill")
                        .foregroundStyle(.secondary)
                    VStack(alignment: .leading) {
                        Text(plant.name)
                            .font(.title)
                            .bold()
                        if !plant.scientificName.isEmpty {
                            Text(plant.scientificName)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                if let dod = plant.dateOfDeath {
                    Label {
                        Text("Passed on \(dod.formatted(date: .abbreviated, time: .omitted))")
                    } icon: {
                        Image(systemName: "calendar")
                            .foregroundStyle(.secondary)
                    }
                } else {
                    Label("Date of passing unknown", systemImage: "questionmark.circle")
                        .foregroundStyle(.secondary)
                }

                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Care Summary")
                        .font(.headline)
                    Text("Water every \(plant.wateringFrequency) days. \(plant.wateringGuide)")
                        .fixedSize(horizontal: false, vertical: true)
                    Text("Fertilise every \(plant.fertilisationFrequency) days. \(plant.fertilisationGuide)")
                        .fixedSize(horizontal: false, vertical: true)
                    Text("Preferred temperature: \(plant.temperatureRangeBegin)–\(plant.temperatureRangeEnd)˚C")
                }

                Spacer(minLength: 0)
            }
            .padding()
        }
        .navigationTitle("Obituary")
    }
}

#Preview {
    NavigationView {
        PlantObituaryView(plant: .constant(Plant(name: "Lorem Ipsum", scientificName: "Lorem ipsum", wateringFrequency: 7, wateringGuide: "Keep soil moist.", fertilisationFrequency: 30, fertilisationGuide: "Use balanced fertiliser.", temperatureRangeBegin: 18, temperatureRangeEnd: 26, isDead: true, dateOfDeath: Date())))
    }
}
