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
    @State private var selectedIndex: Int = 0
    @State private var scrollOffset: CGFloat = 0
    
    private let cardWidth: CGFloat = 300
    private let cardHeight: CGFloat = 400
    private let cardSpacing: CGFloat = 20
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Add new entry button
                    Button(action: {
                        showingImageSourcePicker = true
                    }) {
                        Label("Add Photo", systemImage: "plus.circle.fill")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("Swamp Green"))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Time Machine-like card stack
                    ZStack {
                        ForEach(Array(plant.growthJournal.entries.sorted(by: { $0.dayNumber > $1.dayNumber }).enumerated()), id: \.element.id) { index, entry in
                            GrowthCard(entry: entry, plant: $plant)
                                .frame(width: cardWidth, height: cardHeight)
                                .offset(x: calculateOffset(for: index))
                                .scaleEffect(calculateScale(for: index))
                                .opacity(calculateOpacity(for: index))
                                .zIndex(Double(plant.growthJournal.entries.count - index))
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedIndex = index
                                    }
                                }
                        }
                    }
                    .frame(height: cardHeight + 100)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                scrollOffset = value.translation.width
                            }
                            .onEnded { value in
                                let threshold: CGFloat = 50
                                if value.translation.width > threshold && selectedIndex > 0 {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedIndex -= 1
                                    }
                                } else if value.translation.width < -threshold && selectedIndex < plant.growthJournal.entries.count - 1 {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedIndex += 1
                                    }
                                }
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    scrollOffset = 0
                                }
                            }
                    )
                    
                    // Scroll wheel indicator
                    HStack(spacing: 8) {
                        ForEach(0..<plant.growthJournal.entries.count, id: \.self) { index in
                            Circle()
                                .fill(index == selectedIndex ? Color("Swamp Green") : Color.gray.opacity(0.3))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.bottom)
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
    
    private func calculateOffset(for index: Int) -> CGFloat {
        let baseOffset = CGFloat(index - selectedIndex) * (cardWidth + cardSpacing)
        return baseOffset + scrollOffset
    }
    
    private func calculateScale(for index: Int) -> CGFloat {
        let distance = abs(index - selectedIndex)
        return max(1.0 - CGFloat(distance) * 0.1, 0.8)
    }
    
    private func calculateOpacity(for index: Int) -> Double {
        let distance = abs(index - selectedIndex)
        return max(1.0 - Double(distance) * 0.3, 0.0)
    }
}

struct GrowthCard: View {
    let entry: GrowthEntry
    @Binding var plant: Plant
    @State private var showingEditSheet = false
    @State private var editingDayNumber: Int
    @State private var editingNotes: String
    @State private var showingDuplicateDayAlert = false
    
    init(entry: GrowthEntry, plant: Binding<Plant>) {
        self.entry = entry
        self._plant = plant
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
                    Section(header: Text("Details")) {
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
                                let updatedEntry = GrowthEntry(
                                    id: entry.id,
                                    date: entry.date,
                                    imageData: entry.imageData,
                                    dayNumber: editingDayNumber,
                                    notes: editingNotes
                                )
                                plant.growthJournal.entries[index] = updatedEntry
                                plant.growthJournal.entries.sort { $0.dayNumber < $1.dayNumber }
                                showingEditSheet = false
                            }
                        }
                    }
                )
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
