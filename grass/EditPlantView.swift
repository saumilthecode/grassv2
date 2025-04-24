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
                TextField("Watering Instructions", text: $plant.wateringGuide)
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
                TextField("Fertilisation Instructions", text: $plant.fertilisationGuide)
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
        let center = UNUserNotificationCenter.current()
        
        // Remove existing notifications
        center.removeAllPendingNotificationRequests()
        
        // Create watering notification
        let wateringContent = UNMutableNotificationContent()
        wateringContent.title = "Water your plant"
        wateringContent.subtitle = "It's thirsty"
        wateringContent.sound = UNNotificationSound.default
        
        let wateringTrigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(plant.wateringFrequency * 86400), repeats: true)
        let wateringRequest = UNNotificationRequest(identifier: "watering-\(plant.id)", content: wateringContent, trigger: wateringTrigger)
        
        // Create fertilisation notification
        let fertilisationContent = UNMutableNotificationContent()
        fertilisationContent.title = "Fertilise your plant"
        fertilisationContent.subtitle = "It's hungry"
        fertilisationContent.sound = UNNotificationSound.default
        
        let fertilisationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(plant.fertilisationFrequency * 86400), repeats: true)
        let fertilisationRequest = UNNotificationRequest(identifier: "fertilisation-\(plant.id)", content: fertilisationContent, trigger: fertilisationTrigger)
        
        // Add notifications
        center.add(wateringRequest)
        center.add(fertilisationRequest)
    }
}

struct EditPlantView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EditPlantView(plant: .constant(Plant(name: "Test Plant", scientificName: "Testus Plantus", wateringFrequency: 7, wateringGuide: "Water thoroughly", fertilisationFrequency: 14, fertilisationGuide: "Use plant food", temperatureRangeBegin: 15, temperatureRangeEnd: 25)))
        }
    }
} 