//
//  CustomTextField.swift
//  Workout Tracker
//
//  Created by Joey on 09/02/2025.
//

import SwiftUI
import SwiftData

/// Custom Single-Line Input Field
struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(placeholder)
                .font(.headline)
                .foregroundColor(.primary)
            
            TextField(placeholder, text: $text)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
}
