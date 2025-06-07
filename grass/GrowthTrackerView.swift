import SwiftUI
import PhotosUI

struct GrowthTrackerView: View {
    @Binding var plant: Plant
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var showingImagePicker = false
    @State private var showingAddEntrySheet = false
    @State private var showingEditEntrySheet = false
    @State private var newEntryNotes = ""
    @State private var newEntryDayNumber = 1
    @State private var showingCamera = false
    @State private var showingImageSourcePicker = false
    @State private var editingEntry: GrowthEntry?
    @State private var showingDuplicateDayAlert = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Add new entry button at the top
                Button(action: {
                    showingImageSourcePicker = true
                }) {
                    Label("Add Growth Photo", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("Swamp Green"))
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Stem visualization in a scrollable area
                ScrollView {
                    VStack {
                        // Stem and photos
                        ZStack(alignment: .bottom) {
                            // Stem line
                            Rectangle()
                                .fill(Color.green)
                                .frame(width: 8)
                                .padding(.bottom, 100) // Increased space for pot
                            
                            // Photos
                            VStack(spacing: 40) {
                                ForEach(plant.growthJournal.entries.sorted(by: { $0.dayNumber > $1.dayNumber })) { entry in
                                    Image(uiImage: UIImage(data: entry.imageData) ?? UIImage())
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 120, height: 120)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                        .shadow(radius: 5)
                                        .overlay(
                                            Text("Day \(entry.dayNumber)")
                                                .font(.caption)
                                                .padding(6)
                                                .background(Color.white.opacity(0.9))
                                                .cornerRadius(8),
                                            alignment: .top
                                        )
                                        .contextMenu {
                                            Button(action: {
                                                editingEntry = entry
                                                newEntryDayNumber = entry.dayNumber
                                                newEntryNotes = entry.notes
                                                showingEditEntrySheet = true
                                            }) {
                                                Label("Edit Day Number", systemImage: "pencil")
                                            }
                                            
                                            Button(role: .destructive, action: {
                                                if let index = plant.growthJournal.entries.firstIndex(where: { $0.id == entry.id }) {
                                                    plant.growthJournal.removeEntry(at: index)
                                                }
                                            }) {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                }
                            }
                            .padding(.bottom, 80) // Increased space for pot
                            
                            // Pot
                            Image(systemName: "square.fill")
                                .resizable()
                                .frame(width: 140, height: 100)
                                .foregroundColor(.brown)
                                .shadow(radius: 3)
                        }
                        .frame(minHeight: geometry.size.height - 100)
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 40)
                }
            }
        }
        .navigationTitle("Growth Journal for \(plant.name)")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddEntrySheet) {
            NavigationView {
                Form {
                    Section(header: Text("Photo")) {
                        if let selectedImageData,
                           let uiImage = UIImage(data: selectedImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 200)
                        } else {
                            Text("No photo selected")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Section(header: Text("Details")) {
                        TextField("Day Number", value: $newEntryDayNumber, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                        TextField("Notes (Optional)", text: $newEntryNotes)
                    }
                }
                .navigationTitle("New Growth Entry")
                .navigationBarItems(
                    leading: Button("Cancel") {
                        showingAddEntrySheet = false
                        selectedImageData = nil
                    },
                    trailing: Button("Save") {
                        if let imageData = selectedImageData {
                            // Check if there's already an entry for this day
                            if plant.growthJournal.entries.contains(where: { $0.dayNumber == newEntryDayNumber }) {
                                showingDuplicateDayAlert = true
                            } else {
                                plant.growthJournal.addEntry(
                                    imageData: imageData,
                                    dayNumber: newEntryDayNumber,
                                    notes: newEntryNotes
                                )
                                showingAddEntrySheet = false
                                selectedImageData = nil
                                newEntryNotes = ""
                                newEntryDayNumber = 1
                            }
                        }
                    }
                    .disabled(selectedImageData == nil)
                )
            }
        }
        .sheet(isPresented: $showingEditEntrySheet) {
            NavigationView {
                Form {
                    Section(header: Text("Details")) {
                        TextField("Day Number", value: $newEntryDayNumber, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                        TextField("Notes (Optional)", text: $newEntryNotes)
                    }
                }
                .navigationTitle("Edit Growth Entry")
                .navigationBarItems(
                    leading: Button("Cancel") {
                        showingEditEntrySheet = false
                    },
                    trailing: Button("Save") {
                        if let entry = editingEntry,
                           let index = plant.growthJournal.entries.firstIndex(where: { $0.id == entry.id }) {
                            // Check if there's already an entry for this day (excluding the current entry)
                            if plant.growthJournal.entries.contains(where: { $0.dayNumber == newEntryDayNumber && $0.id != entry.id }) {
                                showingDuplicateDayAlert = true
                            } else {
                                let updatedEntry = GrowthEntry(
                                    id: entry.id,
                                    date: entry.date,
                                    imageData: entry.imageData,
                                    dayNumber: newEntryDayNumber,
                                    notes: newEntryNotes
                                )
                                plant.growthJournal.entries[index] = updatedEntry
                                plant.growthJournal.entries.sort { $0.dayNumber < $1.dayNumber }
                                showingEditEntrySheet = false
                            }
                        }
                    }
                )
            }
        }
        .sheet(isPresented: $showingCamera) {
            ImagePicker(imageData: $selectedImageData, sourceType: .camera)
                .ignoresSafeArea()
        }
        .photosPicker(isPresented: $showingImagePicker, selection: $selectedItem, matching: .images)
        .confirmationDialog("Choose Photo Source", isPresented: $showingImageSourcePicker) {
            Button("Camera") {
                showingCamera = true
            }
            Button("Photo Library") {
                showingImagePicker = true
            }
            Button("Cancel", role: .cancel) {}
        }
        .alert("Duplicate Day", isPresented: $showingDuplicateDayAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("You can only have one photo per day. Please choose a different day number.")
        }
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    selectedImageData = data
                    showingAddEntrySheet = true
                }
            }
        }
        .onChange(of: selectedImageData) { newData in
            if newData != nil && !showingCamera {
                showingAddEntrySheet = true
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var imageData: Data?
    let sourceType: UIImagePickerController.SourceType
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.imageData = image.jpegData(compressionQuality: 0.8)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
} 