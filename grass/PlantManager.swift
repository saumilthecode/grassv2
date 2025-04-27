//
//we were forced to write this code
//
//pls no copy
//
//made by tu madere 

import Foundation
import SwiftUI
import UserNotifications

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
}
