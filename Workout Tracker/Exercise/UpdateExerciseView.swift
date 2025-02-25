//
//  UpdateExerciseView.swift
//  Workout Tracker
//
//  Created by Joey on 08/02/2025.
//

import SwiftUI
import SwiftData

struct UpdateExerciseView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    
    @Query private var muscleGroups: [MuscleGroup]
    
    @State private var textHeight: CGFloat = 15 // Default height
    @Bindable var exercise: Exercise
    
    var body: some View {
        NavigationStack {
            ScrollView { // Using ScrollView for better UX
                VStack(spacing: 16) {
                    // Auto-resizing text editor for description
                    AutoResizingTextEditor(
                        text: $exercise.exerciseDescription,
                        placeholder: "Write a short description..."
                    )
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    
                    // warmup weight
                    CustomInputField(title: "Warm-up weight", value: $exercise.warmupWeight, suffix: "kg")
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                    // weight
                    CustomInputField(title: "Weight", value: $exercise.weight, suffix: "kg")
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                    // Date Picker
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Date")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack {
                            DatePicker("", selection: $exercise.lastDate, displayedComponents: .date)
                                .labelsHidden()
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(UIColor.secondarySystemBackground))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                            
                            Button(action: {
                                exercise.lastDate = Date()
                            }) {
                                Text("Now")
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .padding(.leading, 8)
                        }
                    }
                    
                    // Rep field
                    CustomInputField(title: "Reps", value: $exercise.reps, suffix: "reps")
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                    // Sets field
                    CustomInputField(title: "Sets", value: $exercise.sets, suffix: "sets")
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                    // Exercise Name Input
                    CustomTextField(placeholder: "Exercise name", text: $exercise.name)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                    // Alternative name input
                    CustomTextField(placeholder: "Alternative name", text: $exercise.alternativeExerciseName)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                    // Muscle Group Picker
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Muscle Group")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .font(.headline)
                            .foregroundColor(.primary)

                        Picker("Select Muscle Group", selection: $exercise.muscleGroup) {
                            Text("Not selected").tag("").foregroundColor(.gray)
                            ForEach(muscleGroups, id: \.self) { muscle in
                                Text(muscle.name).tag(muscle.name)
                            }
                        }
                        .pickerStyle(.menu) // Modern dropdown style
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                    
//                        // Save Button
//                        Button(action: {
//                            let exercise = Exercise(
//                                name: name,
//                                lastDate: date,
//                                weight: weight,
//                                reps: reps,
//                                sets: sets,
//                                exerciseDescription: exerciseDescription,
//                                muscleGroup: muscleGroup
//                            )
//                            context.insert(exercise)
//                            dismiss()
//                        }) {
//                            Text("Save")
//                                .font(.headline)
//                                .foregroundColor(.white)
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(name.isEmpty ? Color.gray : Color.blue)
//                                .cornerRadius(10)
//                        }
//                        .disabled(name.isEmpty) // Prevent saving if name is empty
                }
                .padding()
            }
            .navigationTitle("Updating " + exercise.name.lowercased())
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Done") {
                        let workoutEntry = WorkoutEntry(
                            name: exercise.name,
                            weight: exercise.weight.isFinite ? exercise.weight : 0, // Prevents NaN/infinite weights
                            date: exercise.lastDate,
                            reps: max(0, exercise.reps),  // Prevents negative reps
                            sets: max(0, exercise.sets),   // Prevents negative sets
                            warmupWeight: exercise.warmupWeight,
                            exerciseDescription: exercise.exerciseDescription,
                            muscleGroup: exercise.muscleGroup,
                            alternativeExerciseName: exercise.alternativeExerciseName
                        ) // save a new entry every time you update the workout
                        print("Saving Workout Entry - Name: \(exercise.name), Weight: \(exercise.weight), Date: \(exercise.lastDate), Reps: \(exercise.reps), Sets: \(exercise.sets)")
                        context.insert(workoutEntry)
                        dismiss() }
                }
            }
        }
    }
}

#Preview {
    UpdateExerciseView(exercise: zotmanCurl)
}
