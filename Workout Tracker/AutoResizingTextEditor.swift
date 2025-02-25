//
//  AutoResizingTextEditor.swift
//  Workout Tracker
//
//  Created by Joey on 09/02/2025.
//

import SwiftUI

struct AutoResizingTextEditor: View {
    @Binding var text: String
    let placeholder: String
    @State private var textEditorHeight: CGFloat = 100  // Default height
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Description")
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .font(.headline)
                .foregroundColor(.primary)
            
            ZStack(alignment: .topLeading) {
                // Background
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(UIColor.systemGray6))
                
                // Placeholder
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.gray.opacity(0.6))
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                }
                
                // Actual TextEditor (aka inner textbox)
                TextEditor(text: $text)
                    .cornerRadius(10) // corner radius of the inner textbox (the actual place where you type the text)
                    .frame(minHeight: 100, maxHeight: max(textEditorHeight, 100))
                    .background(GeometryReader { geometry in
                        Color.clear.preference(
                            key: ViewHeightKey.self,
                            value: geometry.size.height
                        )
                    })
                    .onPreferenceChange(ViewHeightKey.self) { height in
                        textEditorHeight = height
                    }
                    .padding(12)
            }
            .frame(minHeight: max(textEditorHeight + 24, 124))  // Add padding to total height
        }
    }
}

// Height preference key to track TextEditor content height
struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
