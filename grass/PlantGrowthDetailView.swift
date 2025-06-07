import SwiftUI
import PhotosUI

struct PlantGrowthDetailView: View {
    @Binding var plant: Plant
    @State private var selectedItem: PhotosPickerItem?
    @State private var plantImages: [UIImage] = []
    @State private var showingImagePicker = false
    
    var body: some View {
        ScrollView {
            VStack {
                // Plant stem visualization
                ZStack(alignment: .bottom) {
                    // Stem
                    Rectangle()
                        .fill(Color.brown)
                        .frame(width: 20)
                        .frame(maxHeight: .infinity)
                    
                    // Flowerpot
                    Image(systemName: "square.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 150)
                        .foregroundColor(.brown)
                        .rotationEffect(.degrees(45))
                        .offset(y: 20)
                }
                .frame(height: 400)
                .padding()
                
                // Plant images
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(plantImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                        // Add photo button
                        Button(action: {
                            showingImagePicker = true
                        }) {
                            VStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 40))
                                Text("Add Photo")
                                    .font(.caption)
                            }
                            .frame(width: 200, height: 200)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(plant.name)
        .photosPicker(isPresented: $showingImagePicker,
                     selection: $selectedItem,
                     matching: .images)
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    plantImages.append(image)
                }
            }
        }
    }
}

struct PlantGrowthDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PlantGrowthDetailView(plant: .constant(Plant(
                name: "Test Plant",
                scientificName: "Testus Plantus",
                wateringFrequency: 7,
                wateringGuide: "Water thoroughly",
                fertilisationFrequency: 14,
                fertilisationGuide: "Use plant food",
                temperatureRangeBegin: 15,
                temperatureRangeEnd: 25
            )))
        }
    }
} 