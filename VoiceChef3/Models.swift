//
//  Models.swift
//  VoiceChef3
//
//  Created by Annamaria Fidanza on 12/11/24.
//

import Foundation

// First screen

struct CategoryList: Decodable {
    let categories: [Category]
}

struct Category: Decodable, Identifiable {
    let idCategory: String
    let strCategory: String
    let strCategoryThumb: String
    
    var id: String { idCategory }
    var imageURL: URL { URL(string: strCategoryThumb)! }
}

// Second screen

struct CategoryDetail: Decodable {
    let meals: [Meal]
}

struct Meal: Decodable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    
    var id: String { idMeal }
    var imageURL: URL { URL(string: strMealThumb)! }
}

// Recipe screen

struct MealDetailResult: Decodable {
    let meals: [MealDetail]
}

struct Ingredient {
    let name: String
    let amount: String
}

struct MealDetail: Decodable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    let ingredients: [Ingredient]
    let strInstructions: String
    let strCategory: String

    var id: String { idMeal }
    var imageURL: URL { URL(string: strMealThumb)! }
    
    enum CodingKeys: String, CodingKey {
        case idMeal, strMeal, strMealThumb, strInstructions, strCategory, strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5, strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10, strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15, strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20, strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5, strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10, strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15, strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idMeal = try container.decode(String.self, forKey: .idMeal)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strMealThumb = try container.decode(String.self, forKey: .strMealThumb)
        strInstructions = try container.decode(String.self, forKey: .strInstructions)
        strCategory = try container.decode(String.self, forKey: .strCategory)
        
        var ingredients = [Ingredient]()
        for i in 1...20 {
            let ingredient = try container.decode(String?.self, forKey: .init(stringValue: "strIngredient\(i)")!)
            let measure = try container.decode(String?.self, forKey: .init(stringValue: "strMeasure\(i)")!)
            if let ingredient, !ingredient.isEmpty {
                ingredients.append(Ingredient(name: ingredient, amount: measure!))
            }
        }
        self.ingredients = ingredients
    }
}
