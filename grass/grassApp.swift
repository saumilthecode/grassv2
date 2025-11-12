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
    @StateObject private var plantManager = PlantManager()
    @State private var delegate: NotificationDelegate?
    
    init() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { result, error in
            if let error = error {
                print(error)
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(plantManager)
                .onAppear {
                    // Create and set up delegate with plantManager
                    let newDelegate = NotificationDelegate()
                    newDelegate.plantManager = plantManager
                    UNUserNotificationCenter.current().delegate = newDelegate
                    self.delegate = newDelegate
                    
                    // Clean up any orphaned notifications
                    cleanupOrphanedNotifications()
                }
        }
    }
    
    private func cleanupOrphanedNotifications() {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { requests in
            // Only include notifications for living plants
            let validIdentifiers = plantManager.plants
                .filter { !$0.isDead }
                .flatMap { plant in
                    ["watering-\(plant.id)", "fertilisation-\(plant.id)"]
                }
            
            let orphanedIdentifiers = requests
                .map { $0.identifier }
                .filter { !validIdentifiers.contains($0) }
            
            if !orphanedIdentifiers.isEmpty {
                center.removePendingNotificationRequests(withIdentifiers: orphanedIdentifiers)
            }
        }
        
        // Also clean up notifications for dead plants
        plantManager.cleanupNotificationsForDeadPlants()
    }
}
