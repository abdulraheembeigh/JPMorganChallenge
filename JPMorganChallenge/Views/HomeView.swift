//
//  HomeView.swift
//  JPMorganChallenge
//
//  Created by Abdul Raheem Beigh on 18/08/2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel : APODViewModel
    @State private var selectedDate = Date()
    init() {
        let networkService = NetworkService()
        let apodService = APODService(networkService: networkService)
        _viewModel = StateObject(wrappedValue: APODViewModel(apodService: apodService))
    }
    var body: some View {
        TabView {
            APODTabView(viewModel: viewModel)
                .tabItem {
                    Label("APOD", systemImage: "photo")
                }
            FutureFeatureView()
                .tabItem {
                    Label("Future", systemImage: "square.3.stack.3d.top.filled")
                }
        }
    }
}


#Preview {
    HomeView()
}
