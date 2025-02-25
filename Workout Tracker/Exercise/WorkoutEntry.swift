//
//  WorkoutEntry.swift
//  Workout Tracker
//
//  Created by Joey on 09/02/2025.
//

import SwiftData
import Foundation

@Model
class WorkoutEntry {
    var name: String // Exercise name
    var weight: Double // Weight used
    var date: Date // Date performed
    var reps: Int // Optional: Track reps
    var sets: Int // Optional: Track sets
    var warmupWeight: Double
    var exerciseDescription: String
    var muscleGroup: String
    var alternativeExerciseName: String

    init(name: String, weight: Double, date: Date, reps: Int, sets: Int, warmupWeight: Double, exerciseDescription: String, muscleGroup: String, alternativeExerciseName: String) {
        self.name = name
        self.weight = weight
        self.date = date
        self.reps = reps
        self.sets = sets
        self.warmupWeight = warmupWeight
        self.exerciseDescription = exerciseDescription
        self.muscleGroup = muscleGroup
        self.alternativeExerciseName = alternativeExerciseName
    }
}

var bulgariansWorkoutEntry = WorkoutEntry(name: "Bulgarians", weight: 12, date: Date(), reps: 10, sets: 3, warmupWeight: 10, exerciseDescription: "Not so fun", muscleGroup: "Leg day", alternativeExerciseName: "")
