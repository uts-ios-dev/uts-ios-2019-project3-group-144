

import Foundation
import CoreData

// controller containing core data functions (CRUD)
class CoreDataController {
    
    // function to randomly generate unique id for recipe
    static func generateId() -> Int {
        var id: Int = Int(arc4random())
        
        // ensures the generated id is positive
        if (id < 0) {
            id = id * -1
        }
        
        // todo: implement code to ensure id is unique (jacob)
        return id
    }
    
    // function to get recipe data
    static func getRecipeData(delegate: AppDelegate) -> [NSManagedObject] {
        
        // array to contain recipes
        var recipes: [NSManagedObject] = []
        
        // setup context and fetch request
        let context = delegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "RecipeData")
        
        // attempt to fetch recipe data
        do { recipes = try context.fetch(fetchRequest) }
        catch let error as NSError { print("Could not fetch. \(error), \(error.userInfo)") }
        
        // return the recipes
        return recipes
    }
    
    // function to get single recipe
    static func hasRecipe(delegate: AppDelegate, recipe: Recipe) -> Bool {
        
        // get recipes
        let recipeData = getRecipeData(delegate: delegate)
        
        // return true if there is a recipe with the same id
        for data in recipeData {
            let id = data.value(forKey: "id") as? Int
            if (id == recipe.id) {
                return true
            }
        }
        
        // if there are no recipes, return false
        return false
    }
    
    // function to save recipe to core data
    static func saveRecipeData(delegate: AppDelegate, recipe: Recipe) {
        
        // set up context and entity data
        let context = delegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "RecipeData", in: context)!
        
        // create object to be saved
        let recipeData = NSManagedObject(entity: entity, insertInto: context)
        
        // insert values into object
        recipeData.setValue(recipe.id, forKey: "id")
        recipeData.setValue(recipe.name, forKey: "name")
        recipeData.setValue(recipe.imageName, forKey: "imageName")
        recipeData.setValue(recipe.prepTime, forKey: "prepTime")
        recipeData.setValue(recipe.cookingTime, forKey: "cookingTime")
        recipeData.setValue(recipe.ingredients, forKey: "ingredients")
        recipeData.setValue(recipe.methods, forKey: "methods")
        
        // attempt to save new recipe to core data
        do { try context.save() }
        catch let error as NSError { print("Could not save. \(error), \(error.userInfo)") }
    }
    
    // todo: implement function to update existing recipe (andy)
    static func updateRecipeData(delegate: AppDelegate, recipe: Recipe) {
        // set up the context and get a list of all recipes in the core data
        let context = delegate.persistentContainer.viewContext
        let recipeData = getRecipeData(delegate: delegate)
        
        // look for the recipe that has a matching id and update it
        for data in recipeData {
            if(data.value(forKey: "id") as? Int == recipe.id) {
                print("updating data...")
                data.setValue(recipe.name, forKey: "name")
                data.setValue(recipe.prepTime, forKey: "prepTime")
                data.setValue(recipe.cookingTime, forKey: "cookingTime")
                data.setValue(recipe.ingredients, forKey: "ingredients")
                data.setValue(recipe.methods, forKey: "methods")
            }
        }
        
        // attempt to save the recipes without the deleted recipe
        do { try context.save() }
        catch let error as NSError { print("Could not save. \(error), \(error.userInfo)") }
    }
    
    // funciton to delete a recipe from core data
    static func deleteRecipeData(delegate: AppDelegate, id: Int) {
        
        // set up the context and get a list of all recipes in the core data
        let context = delegate.persistentContainer.viewContext
        let recipeData = getRecipeData(delegate: delegate)
        
        // look for the recipe that has a matching name and delete it
        for data in recipeData {
            if(data.value(forKey: "id") as? Int == id) {
                context.delete(data)
            }
        }
        
        // attempt to save the recipes without the deleted recipe
        do { try context.save() }
        catch let error as NSError { print("Could not save. \(error), \(error.userInfo)") }
    }
}
