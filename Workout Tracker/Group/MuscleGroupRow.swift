//
//  MuscleGroupRow.swift
//  Workout Tracker
//
//  Created by Joey on 08/02/2025.
//

import Foundation
import SwiftUI

import SwiftUI

struct MuscleGroupRow: View {
    var muscleGroup: MuscleGroup

    var body: some View {
        HStack {
            // Left side: Muscle Group Name & Description
            VStack(alignment: .leading, spacing: 4) {
                Text(muscleGroup.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                if !muscleGroup.groupDescription.isEmpty {
                    Text(muscleGroup.groupDescription)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1) // 👈 Ensures truncation
                        .truncationMode(.tail)
                }
            }

            Spacer()

            // Right side: Last Workout Date
            Text(formattedDate(muscleGroup.lastDate))
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
    }

    /// Formats the date for display
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // Change this for different formats
        return formatter.string(from: date)
    }
}

#Preview {
    MuscleGroupRow(muscleGroup: pullDay)
}
