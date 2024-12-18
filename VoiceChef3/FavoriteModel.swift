//
//  FavouriteModel.swift
//  VoiceChef3
//
//  Created by Annamaria Fidanza on 12/16/24.
//

import Foundation
import SwiftData

@Model
class FavoriteRecipe {
    var id: String
    var name: String
    var imageURL: URL?
    var category: String
    
    init(id: String, name: String, imageURL: URL?, category: String) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.category = category
    }
}
