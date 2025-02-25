import SwiftUI
import SwiftData

struct AddExerciseSheet: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    
    var inMuscleGroup: String
    
    @Query private var muscleGroups: [MuscleGroup]
    
    @State private var name: String = ""
    @State private var date: Date = .now
    @State private var exerciseDescription: String = ""
    @State private var weight: Double = 0.0
    @State private var warmupWeight: Double = 0.0
    @State private var reps: Int = 10
    @State private var sets: Int = 3
    @State private var muscleGroup: String = ""
    @State private var alternativeExerciseName: String = ""
    @State private var textHeight: CGFloat = 15
    
    init(inMuscleGroup: String) {
        self.inMuscleGroup = inMuscleGroup
        _muscleGroup = State(initialValue: inMuscleGroup)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Exercise Name Input
                    CustomTextField(placeholder: "Exercise name", text: $name)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                    // Altnernative Exercise Name
                    CustomTextField(placeholder: "Alternative name", text: $alternativeExerciseName)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )

                    // Auto-Resizing TextEditor for Description
                    AutoResizingTextEditor(
                        text: $exerciseDescription,
                        placeholder: "Write a short description..."
                    )
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    
                    // Weight, Reps, Sets Fields
                    CustomInputField(title: "Warm-up weight", value: $warmupWeight, suffix: "kg")
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                    CustomInputField(title: "Weight", value: $weight, suffix: "kg")
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                    CustomInputField(title: "Reps", value: $reps, suffix: "reps")
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                    CustomInputField(title: "Sets", value: $sets, suffix: "sets")
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
                        
                        DatePicker("", selection: $date, displayedComponents: .date)
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    // Muscle Group Picker
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Muscle Group")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .font(.headline)
                            .foregroundColor(.primary)

                        Picker("Select Muscle Group", selection: $muscleGroup) {
                            Text("Not selected").tag("").foregroundColor(.gray)
                            ForEach(muscleGroups, id: \.self) { muscle in
                                Text(muscle.name).tag(muscle.name)
                            }
                        }
                        .pickerStyle(.menu)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("New exercise")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        let exercise = Exercise(name: name, lastDate: date, weight: weight,
                                             warmupWeight: warmupWeight,
                                                reps: reps, sets: sets, exerciseDescription: exerciseDescription, muscleGroup: muscleGroup, alternativeExerciseName: alternativeExerciseName)
                        let workoutEntry = WorkoutEntry(
                            name: exercise.name,
                            weight: exercise.weight.isFinite ? exercise.weight : 0,
                            date: exercise.lastDate,
                            reps: max(0, exercise.reps),
                            sets: max(0, exercise.sets),
                            warmupWeight: exercise.warmupWeight,
                            exerciseDescription: exercise.exerciseDescription,
                            muscleGroup: exercise.muscleGroup,
                            alternativeExerciseName: exercise.alternativeExerciseName
                        )
                        context.insert(exercise)
                        context.insert(workoutEntry)
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddExerciseSheet(inMuscleGroup: "Leg day")
}
