//
//  APODView.swift
//  JPMorganChallenge
//
//  Created by Abdul Raheem Beigh on 18/08/2024.
//

import SwiftUI


struct APODView: View {
    @ObservedObject var viewModel: APODViewModel
    
    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if viewModel.isLoading {
                        ProgressView()
                    } else if let apod = viewModel.apod {
                        Text(apod.title)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(apod.date)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        if apod.mediaType == "image" {
                            if let url = URL(string: apod.url){
                                CacheAsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .cornerRadius(10)
                                                .clipped()
                                        case .failure(let error):
                                            Text("Error: \(error.localizedDescription)")
                                        @unknown default:
                                            EmptyView()
                                        }
                                }
                            }else{
                                Text("No Image available")
                            }
                        } else if apod.mediaType == "video" {
                            WebView(urlString: apod.url).frame(height: 300)
                        }
                        
                        Text(apod.explanation)
                            .font(.body)
                    } else if let errorMessage = viewModel.errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                    }
                }
                .padding()
            }
            .task {
                await viewModel.fetchAPODAsync()
            }
    }
}

#Preview {
    APODView(viewModel: APODViewModel(apodService: APODService()))
}

