//
//  APODTabView.swift
//  JPMorganChallenge
//
//  Created by Abdul Raheem Beigh on 20/08/2024.
//

import SwiftUI

struct APODTabView: View {
    @ObservedObject var viewModel: APODViewModel
    @State private var isDatePickerPresented = false
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationStack {
            APODView(viewModel: viewModel)
                .navigationTitle("NASA APOD")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isDatePickerPresented = true
                        }) {
                            Image(systemName: "calendar")
                        }
                    }
                }
                .sheet(isPresented: $isDatePickerPresented) {
                    DatePickerView(selectedDate: $selectedDate, isPresented: $isDatePickerPresented) {
                        Task{
                            await viewModel.fetchAPODAsync(for: selectedDate)
                        }
                    }
                }
        }
    }
}

#Preview {
    APODTabView(viewModel: APODViewModel(apodService: APODService()))
}
