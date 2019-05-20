//
//  Recipe.swift
//  assignment3
//
//  Created by Jacob Efendi on 5/19/19.
//  Copyright © 2019 group144. All rights reserved.
//

import Foundation

class Recipe {
    
    var name: String
    var prepTime: Int
    var cookingTime: Int
    var ingredients: [Ingredient]
    var methods: [String]
    
    init(name: String, prepTime: Int, cookingTime: Int, ingredients: [Ingredient], methods: [String]) {
        self.name = name
        self.prepTime = prepTime
        self.cookingTime = cookingTime
        self.ingredients = ingredients
        self.methods = methods
    }
}
