//
//  FavouritesView.swift
//  VoiceChef3
//
//  Created by Annamaria Fidanza on 12/12/24.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Query private var favorites: [FavoriteRecipe]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if favorites.isEmpty {
                    Text("No favorites yet")
                        .foregroundColor(.gray)
                        .padding()
                        .accessibilityLabel("No favorite recipes have been added yet")
                } else {
                    ForEach(favorites) { favorite in
                        NavigationLink(destination: SingleRecipeView(id: favorite.id)) {
                            FavoriteCell(favorite: favorite)
                        }
                        .padding(.horizontal)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Recipe: \(favorite.name), Category: \(favorite.category)")
                        .accessibilityHint("Tap to view recipe details")

                    }
                }
            }
            .navigationTitle("Favorites")
            .accessibilityLabel("Favorites List")
        }
    }
}

struct FavoriteCell: View {
    let favorite: FavoriteRecipe
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            if let url = favorite.imageURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                        .accessibilityHidden(true)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .background(Color.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .accessibilityLabel("Recipe image for \(favorite.name)")
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                            .accessibilityLabel("No image available")
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(favorite.name)
                    .font(.headline)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "fork.knife")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .accessibilityHidden(true)
                    Text(favorite.category)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemOrange).opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.vertical, 4)
    }
}

#Preview {
    FavoritesView()
}
