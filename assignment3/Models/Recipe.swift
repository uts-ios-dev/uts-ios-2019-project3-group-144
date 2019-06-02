import Foundation

// recipe object
class Recipe {
    
    var id: Int // the recipe's id number
    var name: String // the recipe's name
    var imageName: String // the name of the recipe's image
    var prepTime: Int // the time needed for preparation
    var cookingTime: Int // the time needed for cooking
    var ingredients: [String] // the list of ingredients in the recipe
    var methods: [String] // the list of methods in the recipe
    
    // initialiser
    init(id: Int, name: String, imageName: String, prepTime: Int, cookingTime: Int, ingredients: [String], methods: [String]) {
        self.id = id
        self.name = name
        self.imageName = imageName
        self.prepTime = prepTime
        self.cookingTime = cookingTime
        self.ingredients = ingredients
        self.methods = methods
    }
}
