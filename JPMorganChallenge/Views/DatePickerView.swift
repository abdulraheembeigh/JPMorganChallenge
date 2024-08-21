//
//  DatePickerView.swift
//  JPMorganChallenge
//
//  Created by Abdul Raheem Beigh on 20/08/2024.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    var onDateSelected: () -> Void
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack {
                    DatePicker("Select a date", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                    
                    Button("Load APOD") {
                        onDateSelected()
                        isPresented = false
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .navigationTitle("Pick a Date")
                .navigationBarItems(trailing: Button("Cancel") {
                    isPresented = false
                })
            }}
    }
}

#Preview {
    DatePickerView(selectedDate: .constant(Date()), isPresented: .constant(true), onDateSelected: {})
}
