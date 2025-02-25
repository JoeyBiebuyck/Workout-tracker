//
//  MuscleGroup.swift
//  Workout Tracker
//
//  Created by Joey on 08/02/2025.
//

import SwiftUI
import SwiftData

@Model
class MuscleGroup {
    var name: String
    var groupDescription: String
    var lastDate: Date
    var order: Int // Add this for tracking position
    
    init(name: String, groupDescription: String, lastDate: Date, order: Int = -1) {
        self.name = name
        self.groupDescription = groupDescription
        self.lastDate = lastDate
        self.order = -1 // Default value, will be set properly when added
    }
}

var pullDay: MuscleGroup = MuscleGroup(name: "Pull Day", groupDescription: "A very pleasant day", lastDate: Date())
