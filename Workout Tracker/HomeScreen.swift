import SwiftUI
import SwiftData

struct HomeScreen: View {
    @Environment(\.modelContext) private var context
    @State private var isShowingItemSheet = false
    @Query(sort: \MuscleGroup.order) private var muscleGroups: [MuscleGroup]
    @State private var groupToEdit: MuscleGroup?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(muscleGroups) { group in
                    NavigationLink(destination: MuscleGroupView(currentMuscleGroup: group)) {
                        HStack {
                            Image(systemName: "line.3.horizontal")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                            
                            MuscleGroupRow(muscleGroup: group)
                            
                            Spacer()
                            
                            // Wrap the pencil in a Button and use simultaneousGesture
                            Button {
                                groupToEdit = group
                            } label: {
                                Image(systemName: "pencil")
                                    .foregroundColor(.blue)
                            }
                            .simultaneousGesture(TapGesture().map { _ in
                                // Prevent navigation when tapping the pencil
                                groupToEdit = group
                            })
                        }
                        .padding(.vertical, 5)
                    }
                }
                .onMove(perform: moveMuscleGroups)
                .onDelete(perform: deleteMuscleGroups)
            }
            .listStyle(.plain)
            .navigationTitle("Muscle Groups")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isShowingItemSheet) {
                AddGroupSheet()
            }
            .sheet(item: $groupToEdit) { group in
                UpdateGroupSheet(muscleGroup: group)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if !muscleGroups.isEmpty {
                        Button {
                            isShowingItemSheet = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .overlay {
                if muscleGroups.isEmpty {
                    ContentUnavailableView(
                        label: {
                            Label("No muscle groups", systemImage: "list.bullet.rectangle.portrait")
                        },
                        description: {
                            Text("Add muscle groups to see them listed")
                        },
                        actions: {
                            Button("Add muscle groups") {
                                isShowingItemSheet = true
                            }
                        }
                    )
                }
            }
        }
    }
    
    private func moveMuscleGroups(from source: IndexSet, to destination: Int) {
           // Get the items being moved
           let itemsToMove = source.map { muscleGroups[$0] }
           
           // Create a copy of the current order
           var updatedGroups = muscleGroups.map { $0 }
           updatedGroups.move(fromOffsets: source, toOffset: destination)
           
           // Update all orders to match new positions
           for (index, group) in updatedGroups.enumerated() {
               group.order = index
           }
           
           try? context.save()
       }
       
       private func deleteMuscleGroups(at offsets: IndexSet) {
           withAnimation {
               // Delete the items
               for index in offsets {
                   context.delete(muscleGroups[index])
               }
               
               // Reorder remaining items to ensure no gaps
               let remainingGroups = muscleGroups.filter { !offsets.contains(muscleGroups.firstIndex(of: $0) ?? -1) }
               for (index, group) in remainingGroups.enumerated() {
                   group.order = index
               }
               
               try? context.save()
           }
       }
    
    private func reorderMuscleGroups() {
        // Ensure consistent ordering after deletions
        for (index, group) in muscleGroups.enumerated() {
            group.order = Int(index)
        }
        try? context.save()
    }
}

// Preview provider
#Preview {
    HomeScreen()
}
