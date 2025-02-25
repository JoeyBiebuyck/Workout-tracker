//
//  Exercise.swift
//  Workout Tracker
//
//  Created by Joey on 08/02/2025.
//

import Foundation
import SwiftUI
import SwiftData

@Model
class Exercise {
    
    var name: String
    //var image: String
    var lastDate: Date
    var weight: Double
    var warmupWeight: Double
    var reps: Int
    var sets: Int
    var exerciseDescription: String
    var muscleGroup: String
    var order: Int
    var alternativeExerciseName: String
    
    init(name: String, lastDate: Date, weight: Double,
         warmupWeight: Double,
         reps: Int, sets: Int, exerciseDescription: String, muscleGroup: String, order: Int = -1, alternativeExerciseName: String = "") {
        self.name = name
        //self.image = image
        self.lastDate = lastDate
        self.weight = weight
        self.warmupWeight = warmupWeight
        self.reps = reps
        self.sets = sets
        self.exerciseDescription = exerciseDescription
        self.muscleGroup = muscleGroup
        self.order = -1
        self.alternativeExerciseName = alternativeExerciseName
    }
}

var zotmanCurl: Exercise = Exercise(name: "Zotman Curl", lastDate: Date(), weight: 8.5,
                                    warmupWeight: 4.0,
                                    reps: 10, sets: 3, exerciseDescription: "weight is per dumbell", muscleGroup: "Pull day", alternativeExerciseName: "zlotman curl")
