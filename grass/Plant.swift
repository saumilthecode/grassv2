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
    
    init(id: UUID = UUID(), name: String, scientificName: String, wateringFrequency: Int, wateringGuide: String, fertilisationFrequency: Int, fertilisationGuide: String, temperatureRangeBegin: Int, temperatureRangeEnd: Int, growthJournal: GrowthJournal = GrowthJournal()) {
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
        lhs.growthJournal == rhs.growthJournal
    }
} 