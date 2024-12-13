//
//  CategoryGridView.swift
//  VoiceChef3
//
//  Created by Annamaria Fidanza on 12/11/24.
//

import SwiftUI

struct CategoryGridView: View {
    
    @State private var categories: [Category]? = nil
    @State private var searchText = ""
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 20) {
                    if let categories {
                        ForEach(categories) { category in
                            NavigationLink(destination: OneCategoryView(name: category.strCategory, categoryName: category.strCategory)) {
                                VStack(spacing: 10) {
                                    AsyncImage(url: category.imageURL) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .background(Color.accentColor.opacity(0.5))
                                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                        case .failure:
                                            Image(systemName: "photo")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(.gray)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    };Text(category.strCategory)
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                    }.padding(15)
            }
            .searchable(text: $searchText)
            .navigationTitle("VoiceChef")
            .task {
                let result: CategoryList? = await callAPI("https://www.themealdb.com/api/json/v1/1/categories.php")
                categories = result?.categories
            }
        }

    }
  
}

#Preview {
    CategoryGridView()
}

