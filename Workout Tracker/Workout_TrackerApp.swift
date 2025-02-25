//
//  Workout_TrackerApp.swift
//  Workout Tracker
//
//  Created by Joey on 08/02/2025.
//

import SwiftUI

@main
struct Workout_TrackerApp: App {
       var body: some Scene {
           WindowGroup {
               HomeScreen()
           }
           .modelContainer(for: [Exercise.self, MuscleGroup.self, WorkoutEntry.self]) // establish which container is used in this hierarchy
       }
}
