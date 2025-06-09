//
//  GrowthJournel.swift
//  grass
//
//  Created by Saumil Anand on 9/6/25.
//


import Foundation
import SwiftUI

struct GrowthEntry: Identifiable, Codable, Equatable {
    let id: UUID
    let date: Date
    let imageData: Data
    let dayNumber: Int
    let notes: String
    
    init(id: UUID = UUID(), date: Date = Date(), imageData: Data, dayNumber: Int, notes: String = "") {
        self.id = id
        self.date = date
        self.imageData = imageData
        self.dayNumber = dayNumber
        self.notes = notes
    }
    
    static func == (lhs: GrowthEntry, rhs: GrowthEntry) -> Bool {
        lhs.id == rhs.id &&
        lhs.date == rhs.date &&
        lhs.imageData == rhs.imageData &&
        lhs.dayNumber == rhs.dayNumber &&
        lhs.notes == rhs.notes
    }
}

struct GrowthJournal: Identifiable, Codable, Equatable {
    let id: UUID
    var entries: [GrowthEntry]
    
    init(id: UUID = UUID(), entries: [GrowthEntry] = []) {
        self.id = id
        self.entries = entries
    }
    
    mutating func addEntry(imageData: Data, dayNumber: Int, notes: String = "") {
        let entry = GrowthEntry(imageData: imageData, dayNumber: dayNumber, notes: notes)
        entries.append(entry)
        entries.sort { $0.dayNumber < $1.dayNumber }
    }
    
    mutating func removeEntry(at index: Int) {
        entries.remove(at: index)
    }
    
    static func == (lhs: GrowthJournal, rhs: GrowthJournal) -> Bool {
        lhs.id == rhs.id && lhs.entries == rhs.entries
    }
} 
