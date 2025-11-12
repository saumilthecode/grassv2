//
//  PlantPuns.swift
//  grass
//
//  Plant puns for humor throughout the app
//

import Foundation

struct PlantPuns {
    static let generalPuns = [
        "You're doing great! Keep up the good work!",
        "Your plants are rooting for you!",
        "Don't leaf your plants hanging!",
        "You're a stem-azing plant parent!",
        "Time to branch out and water your plants!",
        "Your green thumb is showing!",
        "You're really growing as a plant parent!",
        "Don't be a sap, water your plants!",
        "You're blooming with potential!",
        "Keep calm and plant on!",
        "You're petal-ing in the right direction!",
        "Your plants think you're un-be-leaf-able!",
        "You're really branching out!",
        "Don't forget to water - your plants are thirsty!",
        "You're doing a great job - your plants are thriving!",
        "Time to fertilize - your plants are hungry!",
        "You're a natural at this!",
        "Your plants are so lucky to have you!",
        "Keep up the excellent work!",
        "You're making your plants very happy!"
    ]
    
    static let wateringPuns = [
        "Time to water! Don't be a drip about it!",
        "Your plant is thirsty - time to hydrate!",
        "Water you waiting for? Time to water!",
        "Don't leaf your plant high and dry!",
        "It's watering time - your plant needs a drink!",
        "H2-oh no! Time to water your plant!",
        "Your plant is parched - give it a drink!",
        "Water you doing? Watering your plant, of course!",
        "Time to make it rain for your plant!",
        "Your plant is thirsty - don't keep it waiting!"
    ]
    
    static let fertilizingPuns = [
        "Time to fertilize! Your plant is hungry!",
        "Feed your plant - it's meal time!",
        "Your plant needs nutrients - time to fertilize!",
        "Don't let your plant go hungry - fertilize now!",
        "Time to give your plant some plant food!",
        "Your plant is hungry - feed it well!",
        "Fertilize your plant - it's snack time!",
        "Your plant needs nutrients - don't keep it waiting!",
        "Time to nourish your plant!",
        "Feed your plant - it's growing time!"
    ]
    
    static func randomGeneralPun() -> String {
        generalPuns.randomElement() ?? "Keep up the good work!"
    }
    
    static func randomWateringPun() -> String {
        wateringPuns.randomElement() ?? "Time to water your plant!"
    }
    
    static func randomFertilizingPun() -> String {
        fertilizingPuns.randomElement() ?? "Time to fertilize your plant!"
    }
}

