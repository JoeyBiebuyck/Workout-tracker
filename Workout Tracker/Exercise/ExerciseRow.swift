//
//  ExerciseRow.swift
//  Workout Tracker
//
//  Created by Joey on 08/02/2025.
//

import SwiftUI

import SwiftUI

struct ExerciseRow: View {
    var exercise: Exercise

    var body: some View {
        HStack {
            // Left side: Exercise Name and alternative name (if there is any)
            VStack(alignment: .leading) { // Align content to the left
                Text(exercise.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if !exercise.alternativeExerciseName.isEmpty {
                    Text(exercise.alternativeExerciseName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading) // Ensure the VStack expands fully and aligns left


            Spacer()

            // Right side: Date & Weight
            VStack(alignment: .trailing, spacing: 2) {
                Text(formattedDate(exercise.lastDate))
                    .font(.caption)
                    .foregroundColor(.gray)

                Text("\(exercise.weight, specifier: "%.1f") kg") // display weight with 1 decimal
                    .font(.caption)
                    .foregroundColor(.primary)
                    .opacity(0.7)            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
    }

    /// Formats the date for display
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // Adjust this for different formats
        return formatter.string(from: date)
    }
}

#Preview {
    ExerciseRow(exercise: zotmanCurl)
}
