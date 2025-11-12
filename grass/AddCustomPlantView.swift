//
//  AddCustomPlantView.swift
//  grass
//
//  Created by James Kuang on 29/10/22.
//
//
//we were forced to write this code
//
//pls no copy
//
//made by tu madere

import UserNotifications
import SwiftUI

struct AddCustomPlantView: View {
    
    @State var plantName: String = ""
    @State var scienceName: String = ""
    @State var minTemp: Int = 0
    @State var maxTemp: Int = 0
    @State var waterFreq: Int = 0
    @State var fertFreq: Int = 0
    @State var waterInstruct: String = ""
    @State var fertInstruct: String = ""
    @Binding var plants: [Plant]
    var isOnboarding: Bool = false
    var onPlantAdded: (() -> Void)? = nil
    
    @Environment(\.dismiss) var dismiss
    
    // Validation states
    @State private var isNameValid = false
    @State private var isTempRangeValid = false
    @State private var isWaterFreqValid = false
    @State private var isFertFreqValid = false
    @State private var showValidationAlert = false
    
    private var isFormValid: Bool {
        isNameValid && isTempRangeValid && isWaterFreqValid && isFertFreqValid
    }
    
    private var validationMessage: String {
        var messages: [String] = []
        if !isNameValid { messages.append("Plant Name") }
        if !isTempRangeValid { messages.append("Valid Temperature Range") }
        if !isWaterFreqValid { messages.append("Watering Frequency)") }
        if !isFertFreqValid { messages.append("Fertilisation Frequency") }
        return messages.joined(separator: "\n")
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Form {
                Section(header: Text("Basic Details")) {
                    TextField("Plant Name", text: $plantName)
                        .onChange(of: plantName) { newValue in
                            isNameValid = !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        }
                        .foregroundColor(isNameValid ? .primary : .black)
                    TextField("Scientific Name (Optional)", text: $scienceName)
                }
                Section(header: Text("Habitat")) {
                    HStack {
                        Text("Minimum Temperature")
                        TextField("", value: $minTemp, formatter: NumberFormatter())
                            .frame(width: 50)
                            .padding(.leading)
                        Text("˚C")
                        Spacer()
                        Stepper(value: $minTemp, in: -20...40) {
                            EmptyView()
                        }
                    }
                    .padding(.trailing, 8)
                    HStack {
                        Text("Maximum Temperature")
                        TextField("", value: $maxTemp, formatter: NumberFormatter())
                            .frame(width: 50)
                            .padding(.leading)
                        Text("˚C")
                        Spacer()
                        Stepper(value: $maxTemp, in: -19...41) {
                            EmptyView()
                        }
                    }
                    .padding(.trailing, 8)
                    .onChange(of: minTemp) { _ in validateTempRange() }
                    .onChange(of: maxTemp) { _ in validateTempRange() }
                }
                Section(header: Text("Watering")) {
                    HStack {
                        Text("Frequency")
                        TextField("", value: $waterFreq, formatter: NumberFormatter())
                            .frame(width: 50)
                            .padding(.leading)
                        Text("days")
                        Spacer()
                        Stepper(value: $waterFreq, in: 1...30) {
                            EmptyView()
                        }
                    }
                    .padding(.trailing, 8)
                    .onChange(of: waterFreq) { newValue in
                        isWaterFreqValid = newValue >= 1 && newValue <= 100
                    }
                    TextField("Watering Instructions (Optional)", text: $waterInstruct)
                }
                Section(header: Text("Fertilisation")) {
                    HStack {
                        Text("Frequency")
                        TextField("", value: $fertFreq, formatter: NumberFormatter())
                            .frame(width: 50)
                            .padding(.leading)
                        Text("days")
                        Spacer()
                        Stepper(value: $fertFreq, in: 1...8) {
                            EmptyView()
                        }
                    }
                    .padding(.trailing, 8)
                    .onChange(of: fertFreq) { newValue in
                        isFertFreqValid = newValue >= 1 && newValue <= 100
                    }
                    TextField("Fertilisation Instructions (Optional)", text: $fertInstruct)
                }
                Button("Save") {
                    if isFormValid {
                        savePlant()
                    } else {
                        showValidationAlert = true
                    }
                }
            }
            .modifier(TopFormInset())
        }
        .navigationTitle(isOnboarding ? "Add Your First Plant" : "")
        .alert("Required Fields", isPresented: $showValidationAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please fill in the following fields:\n\n\(validationMessage)")
        }
    }
    
    private func validateTempRange() {
        isTempRangeValid = maxTemp > minTemp
    }
    
    private func savePlant() {
        let plant = Plant(
            name: plantName.trimmingCharacters(in: .whitespacesAndNewlines),
            scientificName: scienceName.trimmingCharacters(in: .whitespacesAndNewlines),
            wateringFrequency: waterFreq,
            wateringGuide: waterInstruct,
            fertilisationFrequency: fertFreq,
            fertilisationGuide: fertInstruct,
            temperatureRangeBegin: minTemp,
            temperatureRangeEnd: maxTemp
        )
        
        plants.append(plant)
        // Notifications will be scheduled automatically by PlantManager's didSet
        onPlantAdded?()
        dismiss()
    }
}

private struct TopFormInset: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content
                .contentMargins(.top, 20, for: .scrollContent)
        } else {
            content
                .padding(.top, 20)
        }
    }
}

struct AddCustomPlantView_Previews: PreviewProvider {
    static var previews: some View {
        AddCustomPlantView(plants: .constant([]))
    }
}
