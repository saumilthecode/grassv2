//
//we were forced to write this code
//
//pls no copy
//
//made by tu madere 

import Foundation
import UIKit

struct Plant: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var scientificName: String
    var wateringFrequency: Int
    var wateringGuide: String
    var fertilisationFrequency: Int
    var fertilisationGuide: String
    var temperatureRangeBegin: Int
    var temperatureRangeEnd: Int
    var growthImages: [Data] = [] // Store images as Data
    
    // CodingKeys to handle the new property
    enum CodingKeys: String, CodingKey {
        case id, name, scientificName, wateringFrequency, wateringGuide
        case fertilisationFrequency, fertilisationGuide
        case temperatureRangeBegin, temperatureRangeEnd, growthImages
    }
}
