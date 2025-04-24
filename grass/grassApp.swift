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
    @StateObject var plantManager = PlantManager()
    
    init() {
        let center = UNUserNotificationCenter.current()
        center.delegate = delegate
        center.requestAuthorization(options: [.alert, .sound, .badge]) { result, error in
            if let error = error {
                print(error)
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(plantManager: plantManager)
        }
    }
}
