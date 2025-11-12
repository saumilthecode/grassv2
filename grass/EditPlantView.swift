//
//  EditPlantView.swift
//  grass
//
//  Created by Saumil Anand on 9/6/25.
//



import SwiftUI
import UserNotifications

struct EditPlantView: View {
    @Binding var plant: Plant
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form {
            Section(header: Text("Basic Details")) {
                TextField("Plant Name", text: $plant.name)
                TextField("Scientific Name (Optional)", text: $plant.scientificName)
            }
            Section(header: Text("Habitat")) {
                HStack {
                    Text("Minimum Temperature")
                    TextField("", value: $plant.temperatureRangeBegin, formatter: NumberFormatter())
                        .frame(width: 50)
                        .padding(.leading)
                    Text("˚C")
                    Stepper(value: $plant.temperatureRangeBegin, in: -20...40) {
                        EmptyView()
                    }
                }
                HStack {
                    Text("Maximum Temperature")
                    TextField("", value: $plant.temperatureRangeEnd, formatter: NumberFormatter())
                        .frame(width: 50)
                        .padding(.leading)
                    Text("˚C")
                    Stepper(value: $plant.temperatureRangeEnd, in: -19...41) {
                        EmptyView()
                    }
                }
            }
            Section(header: Text("Watering")) {
                HStack {
                    Text("Frequency")
                    TextField("", value: $plant.wateringFrequency, formatter: NumberFormatter())
                        .frame(width: 50)
                        .padding(.leading)
                    Text("days")
                    Stepper(value: $plant.wateringFrequency, in: 1...30) {
                        EmptyView()
                    }
                }
                TextField("Watering Instructions (Optional)", text: $plant.wateringGuide)
            }
            Section(header: Text("Fertilisation")) {
                HStack {
                    Text("Frequency")
                    TextField("", value: $plant.fertilisationFrequency, formatter: NumberFormatter())
                        .frame(width: 50)
                        .padding(.leading)
                    Text("days")
                    Stepper(value: $plant.fertilisationFrequency, in: 1...8) {
                        EmptyView()
                    }
                }
                TextField("Fertilisation Instructions(Optional)", text: $plant.fertilisationGuide)
            }
        }
        .navigationTitle("Edit Plant")
        .navigationBarItems(trailing: Button("Save") {
            // Update notifications
            updateNotifications()
            dismiss()
        })
    }
    
    private func updateNotifications() {
        // Notifications will be updated automatically by PlantManager's didSet
        // when the plant binding is updated
    }
}

struct EditPlantView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditPlantView(plant: .constant(Plant(name: "Test Plant", scientificName: "Testus Plantus", wateringFrequency: 7, wateringGuide: "Water thoroughly", fertilisationFrequency: 14, fertilisationGuide: "Use plant food", temperatureRangeBegin: 15, temperatureRangeEnd: 25)))
        }
    }
} 
