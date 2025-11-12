//
//  GrowthTrackerView.swift
//  grass
//
//  Created by Saumil Anand on 9/6/25.
//


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
    // Removed card stack state
    
    // Removed card stack layout constants
    
    // Ladder is the only/default view
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Add button
                    HStack {
                        Spacer()
                        Button(action: {
                            showingImageSourcePicker = true
                        }) {
                            Label("Add Photo", systemImage: "plus.circle.fill")
                                .font(.headline)
                                .padding()
                                .background(Color("Swamp Green"))
                                .foregroundColor(.white)
                                .cornerRadius(15)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)

                    GrowthLadderView(plant: $plant)
                }
            }
        }
        .navigationTitle("Growth Journal")
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
                            .onChange(of: newEntryDayNumber) { newValue in
                                if newValue < 1 {
                                    newEntryDayNumber = 1
                                }
                            }
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
                            .onChange(of: newEntryDayNumber) { newValue in
                                if newValue < 1 {
                                    newEntryDayNumber = 1
                                }
                            }
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
    
    // Removed card stack calculations
}

struct GrowthLadderView: View {
    @Binding var plant: Plant
    @State private var showingEditSheet = false
    @State private var editingEntry: GrowthEntry?
    @State private var editingDate: Date = Date()
    @State private var editingDayNumber: Int = 1
    @State private var editingNotes: String = ""
    @State private var showingDuplicateDayAlert = false
    @State private var showingPhotoPicker = false
    @State private var photoPickerSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var newImageData: Data?
    
    var sortedEntries: [GrowthEntry] {
        plant.growthJournal.entries.sorted { $0.dayNumber < $1.dayNumber }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(Array(sortedEntries.enumerated()), id: \.element.id) { index, entry in
                    HStack(alignment: .top, spacing: 16) {
                        // Day number and line
                        VStack(spacing: 0) {
                            Text("Day")
                                .font(.caption2)
                                .foregroundColor(.gray)
                            Text("\(entry.dayNumber)")
                                .font(.headline)
                                .foregroundColor(Color("Swamp Green"))
                                .frame(width: 50, height: 50)
                                .background(Color("Swamp Green").opacity(0.1))
                                .clipShape(Circle())
                            
                            if index < sortedEntries.count - 1 {
                                Rectangle()
                                    .fill(Color("Swamp Green").opacity(0.3))
                                    .frame(width: 2)
                                    .frame(maxHeight: .infinity)
                            }
                        }
                        .frame(width: 60)
                        
                        // Plant image
                        if let uiImage = UIImage(data: entry.imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color("Swamp Green").opacity(0.3), lineWidth: 2)
                                )
                                .liquidGlass(cornerRadius: 12, opacity: 0.05)
                        }
                        
                        // Entry details
                        VStack(alignment: .leading, spacing: 4) {
                            Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            if !entry.notes.isEmpty {
                                Text(entry.notes)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            } else {
                                Text("Growth milestone")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .italic()
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .contextMenu {
                        Button(action: {
                            editingEntry = entry
                            editingDate = entry.date
                            editingDayNumber = entry.dayNumber
                            editingNotes = entry.notes
                            showingEditSheet = true
                        }) {
                            Label("Edit", systemImage: "pencil")
                        }
                        
                        Button(role: .destructive, action: {
                            if let entryIndex = plant.growthJournal.entries.firstIndex(where: { $0.id == entry.id }) {
                                plant.growthJournal.removeEntry(at: entryIndex)
                            }
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    
                    if index < sortedEntries.count - 1 {
                        Divider()
                            .padding(.leading, 60)
                    }
                }
            }
            .padding(.vertical)
        }
        .sheet(isPresented: $showingEditSheet) {
            NavigationView {
                Form {
                    if let entry = editingEntry, let uiImage = UIImage(data: newImageData ?? entry.imageData) {
                        Section(header: Text("Photo")) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 200)
                            HStack {
                                Button("Change Photo") {
                                    photoPickerSource = .photoLibrary
                                    showingPhotoPicker = true
                                }
                                Spacer()
                                Button("Use Camera") {
                                    photoPickerSource = .camera
                                    showingPhotoPicker = true
                                }
                            }
                        }
                    }
                    Section(header: Text("Details")) {
                        DatePicker("Date & Time", selection: $editingDate, displayedComponents: [.date, .hourAndMinute])
                        
                        TextField("Day Number", value: $editingDayNumber, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .onChange(of: editingDayNumber) { newValue in
                                if newValue < 1 {
                                    editingDayNumber = 1
                                }
                            }
                        TextField("Notes (Optional)", text: $editingNotes)
                    }
                }
                .navigationTitle("Edit Growth Entry")
                .navigationBarItems(
                    leading: Button("Cancel") {
                        showingEditSheet = false
                        editingEntry = nil
                    },
                    trailing: Button("Save") {
                        if let entry = editingEntry,
                           let index = plant.growthJournal.entries.firstIndex(where: { $0.id == entry.id }) {
                            if plant.growthJournal.entries.contains(where: { $0.dayNumber == editingDayNumber && $0.id != entry.id }) {
                                showingDuplicateDayAlert = true
                            } else {
                                var updatedEntry = entry
                                updatedEntry.date = editingDate
                                updatedEntry.dayNumber = editingDayNumber
                                updatedEntry.notes = editingNotes
                                if let data = newImageData {
                                    updatedEntry.imageData = data
                                }
                                plant.growthJournal.entries[index] = updatedEntry
                                plant.growthJournal.entries.sort { $0.dayNumber < $1.dayNumber }
                                showingEditSheet = false
                                editingEntry = nil
                                newImageData = nil
                            }
                        }
                    }
                )
            }
            .sheet(isPresented: $showingPhotoPicker) {
                ImagePicker(imageData: $newImageData, sourceType: photoPickerSource)
                    .ignoresSafeArea()
            }
        }
        .alert("Duplicate Day", isPresented: $showingDuplicateDayAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("You can only have one photo per day. Please choose a different day number.")
        }
    }
}

struct GrowthCard: View {
    let entry: GrowthEntry
    @Binding var plant: Plant
    @State private var showingEditSheet = false
    @State private var editingDate: Date
    @State private var editingDayNumber: Int
    @State private var editingNotes: String
    @State private var showingDuplicateDayAlert = false
    @State private var showingPhotoPicker = false
    @State private var photoPickerSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var newImageData: Data?
    
