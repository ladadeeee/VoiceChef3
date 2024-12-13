//
//  OneCategoryView.swift
//  VoiceChef3
//
//  Created by Annamaria Fidanza on 12/11/24.
//

import SwiftUI

struct OneCategoryView: View {
    let name: String
    let categoryName: String
    
    @State private var category: CategoryDetail? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if let category {
                    ForEach(category.meals) { meal in
                        NavigationLink(destination: SingleRecipeView(id: meal.idMeal), label: {
                            RecipeCell(meal: meal, categoryName: name)
                        })
                        
                    }.padding(.horizontal)
                }
            } .navigationTitle(categoryName)
        }
        .task {
            category = await callAPI("https://www.themealdb.com/api/json/v1/1/filter.php?c=\(name)")
        }
    }
}

struct RecipeCell: View {
    let meal: Meal
    let categoryName: String
    
    var body: some View {
        HStack (alignment: .top, spacing: 16){
            AsyncImage(url: meal.imageURL) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .background(Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Spacer()
                    Button(action: {
                        print("Favourite tapped!")
                    }) {
                        Image(systemName: "heart")
                            .foregroundColor(.orange)
                            .font(.title2)
                    }
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
    }
}


#Preview {
    OneCategoryView(name: "Seafood", categoryName: "Beef")
}
