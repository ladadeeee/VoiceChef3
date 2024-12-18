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
    
    private var filteredCategories: [Category] {
        guard let categories = categories else { return [] }
        if searchText.isEmpty {
            return categories
        }
        return categories.filter { $0.strCategory.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 20) {
                    if categories != nil {
                        ForEach(filteredCategories) { category in
                            NavigationLink(destination: OneCategoryView(name: category.strCategory, categoryName: category.strCategory)) {
                                VStack(spacing: 10) {
                                    AsyncImage(url: category.imageURL) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                                .accessibilityLabel("Loading \(category.strCategory) image")
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
                                                .accessibilityLabel("Image failed to load")
                                        @unknown default:
                                            EmptyView()
                                        }
                                    };Text(category.strCategory)
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.primary)
                                }
                                .accessibilityElement(children: .combine)
                                                                .accessibilityLabel("Category \(category.strCategory)")
                                                                .accessibilityHint("Double Tap to view recipes in this category")
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

