import Foundation

// recipe object
class Recipe {
    
    var id: Int
    var name: String
    var prepTime: Int
    var cookingTime: Int
    var ingredients: [String]
    var methods: [String]
    
    // initialiser
    init(id: Int, name: String, prepTime: Int, cookingTime: Int, ingredients: [String], methods: [String]) {
        self.id = id
        self.name = name
        self.prepTime = prepTime
        self.cookingTime = cookingTime
        self.ingredients = ingredients
        self.methods = methods
    }
}
