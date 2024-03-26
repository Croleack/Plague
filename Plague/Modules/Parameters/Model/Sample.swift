//
//  Sample.swift
//  Plague
//
//  Created by Enzhe Gaysina on 26.03.2024.
//

import Foundation

enum HealthStatus: Character {
    case healthy = "🏥"
    case infected = "☣︎"
}

struct Sample: Identifiable {
    let id = UUID()
    var healthStatus: HealthStatus
}
