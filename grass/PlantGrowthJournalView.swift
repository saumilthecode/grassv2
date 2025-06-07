import SwiftUI

struct PlantGrowthJournalView: View {
    @ObservedObject var plantManager: PlantManager
    
    var body: some View {
        NavigationView {
            List {
                ForEach($plantManager.plants) { $plant in
                    NavigationLink(destination: PlantGrowthDetailView(plant: $plant)) {
                        VStack(alignment: .leading) {
                            Text(plant.name)
                                .font(.headline)
                            if !plant.scientificName.isEmpty {
                                Text(plant.scientificName)
                                    .font(.subheadline)
                                    .italic()
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Growth Journal")
        }
    }
}

struct PlantGrowthJournalView_Previews: PreviewProvider {
    static var previews: some View {
        PlantGrowthJournalView(plantManager: PlantManager())
    }
} 