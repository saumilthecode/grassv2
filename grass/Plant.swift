//
//  Plant.swift
//  grass
//
//  Created by Saumil Anand on 9/6/25.
//


import Foundation

struct Plant: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var scientificName: String
    var wateringFrequency: Int
    var wateringGuide: String
    var fertilisationFrequency: Int
    var fertilisationGuide: String
    var temperatureRangeBegin: Int
    var temperatureRangeEnd: Int
    var growthJournal: GrowthJournal
    var isDead: Bool
    var dateOfDeath: Date?
    var obituary: String?
    
    init(id: UUID = UUID(), name: String, scientificName: String, wateringFrequency: Int, wateringGuide: String, fertilisationFrequency: Int, fertilisationGuide: String, temperatureRangeBegin: Int, temperatureRangeEnd: Int, growthJournal: GrowthJournal = GrowthJournal(), isDead: Bool = false, dateOfDeath: Date? = nil, obituary: String? = nil) {
        self.id = id
        self.name = name
        self.scientificName = scientificName
        self.wateringFrequency = wateringFrequency
        self.wateringGuide = wateringGuide
        self.fertilisationFrequency = fertilisationFrequency
        self.fertilisationGuide = fertilisationGuide
        self.temperatureRangeBegin = temperatureRangeBegin
        self.temperatureRangeEnd = temperatureRangeEnd
        self.growthJournal = growthJournal
        self.isDead = isDead
        self.dateOfDeath = dateOfDeath
        self.obituary = obituary
    }
    
    static func == (lhs: Plant, rhs: Plant) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.scientificName == rhs.scientificName &&
        lhs.wateringFrequency == rhs.wateringFrequency &&
        lhs.wateringGuide == rhs.wateringGuide &&
        lhs.fertilisationFrequency == rhs.fertilisationFrequency &&
        lhs.fertilisationGuide == rhs.fertilisationGuide &&
        lhs.temperatureRangeBegin == rhs.temperatureRangeBegin &&
        lhs.temperatureRangeEnd == rhs.temperatureRangeEnd &&
        lhs.growthJournal == rhs.growthJournal &&
        lhs.isDead == rhs.isDead &&
        lhs.dateOfDeath == rhs.dateOfDeath &&
        lhs.obituary == rhs.obituary
    }
} 
