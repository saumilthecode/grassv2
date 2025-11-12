//
//we were forced to write this code
//
//pls no copy
//
//made by tu madere 

import Foundation
import SwiftUI
import UserNotifications

// Plant puns for humor throughout the app
struct PlantPuns {
    static let generalPuns = [
        "You're doing great! Keep up the good work!",
        "Your plants are rooting for you!",
        "Don't leaf your plants hanging!",
        "You're a stem-azing plant parent!",
        "Time to branch out and water your plants!",
        "Your green thumb is showing!",
        "You're really growing as a plant parent!",
        "Don't be a sap, water your plants!",
        "You're blooming with potential!",
        "Keep calm and plant on!",
        "You're petal-ing in the right direction!",
        "Your plants think you're un-be-leaf-able!",
        "You're really branching out!",
        "Don't forget to water - your plants are thirsty!",
        "You're doing a great job - your plants are thriving!",
        "Time to fertilize - your plants are hungry!",
        "You're a natural at this!",
        "Your plants are so lucky to have you!",
        "Keep up the excellent work!",
        "You're making your plants very happy!"
    ]
    
    static let wateringPuns = [
        "Time to water! Don't be a drip about it!",
        "Your plant is thirsty - time to hydrate!",
        "Water you waiting for? Time to water!",
        "Don't leaf your plant high and dry!",
        "It's watering time - your plant needs a drink!",
        "H2-oh no! Time to water your plant!",
        "Your plant is parched - give it a drink!",
        "Water you doing? Watering your plant, of course!",
        "Time to make it rain for your plant!",
        "Your plant is thirsty - don't keep it waiting!"
    ]
    
    static let fertilizingPuns = [
        "Time to fertilize! Your plant is hungry!",
        "Feed your plant - it's meal time!",
        "Your plant needs nutrients - time to fertilize!",
        "Don't let your plant go hungry - fertilize now!",
        "Time to give your plant some plant food!",
        "Your plant is hungry - feed it well!",
        "Fertilize your plant - it's snack time!",
        "Your plant needs nutrients - don't keep it waiting!",
        "Time to nourish your plant!",
        "Feed your plant - it's growing time!"
    ]
    
    static func randomGeneralPun() -> String {
        generalPuns.randomElement() ?? "Keep up the good work!"
    }
    
    static func randomWateringPun() -> String {
        wateringPuns.randomElement() ?? "Time to water your plant!"
    }
    
    static func randomFertilizingPun() -> String {
        fertilizingPuns.randomElement() ?? "Time to fertilize your plant!"
    }
}

class PlantManager: ObservableObject {
    @Published var plants: [Plant] = [] {
        didSet {
            // Remove notifications for deleted plants
            let oldPlantIDs = Set(oldValue.map { $0.id })
            let newPlantIDs = Set(plants.map { $0.id })
            let deletedPlantIDs = oldPlantIDs.subtracting(newPlantIDs)
            
            for plantID in deletedPlantIDs {
                cleanupNotifications(for: plantID)
            }
            
            // Clean up notifications for plants that just died
            for plant in plants {
                if let oldPlant = oldValue.first(where: { $0.id == plant.id }) {
                    if !oldPlant.isDead && plant.isDead {
                        // Plant just died - remove notifications
                        cleanupNotifications(for: plant.id)
                    } else if !oldPlant.isDead && !plant.isDead {
                        // Plant is still alive - ensure notifications are scheduled
                        scheduleNotifications(for: plant)
                    }
                } else {
                    // New plant - schedule notifications if alive
                    if !plant.isDead {
                        scheduleNotifications(for: plant)
                    }
                }
            }
            
            save()
        }
    }

    let samplePlants: [Plant] = []

    
    
    init() {
        load()
    }

    func getArchiveURL() -> URL {
        let plistName = "plants.plist"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        return documentsDirectory.appendingPathComponent(plistName)
    }

    func save() {
        let archiveURL = getArchiveURL()
        let propertyListEncoder = PropertyListEncoder()
        let encodedPlants = try? propertyListEncoder.encode(plants)
        try? encodedPlants?.write(to: archiveURL, options: .noFileProtection)
    }

    func load() {
        let archiveURL = getArchiveURL()
        let propertyListDecoder = PropertyListDecoder()

        var finalPlants: [Plant]!

        if let retrievedPlantData = try? Data(contentsOf: archiveURL),
           let decodedPlants = try? propertyListDecoder.decode([Plant].self, from: retrievedPlantData) {
            finalPlants = decodedPlants
        } else {
            finalPlants = samplePlants
        }

        plants = finalPlants
    }

    private func cleanupNotifications(for plantID: UUID) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [
            "watering-\(plantID)",
            "fertilisation-\(plantID)"
        ])
    }
    
    func cleanupNotificationsForDeadPlants() {
        let center = UNUserNotificationCenter.current()
        for plant in plants where plant.isDead {
            cleanupNotifications(for: plant.id)
        }
    }
    
    func scheduleNotifications(for plant: Plant) {
        // Don't schedule notifications for dead plants
        guard !plant.isDead else { return }
        
        let center = UNUserNotificationCenter.current()
        
        // Remove existing notifications first
        cleanupNotifications(for: plant.id)
        
        // Create watering notification
        let wateringContent = UNMutableNotificationContent()
        wateringContent.title = "Water \(plant.name)"
        wateringContent.subtitle = PlantPuns.randomWateringPun()
        wateringContent.sound = UNNotificationSound.default
        wateringContent.userInfo = ["plantID": plant.id.uuidString, "type": "watering"]
        
        let wateringTrigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(plant.wateringFrequency * 86400), repeats: true)
        let wateringRequest = UNNotificationRequest(identifier: "watering-\(plant.id)", content: wateringContent, trigger: wateringTrigger)
        
        center.add(wateringRequest)
        
        // Create fertilisation notification
        let fertilisationContent = UNMutableNotificationContent()
        fertilisationContent.title = "Fertilise \(plant.name)"
        fertilisationContent.subtitle = PlantPuns.randomFertilizingPun()
        fertilisationContent.sound = UNNotificationSound.default
        fertilisationContent.userInfo = ["plantID": plant.id.uuidString, "type": "fertilisation"]
        
        let fertilisationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(plant.fertilisationFrequency * 86400), repeats: true)
        let fertilisationRequest = UNNotificationRequest(identifier: "fertilisation-\(plant.id)", content: fertilisationContent, trigger: fertilisationTrigger)
        
        center.add(fertilisationRequest)
    }
}
