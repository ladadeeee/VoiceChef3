//
//  SingleRecipeView.swift
//  VoiceChef3
//
//  Created by Annamaria Fidanza on 12/12/24.
//

import SwiftUI
import AVFoundation

struct SingleRecipeView: View {
    let id: String
    
    @State private var meal: MealDetail? = nil
    @State private var speechManager = SpeechManager()
    
    var body: some View {
        ScrollView {
            if let meal {
                AsyncImage(url: meal.imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .accessibilityLabel("Loading recipe image")
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .background(Color.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .accessibilityLabel("Recipe image for \(meal.strMeal)")
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                            .accessibilityLabel("Recipe image not available")
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
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(meal.strMeal), \(meal.strCategory) recipe")
             
                Button(action: {
                    if speechManager.isSpeaking {
                        speechManager.stopSpeaking()
                    } else {
                        speechManager.speak(recipe: meal)
                    }
                }) {
                    HStack {
                    Image(systemName: speechManager.isSpeaking ? "speaker.slash.fill" : "speaker.wave.2.fill")
                        .foregroundColor(.white)
                        .accessibilityHidden(true)
                    Text(speechManager.isSpeaking ? "STOP" : "START")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(8)
                }
                .accessibilityLabel(speechManager.isSpeaking ? "Stop reading recipe" : "Start reading recipe")
                .accessibilityHint("Double tap to \(speechManager.isSpeaking ? "stop" : "start") voice reading")
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
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Ingredients list")
                    .accessibilityValue(meal.ingredients.map { "\($0.amount) \($0.name)" }.joined(separator: ", "))
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
                .accessibilityElement(children: .combine)
                                .accessibilityLabel("Cooking instructions")
                                .accessibilityValue(meal.strInstructions)
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
