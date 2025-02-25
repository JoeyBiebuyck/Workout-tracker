//
//  MuscleGroupView.swift
//  Workout Tracker
//
//  Created by Joey on 08/02/2025.
//

import SwiftUI
import SwiftData

struct MuscleGroupView: View {
    @Environment(\.modelContext) private var context
    @State private var isShowingItemSheet = false
    @State var currentMuscleGroup: MuscleGroup

    // Fetch all exercises without filtering
    @Query(sort: \Exercise.order) private var allExercises: [Exercise]
    
    // filter so only the correct exercises get shown
    private var exercises: [Exercise] {
        allExercises.filter { $0.muscleGroup == currentMuscleGroup.name }
    }

    @State private var exerciseToEdit: Exercise?
    @State private var exerciseToInspect: Exercise?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(exercises) { exercise in
                    NavigationLink(destination: ExerciseView(exercise: exercise)) {
                        HStack {
                            Image(systemName: "line.3.horizontal")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                            
                            ExerciseRow(exercise: exercise)
                            
                            Spacer()
                            
                            // Wrap the pencil in a Button and use simultaneousGesture
                            Button {
                                exerciseToEdit = exercise
                            } label: {
                                Image(systemName: "pencil")
                                    .foregroundColor(.blue)
                            }
                            .simultaneousGesture(TapGesture().map { _ in
                                // Prevent navigation when tapping the pencil
                                exerciseToEdit = exercise
                            })
                        }
                        .padding(.vertical, 5)
                    }
                }
                .onMove(perform: moveExercises)
                .onDelete(perform: deleteExercises)
            }
            .listStyle(.plain)
            .navigationTitle(currentMuscleGroup.name)
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isShowingItemSheet) { AddExerciseSheet(inMuscleGroup: currentMuscleGroup.name) }
            .sheet(item: $exerciseToEdit) { exercise in
                UpdateExerciseView(exercise: exercise)
            }
            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    EditButton()
//                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        EditButton()
                        if !exercises.isEmpty {
                            Button {
                                isShowingItemSheet = true
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
            }
            .overlay {
                if exercises.isEmpty {
                    ContentUnavailableView(
                        label: {
                            Label("No exercises", systemImage: "list.bullet.rectangle.portrait")
                        },
                        description: {
                            Text("Add exercises to see them listed")
                        },
                        actions: {
                            Button("Add exercises") {
                                isShowingItemSheet = true
                            }
                        }
                    )
                }
            }
        }
    }
    
    private func moveExercises(from source: IndexSet, to destination: Int) {
           // Get the items being moved
        let itemsToMove = source.map { exercises[$0] }
           
           // Create a copy of the current order
        var updatedExercises = exercises.map { $0 }
        updatedExercises.move(fromOffsets: source, toOffset: destination)
           
           // Update all orders to match new positions
           for (index, exercise) in updatedExercises.enumerated() {
               exercise.order = index
           }
           
           try? context.save()
       }
    
    private func deleteExercises(at offsets: IndexSet) {
        withAnimation {
            // Delete the items
            for index in offsets {
                context.delete(exercises[index])
            }
            
            // Reorder remaining items to ensure no gaps
            let remainingExercises = exercises.filter { !offsets.contains(exercises.firstIndex(of: $0) ?? -1) }
            for (index, exercise) in remainingExercises.enumerated() {
                exercise.order = index
            }
            
            try? context.save()
        }
    }
    
    /// Handles moving exercises in the list
    private func reorderExercises() {
        // Ensure consistent ordering after deletions
        for (index, exercise) in exercises.enumerated() {
            exercise.order = Int(index)
        }
        try? context.save()
    }
}

#Preview {
    MuscleGroupView(currentMuscleGroup: pullDay)
}
