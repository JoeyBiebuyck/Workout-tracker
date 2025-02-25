//
//  ExerciseView.swift
//  Workout Tracker
//
//  Created by Joey on 08/02/2025.
//

import SwiftUI
import SwiftData
import Charts

struct ExerciseView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    @State var exercise: Exercise
    
    // Fetch all workout history
    @Query(sort: \WorkoutEntry.date) private var workoutHistory: [WorkoutEntry]
    
    // Filtered workout history for this exercise
    private var filteredWorkouts: [WorkoutEntry] {
        print("Total workout entries: \(workoutHistory.count)")
        print("Exercise name being filtered: \(exercise.name)")
        
        let workouts = workoutHistory
            .filter { $0.name == exercise.name } // make sure only workouts of the current exercise are passed through
            .filter { $0.weight.isFinite && $0.date.timeIntervalSince1970 > 0 }
            .sorted { $0.date > $1.date } // sort in reverse chronological order
        
        print("Filtered workout count: \(workouts.count)")
        return workouts
    }
    
    // Get the lowest and highest weight values
    private var lowestWeight: Double {
        filteredWorkouts.map { $0.weight }.min() ?? 0
    }

    private var highestWeight: Double {
        filteredWorkouts.map { $0.weight }.max() ?? 100
    }

    // Ensure the Y-axis always has at least a 10-unit range for readability
    private var yAxisRange: ClosedRange<Double> {
        let lowerBound = max(0, lowestWeight - 10)
        let upperBound = max(lowerBound + 10, highestWeight + 5) // Ensures at least a 10-unit range
        return lowerBound...upperBound
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("\(exercise.name) Progress")
                .font(.title2)
                .bold()
                .padding(.top, 10)

            if !filteredWorkouts.isEmpty {
                workoutChart
                    .frame(height: 300) // Standard readable height
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)

                Divider() // Visual separator
            } else {
                Text("No history available")
                    .foregroundColor(.gray)
                    .padding()
            }

            workoutList
        }
        .onAppear {
            // Debug print on view appear
            print("WorkoutHistory count: \(workoutHistory.count)")
            print("FilteredWorkouts count: \(filteredWorkouts.count)")
        }
    }

    // **Extracted Workout Chart View**
    private var workoutChart: some View {
        Chart {
            ForEach(filteredWorkouts) { entry in
                LineMark(
                    x: .value("Date", entry.date),
                    y: .value("Weight", entry.weight)
                )
                .interpolationMethod(.catmullRom) // Smooth line
                .symbol(.circle) // Adds dots at data points
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: .automatic) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
            }
            
            AxisMarks(position: .leading) {
                AxisValueLabel {
                    Text("kg  ")
                        .font(.caption)
                        .foregroundColor(Color.gray)
                        .padding(.bottom, 2)
                }
                .offset(x: -8) // Align properly
            }
        }
        .chartXAxis {
            AxisMarks(position: .bottom, values: .stride(by: xAxisStrideComponent, count: xAxisStrideCount)) { value in
                AxisTick()
                AxisValueLabel(format: xAxisLabelFormat)
            }
        }
        .chartYScale(domain: yAxisRange)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }

    // Compute the best tick interval outside of the chart (how many ticks the x-axis should have)
    private var xAxisStrideComponent: Calendar.Component {
        guard let firstDate = filteredWorkouts.first?.date,
              let lastDate = filteredWorkouts.last?.date else {
            return .day // Default: one tick per week if no data
        }
        
        let totalDays = Calendar.current.dateComponents([.day], from: firstDate, to: lastDate).day ?? 0
        
        switch totalDays {
            case 0...30: return .day   // Up to 1 month → show every 5 days
            case 31...180: return .day // 1-6 months → every 2 weeks
            case 181...365: return .month // 6-12 months → every month
            default: return .month  // More than 1 year → every 2 months
        }
    }

    // Determine the best tick count
    private var xAxisStrideCount: Int {
        guard let firstDate = filteredWorkouts.first?.date,
              let lastDate = filteredWorkouts.last?.date else {
            return 7 // Default: one tick per week if no data
        }
        
        let totalDays = Calendar.current.dateComponents([.day], from: firstDate, to: lastDate).day ?? 0
        
        switch totalDays {
            case 0...30: return 5   // Up to 1 month → show every 5 days
            case 31...180: return 14 // 1-6 months → every 2 weeks
            case 181...365: return 1 // 6-12 months → every month
            default: return 2  // More than 1 year → every 2 months
        }
    }

    // Determine the best label format based on the stride
    private var xAxisLabelFormat: Date.FormatStyle {
        if xAxisStrideComponent == .day {
            return .dateTime.day().month() // "Feb 8"
        } else {
            return .dateTime.month().year() // "Feb 2025"
        }
    }

    // **Extracted Workout List View**
    private var workoutList: some View {
        List {
            ForEach(filteredWorkouts, id: \.self) { workout in
                NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                    HStack(spacing: 12) {
                        // Date container with gradient accent
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [.blue.opacity(0.6), .purple.opacity(0.4)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 3, height: 30)
                            .cornerRadius(2)
                        
                        // Date and weight info
                        HStack {
                            Text(workout.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("\(workout.weight, specifier: "%.1f") kg")
                                .font(.footnote)
                                .foregroundColor(.primary.opacity(0.8))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(Color.gray.opacity(0.1))
                                )
                        }
                    }
                    .padding(.vertical, 4)
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.03))
                        .padding(.vertical, 2)
                )
                .listRowSeparator(.hidden)
            }
            .onDelete { indexSet in
                for index in indexSet {
                    let entryToDelete = filteredWorkouts[index]
                    context.delete(entryToDelete)
                }
                try? context.save()
            }
        }
        .listStyle(PlainListStyle())
        .scrollContentBackground(.hidden)
    }
    
}

#Preview {
    ExerciseView(exercise: zotmanCurl)
}
