//
//  CustomInputField.swift
//  Workout Tracker
//
//  Created by Joey on 09/02/2025.
//

import SwiftUI
import SwiftData

/// Custom Number Input Field with a Suffix
struct CustomInputField<T: Numeric & LosslessStringConvertible & CVarArg>: View {
    var title: String
    @Binding var value: T
    var suffix: String
    @State private var textValue: String = ""
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                TextField(title, text: $textValue)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
                    .onChange(of: textValue) { oldValue, newValue in
                        let filtered = newValue.filter { $0.isNumber || $0 == "." }
                        if filtered != newValue {
                            textValue = filtered
                        }
                        if let numberValue = T(filtered) {
                            value = numberValue
                        }
                    }
                    .onAppear {
                        textValue = formattedValue(value)
                    }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            
            Text(suffix)
                .foregroundColor(.gray)
                .font(.headline)
                .padding(.top, 20)
                .padding(.horizontal, 10)
        }
    }
    
    private func formattedValue(_ value: T) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: Double("\(value)") ?? 0)) ?? "\(value)"
    }
}
