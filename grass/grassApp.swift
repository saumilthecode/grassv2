//
//  grassApp.swift
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
import UserNotifications
@main

struct grassApp: App {
    private var delegate: NotificationDelegate = NotificationDelegate()
    @StateObject private var plantManager = PlantManager()
    
    init() {
        let center = UNUserNotificationCenter.current()
        center.delegate = delegate
        center.requestAuthorization(options: [.alert, .sound, .badge]) { result, error in
            if let error = error {
                print(error)
            }
        }
        
        // Clean up any orphaned notifications
        cleanupOrphanedNotifications()
    }
    
    private func cleanupOrphanedNotifications() {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { requests in
            let validIdentifiers = self.plantManager.plants.flatMap { plant in
                ["watering-\(plant.id)", "fertilisation-\(plant.id)"]
            }
            
            let orphanedIdentifiers = requests
                .map { $0.identifier }
                .filter { !validIdentifiers.contains($0) }
            
            if !orphanedIdentifiers.isEmpty {
                center.removePendingNotificationRequests(withIdentifiers: orphanedIdentifiers)
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(plantManager)
        }
    }
}
