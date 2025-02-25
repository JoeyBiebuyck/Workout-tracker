import SwiftUI
import SwiftData

struct AddGroupSheet: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \MuscleGroup.order, animation: .default) private var muscleGroups: [MuscleGroup]
    
    @State private var name: String = ""
    @State private var date: Date = .now
    @State private var groupDescription: String = ""
    @State private var textHeight: CGFloat = 40
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Group Name Input
                    CustomTextField(placeholder: "Muscle group name", text: $name)
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
                    
                    // Auto-Resizing TextEditor for Description
                    AutoResizingTextEditor(
                        text: $groupDescription,
                        placeholder: "Write a short description..."
                    )
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                }
                .padding()
            }
            .navigationTitle("New Muscle Group")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        addNewMuscleGroup()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func addNewMuscleGroup() {
        for group in muscleGroups {
            group.order += 1
        }
        
        let muscleGroup = MuscleGroup(
            name: name,
            groupDescription: groupDescription,
            lastDate: date,
            order: 0
        )
        
        context.insert(muscleGroup)
        try? context.save()
        
        dismiss()
    }
}

#Preview {
    AddGroupSheet()
}
