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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        
        completionHandler()
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
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
                    ForEach($plantManager.plants) { $plant in
                        NavigationLink(destination: PlantDetailView(plants: $plant)) {
                            VStack(alignment: .leading){
                                Text(plant.name)
                                HStack{
                                    Spacer()
                                }
                            }
                        }
                    }.onDelete { offset in
                        plantManager.plants.remove(atOffsets: offset)
                    }.onMove { source, destination in
                        plantManager.plants.move(fromOffsets: source, toOffset: destination)
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
                    ForEach($plantManager.plants) { $plant in
                        NavigationLink(destination: GrowthTrackerView(plant: $plant)) {
                            VStack(alignment: .leading) {
                                Text(plant.name)
                                Text("\(plant.growthJournal.entries.count) growth entries")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
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
