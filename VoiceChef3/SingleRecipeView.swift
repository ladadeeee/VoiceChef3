//
//  SingleRecipeView.swift
//  VoiceChef3
//
//  Created by Annamaria Fidanza on 12/12/24.
//

import SwiftUI

struct SingleRecipeView: View {
    let id: String
    
    @State private var meal: MealDetail? = nil
    
    var body: some View {
        ScrollView {
            if let meal {
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
                
                VStack(alignment: .leading) {
                    Text(meal.strMeal)
                        .font(.largeTitle)
                        .bold()
                    
                    Text(meal.strCategory)
                        .font(.subheadline)
                        .foregroundColor(.orange)
                }
                
                // Pulsante "Start"
                Button(action: {
                    print("Start tapped!")
                }) {
                    HStack {
                        Image(systemName: "speaker.wave.2.fill")
                            .foregroundColor(.white)
                        Text("START")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(8)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ingredients")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.orange)
                        
                        
                        ForEach(meal.ingredients, id: \.name) { ingredient in
                            Text("\(ingredient.name) - \(ingredient.amount)")
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                    }
                    Spacer()
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Instructions")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.orange)
                    
                    Text(meal.strInstructions)
                        .font(.body)
                        .foregroundColor(.primary)
                }
            }
        } .padding()
        .task {
            let result: MealDetailResult? = await callAPI("https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(id)")
            meal = result?.meals.first
        }
    }
}

#Preview {
    SingleRecipeView(id: "52772")
}
