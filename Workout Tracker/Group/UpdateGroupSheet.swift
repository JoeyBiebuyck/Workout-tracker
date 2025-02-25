//
//  UpdateGroupSheet.swift
//  Workout Tracker
//
//  Created by Joey on 08/02/2025.
//

import SwiftUI
import SwiftData

struct UpdateGroupSheet: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var muscleGroup: MuscleGroup
    @State private var textHeight: CGFloat = 40 // Default height
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Group Name Input
                    CustomTextField(placeholder: "Muscle group name", text: $muscleGroup.name)
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
                            DatePicker("", selection: $muscleGroup.lastDate, displayedComponents: .date)
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
                                let now = Date()
                                muscleGroup.lastDate = now
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

                    
                    // Auto-Resizing TextEditor for Description
                    AutoResizingTextEditor(
                        text: $muscleGroup.groupDescription,
                        placeholder: "Write a short description..."
                    )
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    
                    //                    // Save Button
                    //                    Button(action: {
                    //                        let muscleGroup = MuscleGroup(
                    //                            name: name,
                    //                            groupDescription: groupDescription,
                    //                            lastDate: date
                    //                        )
                    //                        context.insert(muscleGroup)
                    //                        dismiss()
                    //                    }) {
                    //                        Text("Save")
                    //                            .font(.headline)
                    //                            .foregroundColor(.white)
                    //                            .frame(maxWidth: .infinity)
                    //                            .padding()
                    //                            .background(name.isEmpty ? Color.gray : Color.blue)
                    //                            .cornerRadius(10)
                    //                    }
                    //                    .disabled(name.isEmpty) // Prevent saving if name is empty
                    
                    .navigationTitle("Updating muscle group")
                    .navigationBarTitleDisplayMode(.large)
                    .toolbar {
                        ToolbarItemGroup(placement: .topBarTrailing) {
                            Button("Done") { dismiss() }
                        }
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    UpdateGroupSheet(muscleGroup: pullDay)
}
