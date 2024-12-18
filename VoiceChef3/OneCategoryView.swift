//
//  OneCategoryView.swift
//  VoiceChef3
//
//  Created by Annamaria Fidanza on 12/11/24.
//

import SwiftUI
import SwiftData

struct OneCategoryView: View {
    let name: String
    let categoryName: String
    
    @State private var category: CategoryDetail? = nil
    @State private var searchText = ""
    
    private var filteredMeals: [Meal] {
           guard let category = category else { return [] }
           if searchText.isEmpty {
               return category.meals
           }
           return category.meals.filter { $0.strMeal.localizedCaseInsensitiveContains(searchText) }
       }

    var body: some View {
        NavigationStack {
            ScrollView {
                if let category {
                    ForEach(filteredMeals) { meal in
                        NavigationLink(destination: SingleRecipeView(id: meal.idMeal), label: {
                            RecipeCell(meal: meal, categoryName: name)
                        })
                        .accessibilityHint("Tap to view full recipe details")
                    }.padding(.horizontal)
                }
            } .searchable(text: $searchText)
                .navigationTitle(categoryName)
                .accessibilityLabel("\(categoryName) recipes")
        }
        .task {
            category = await callAPI("https://www.themealdb.com/api/json/v1/1/filter.php?c=\(name)")
        }
    }
}

struct RecipeCell: View {
    let meal: Meal
    let categoryName: String
    
    @Environment(\.modelContext) private var modelContext
        @Query private var favoriteRecipes: [FavoriteRecipe]
        @State private var isFavorite = false
    
    var body: some View {
        HStack (alignment: .top, spacing: 16){
            AsyncImage(url: meal.imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .accessibilityLabel("Loading \(meal.strMeal) image")
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .background(Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .accessibilityHidden(true)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                        .accessibilityLabel("Image not available")
                    
                @unknown default:
                    EmptyView()
                }
            }
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Spacer()
                    Button(action: {
                        toggleFavorite()
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(.orange)
                            .font(.title2)
                    }
                    .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
                }
                Spacer()
                Text(meal.strMeal)
                    .font(.headline)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    Text("15 min")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                
                    Image(systemName: "fork.knife")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    Text(categoryName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
        }
        .padding()
        .background(Color(UIColor.systemOrange).opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
                .accessibilityLabel("\(meal.strMeal), \(categoryName) recipe")
                .accessibilityValue("Cooking time: 15 minutes. \(isFavorite ? "Added to favorites" : "Not in favorites")")
        .onAppear {
            checkIfFavorite()
        }
    }
    private func toggleFavorite() {
            if isFavorite {
                if let favorite = favoriteRecipes.first(where: { $0.id == meal.idMeal }) {
                    modelContext.delete(favorite)
                }
            } else {
                let favorite = FavoriteRecipe(
                    id: meal.idMeal,
                    name: meal.strMeal,
                    imageURL: meal.imageURL,
                    category: categoryName
                )
                modelContext.insert(favorite)
            }
            isFavorite.toggle()
        }
        
        private func checkIfFavorite() {
            isFavorite = favoriteRecipes.contains { $0.id == meal.idMeal }
        }
    }



#Preview {
    OneCategoryView(name: "Seafood", categoryName: "Beef")
}
