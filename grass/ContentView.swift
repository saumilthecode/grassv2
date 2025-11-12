//
//we were forced to write this code
//
//pls no copy
//
//made by tu madere 

import SwiftUI
enum NotificationAction: String {
    case dimiss
    case reminder
}

enum NotificationCategory: String {
    case general
}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    var plantManager: PlantManager?
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        
        completionHandler()
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Check if the plant is still alive before showing notification
        if let plantIDString = notification.request.content.userInfo["plantID"] as? String,
           let plantID = UUID(uuidString: plantIDString),
           let plantManager = plantManager,
           let plant = plantManager.plants.first(where: { $0.id == plantID }),
           plant.isDead {
            // Plant is dead - don't show notification
            completionHandler([])
            // Remove the notification request
            center.removePendingNotificationRequests(withIdentifiers: [notification.request.identifier])
            return
        }
        
        completionHandler([.banner, .sound, .badge])
    }
}

struct ContentView: View {
    @EnvironmentObject var plantManager: PlantManager
    
    @State var isNewPlantPresented = false
    @State var isOnboardingPresented = false
    
    @AppStorage("IsFirstLaunch") var isFirstLaunch = true
    
    var body: some View {
        TabView {
            // Plants Tab
            NavigationView {
                List {
                    // Living plants section
                    let livingPlants = plantManager.plants.filter { !$0.isDead }
                    if !livingPlants.isEmpty {
                        Section(header: Text("Living Plants")) {
                            ForEach(Array(plantManager.plants.enumerated()).filter { !$0.element.isDead }, id: \.element.id) { index, _ in
                                let plantBinding = Binding(
                                    get: { plantManager.plants[index] },
                                    set: { plantManager.plants[index] = $0 }
                                )
                                NavigationLink(destination: PlantDetailView(plants: plantBinding)) {
                                    HStack {
                                        Image(systemName: "leaf.fill")
                                            .foregroundColor(Color("Swamp Green"))
                                        VStack(alignment: .leading) {
                                            Text(plantManager.plants[index].name)
                                                .font(.headline)
                                            if !plantManager.plants[index].scientificName.isEmpty {
                                                Text(plantManager.plants[index].scientificName)
                                                    .font(.caption)
                                                    .italic()
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        Spacer()
                                    }
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        // Mark as dead instead of deleting - preserve all data
                                        let currentPlant = plantManager.plants[index]
                                        var updatedPlant = currentPlant
                                        updatedPlant.isDead = true
                                        updatedPlant.dateOfDeath = Date()
                                        // Ensure growth journal and all other data is preserved
                                        plantManager.plants[index] = updatedPlant
                                    } label: {
                                        Label("Mark as Dead", systemImage: "leaf.fill")
                                    }
                                    .tint(.gray)
                                }
                            }
                            .onMove { source, destination in
                                // Handle move for living plants only
                                var livingIndices = plantManager.plants.enumerated()
                                    .filter { !$0.element.isDead }
                                    .map { $0.offset }
                                livingIndices.move(fromOffsets: source, toOffset: destination)
                                // Reorder plants array based on new order
                                let livingPlants = livingIndices.map { plantManager.plants[$0] }
                                let deadPlants = plantManager.plants.filter { $0.isDead }
                                plantManager.plants = livingPlants + deadPlants
                            }
                        }
                    }
                    
                    // Dead plants / Obituaries section
                    let deadPlants = plantManager.plants.filter { $0.isDead }
                    if !deadPlants.isEmpty {
                        Section(header: Text("In Memory")) {
                            ForEach(Array(plantManager.plants.enumerated()).filter { $0.element.isDead }, id: \.element.id) { index, _ in
                                let plantBinding = Binding(
                                    get: { plantManager.plants[index] },
                                    set: { plantManager.plants[index] = $0 }
                                )
                                NavigationLink(destination: PlantObituaryView(plant: plantBinding)) {
                                    HStack {
                                        Image(systemName: "leaf.fill")
                                            .foregroundColor(.gray)
                                            .opacity(0.6)
                                        VStack(alignment: .leading) {
                                            Text(plantManager.plants[index].name)
                                                .font(.headline)
                                                .foregroundColor(.gray)
                                            if let dateOfDeath = plantManager.plants[index].dateOfDeath {
                                                Text("Passed away \(dateOfDeath.formatted(date: .abbreviated, time: .omitted))")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                    
                    if plantManager.plants.isEmpty {
                        Section {
                            Text("No plants yet. Tap + to add your first plant!")
                                .foregroundColor(.gray)
                                .italic()
                        }
                    }
                }
                .navigationTitle("My Plants")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isNewPlantPresented = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .tabItem {
                Label("Plants", systemImage: "leaf.fill")
            }
            
            // Growth Tracker Tab
            NavigationView {
                List {
                    ForEach(Array(plantManager.plants.enumerated()).filter { !$0.element.isDead }, id: \.element.id) { index, _ in
                        let plantBinding = Binding(
                            get: { plantManager.plants[index] },
                            set: { plantManager.plants[index] = $0 }
                        )
                        NavigationLink(destination: GrowthTrackerView(plant: plantBinding)) {
                            VStack(alignment: .leading) {
                                Text(plantManager.plants[index].name)
                                Text("\(plantManager.plants[index].growthJournal.entries.count) growth entries")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    if plantManager.plants.filter({ !$0.isDead }).isEmpty {
                        Text("No living plants to track. Add a plant to start tracking growth!")
                            .foregroundColor(.gray)
                            .italic()
                    }
                }
                .navigationTitle("Growth Tracker")
            }
            .tabItem {
                Label("Growth", systemImage: "chart.line.uptrend.xyaxis")
            }
        }
        .sheet(isPresented: $isNewPlantPresented) {
            NavigationView {
                AddCustomPlantView(plants: $plantManager.plants, isOnboarding: false)
            }
        }
        .sheet(isPresented: $isOnboardingPresented) {
            OnboardingView(plantManager: plantManager)
        }
        .onChange(of: plantManager.plants) { newValue in
            isOnboardingPresented = newValue.isEmpty
        }
        .onAppear {
            if isFirstLaunch {
                isOnboardingPresented = true
                isFirstLaunch = false
            }
        }
    }
}

/*
 Saumils Notification Code
 VStack {
     Button("Schedule Notification") {
         
         let center = UNUserNotificationCenter.current()
         
         // create content
         let content = UNMutableNotificationContent()
         content.title = "Hot Coffee"
         content.body =  "Your delicious coffee is ready!"
         content.categoryIdentifier = NotificationCategory.general.rawValue
         content.userInfo = ["customData": "Some Data"]
         
         if let url = Bundle.main.url(forResource: "coffee", withExtension: "png") {
             if let attachment = try? UNNotificationAttachment(identifier: "image", url: url, options: nil) {
                 content.attachments = [attachment]
             }
         }
         
         // create trigger
         let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
         
         // create request
         let request = UNNotificationRequest(identifier: "Identifier", content: content, trigger: trigger)
         
         // define actions
         let dismiss = UNNotificationAction(identifier: NotificationAction.dimiss.rawValue, title: "Dismiss", options: [])
         
         let reminder = UNNotificationAction(identifier: NotificationAction.reminder.rawValue, title: "Reminder", options: [])
         
         let generalCategory = UNNotificationCategory(identifier: NotificationCategory.general.rawValue, actions: [dismiss, reminder], intentIdentifiers: [], options: [])
         
         center.setNotificationCategories([generalCategory])
         
         // add request to notification center
         center.add(request) { error in
             if let error = error {
                 print(error)
             }
         }
     }
 }
 */
