//
//  WorkoutDetailView.swift
//  Workout Tracker
//
//  Created by Joey on 09/02/2025.
//

import SwiftUI
import SwiftData

struct WorkoutDetailView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    
    @Query private var muscleGroups: [MuscleGroup]
    
    @State private var textHeight: CGFloat = 15 // Default height
    @Bindable var workout: WorkoutEntry

    // Store a copy of the original workout for change detection
    @State private var originalWorkout: WorkoutEntry

    init(workout: WorkoutEntry) {
        self.workout = workout
        self._originalWorkout = State(initialValue: workout) // Copy original values for comparison
    }

    // Detects if any changes were made
    var hasChanges: Bool {
        return workout.name != originalWorkout.name ||
               workout.date != originalWorkout.date ||
               workout.weight != originalWorkout.weight ||
               workout.warmupWeight != originalWorkout.warmupWeight ||
               workout.reps != originalWorkout.reps ||
               workout.sets != originalWorkout.sets ||
               workout.exerciseDescription != originalWorkout.exerciseDescription ||
               workout.muscleGroup != originalWorkout.muscleGroup
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Auto-resizing text editor for description
                    AutoResizingTextEditor(
                        text: $workout.exerciseDescription,
                        placeholder: "Write a short description..."
                    )
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )

                    // warmup weight
                    CustomInputField(title: "Warm-up weight", value: $workout.warmupWeight, suffix: "kg")
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                    // weight
                    CustomInputField(title: "Weight", value: $workout.weight, suffix: "kg")
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                    // reps
                    CustomInputField(title: "Reps", value: $workout.reps, suffix: "reps")
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                    // sets
                    CustomInputField(title: "Sets", value: $workout.sets, suffix: "sets")
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                    // Date picker
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Date")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        DatePicker("", selection: $workout.date, displayedComponents: .date)
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    // Exercise name input
                    CustomTextField(placeholder: "Exercise name", text: $workout.name)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )

                    // Muscle group picker
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Muscle Group")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .font(.headline)
                            .foregroundColor(.primary)

                        Picker("Select Muscle Group", selection: $workout.muscleGroup) {
                            Text("Not selected").tag("").foregroundColor(.gray)
                            ForEach(muscleGroups, id: \.self) { muscle in
                                Text(muscle.name).tag(muscle.name)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }

//                    // Update button
//                    Button(action: {
//                        if hasChanges {
//                            try? context.save() // save to swift data
//                        }
//                        dismiss()
//                    }) {
//                        Text("Update")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(hasChanges ? Color.blue : Color.gray)
//                            .cornerRadius(10)
//                    }
//                    .disabled(!hasChanges) // prevents updating if no changes were made
                }
                .padding()
            }
            .navigationTitle("Updating Workout")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Done") { dismiss() } // Done button should dismiss without saving (it still saves)
                }
            }
        }
    }
}

#Preview {
    WorkoutDetailView(workout: bulgariansWorkoutEntry)
}