    init(entry: GrowthEntry, plant: Binding<Plant>) {
        self.entry = entry
        self._plant = plant
        self._editingDate = State(initialValue: entry.date)
        self._editingDayNumber = State(initialValue: entry.dayNumber)
        self._editingNotes = State(initialValue: entry.notes)
    }
    
    var body: some View {
        VStack {
            if let uiImage = UIImage(data: entry.imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 280, height: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Day \(entry.dayNumber)")
                    .font(.headline)
                
                if !entry.notes.isEmpty {
                    Text(entry.notes)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .frame(width: 300, height: 400)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .liquidGlass(cornerRadius: 20, opacity: 0.1)
        .shadow(radius: 10)
        .contextMenu {
            Button(action: {
                showingEditSheet = true
            }) {
                Label("Edit", systemImage: "pencil")
            }
            
            Button(role: .destructive, action: {
                if let index = plant.growthJournal.entries.firstIndex(where: { $0.id == entry.id }) {
                    plant.growthJournal.removeEntry(at: index)
                }
            }) {
                Label("Delete", systemImage: "trash")
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            NavigationView {
                Form {
                    if let uiImage = UIImage(data: newImageData ?? entry.imageData) {
                        Section(header: Text("Photo")) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 200)
                            HStack {
                                Button("Change Photo") {
                                    photoPickerSource = .photoLibrary
                                    showingPhotoPicker = true
                                }
                                Spacer()
                                Button("Use Camera") {
                                    photoPickerSource = .camera
                                    showingPhotoPicker = true
                                }
                            }
                        }
                    }
                    Section(header: Text("Details")) {
                        DatePicker("Date & Time", selection: $editingDate, displayedComponents: [.date, .hourAndMinute])
                        
                        TextField("Day Number", value: $editingDayNumber, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .onChange(of: editingDayNumber) { newValue in
                                if newValue < 1 {
                                    editingDayNumber = 1
                                }
                            }
                        TextField("Notes (Optional)", text: $editingNotes)
                    }
                }
                .navigationTitle("Edit Growth Entry")
                .navigationBarItems(
                    leading: Button("Cancel") {
                        showingEditSheet = false
                    },
                    trailing: Button("Save") {
                        if let index = plant.growthJournal.entries.firstIndex(where: { $0.id == entry.id }) {
                            if plant.growthJournal.entries.contains(where: { $0.dayNumber == editingDayNumber && $0.id != entry.id }) {
                                showingDuplicateDayAlert = true
                            } else {
                                var updatedEntry = entry
                                updatedEntry.date = editingDate
                                updatedEntry.dayNumber = editingDayNumber
                                updatedEntry.notes = editingNotes
                                if let data = newImageData {
                                    updatedEntry.imageData = data
                                }
                                plant.growthJournal.entries[index] = updatedEntry
                                plant.growthJournal.entries.sort { $0.dayNumber < $1.dayNumber }
                                showingEditSheet = false
                                newImageData = nil
                            }
                        }
                    }
                )
            }
            .sheet(isPresented: $showingPhotoPicker) {
                ImagePicker(imageData: $newImageData, sourceType: photoPickerSource)
                    .ignoresSafeArea()
            }
        }
        .alert("Duplicate Day", isPresented: $showingDuplicateDayAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("You can only have one photo per day. Please choose a different day number.")
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
